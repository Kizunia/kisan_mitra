import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'fertilizer_search_model.dart';
import 'geo_service.dart';
import 'ranking_service.dart';
import 'mapbox_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/firestore_service.dart'; // Assuming this exists
import 'rating_utils.dart';

class FertilizerSearchController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final GeoService _geoService = GeoService();
  final RankingService _rankingService = RankingService();
  final MapboxService _mapboxService = MapboxService();
  final FirestoreService _firestoreService = FirestoreService();

  // State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  StoreSearchResult? _bestShop;
  StoreSearchResult? get bestShop => _bestShop;

  List<StoreSearchResult> _stores = [];
  List<StoreSearchResult> get stores => _stores;

  Fertilizer? _selectedFertilizer;
  Fertilizer? get selectedFertilizer => _selectedFertilizer;

  List<LatLng> _routePolyline = [];
  List<LatLng> get routePolyline => _routePolyline;

  List<Fertilizer> _suggestions = [];
  List<Fertilizer> get suggestions => _suggestions;

  List<Fertilizer> _allFertilizersCache = [];

  // Search
  Future<void> initialize() async {
    await _getCurrentLocation();
    // Cache fertilizers for autocomplete
    await _cacheAllFertilizers();
  }

  Future<void> _cacheAllFertilizers() async {
    final result = await _firestoreService.getCollection(
      AppConstants.fertilizerMasterCollection,
    );
    if (result['success'] == true) {
      _allFertilizersCache = (result['data'] as List)
          .map((d) => Fertilizer.fromMap(d, d['id']))
          .toList();
    }
  }

  void filterSuggestions(String query) {
    if (query.isEmpty) {
      _suggestions = [];
    } else {
      _suggestions = _allFertilizersCache
          .where(
            (f) =>
                f.name.toLowerCase().contains(query.toLowerCase()) &&
                f.isActive,
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> _getCurrentLocation() async {
    _isLoading = true;
    _error = null; // Clear any previous error when retrying
    notifyListeners();
    try {
      _currentPosition = await _geoService.getCurrentLocation();
      _error = null; // Clear error on success
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchFertilizer(String query) async {
    if (query.isEmpty) {
      _stores = [];
      _bestShop = null;
      _selectedFertilizer = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _selectedFertilizer = null;
    _stores = [];
    _bestShop = null;
    _routePolyline = [];
    notifyListeners();

    try {
      // 1. Fetch Fertilizer from Master List
      Map<String, dynamic> fertilizerData;
      try {
        fertilizerData = await _firestoreService.queryDocuments(
          collection: AppConstants.fertilizerMasterCollection,
          fieldPath: 'name',
          isEqualTo: query,
        );
      } catch (e) {
        _error = 'Error querying fertilizer master: $e';
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (fertilizerData['success'] == true) {
        List docs = fertilizerData['documents'];
        if (docs.isNotEmpty) {
          print('DEBUG: Found ${docs.length} documents for query "$query"');

          // Convert all to models first to use the robust fromMap logic
          List<Fertilizer> potentialMatches = docs.map((d) {
            print('DEBUG: Doc Data: ${d}');
            return Fertilizer.fromMap(d, d['id']);
          }).toList();

          // Find first active fertilizer
          try {
            _selectedFertilizer = potentialMatches.firstWhere(
              (f) => f.isActive,
            );
            print(
              'DEBUG: Selected active fertilizer: ${_selectedFertilizer!.name}',
            );
          } catch (e) {
            print('DEBUG: No active fertilizer found in potential matches.');
            _error = 'Fertilizer found but marked inactive';
            _isLoading = false;
            notifyListeners();
            return;
          }
        } else {
          _error = 'Fertilizer not found in master list';
          _isLoading = false;
          notifyListeners();
          return;
        }
      } else {
        _error = fertilizerData['message'] ?? 'Error fetching fertilizer';
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (_selectedFertilizer == null) return;

      // 2. Fetch Store-Fertilizer Links (Stock & Price)
      // Primary Strategy: Query by Fertilizer ID
      Map<String, dynamic> stockData;
      try {
        stockData = await _firestoreService.queryDocuments(
          collection: AppConstants.storeFertilizersCollection,
          fieldPath: 'fertilizerId',
          isEqualTo: _selectedFertilizer!.id,
        );
      } catch (e) {
        if (e.toString().contains('permission-denied') || e.toString().contains('permission denied')) {
          print('DEBUG: Ignoring permission error for stock query and using fallback');
          stockData = {'success': true, 'documents': []};
        } else {
          _error = 'Error querying stock: $e';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Secondary Strategy: Query by Fertilizer Name (Fallback)
      // If primary returned nothing, or if we want to be robust
      if (stockData['success'] == true &&
          (stockData['documents'] as List).isEmpty) {
        try {
          print(
            'DEBUG: ID match failed, trying Name match for ${_selectedFertilizer!.name}',
          );
          stockData = await _firestoreService.queryDocuments(
            collection: AppConstants.storeFertilizersCollection,
            fieldPath: 'fertilizerName',
            isEqualTo: _selectedFertilizer!.name,
          );
        } catch (e) {
          print('DEBUG: Name match error: $e');
        }
      }

      // Map storeId -> {price, stock}
      Map<String, Map<String, dynamic>> fertilizerStockMap = {};

      if (stockData['success'] == true) {
        for (var doc in stockData['documents']) {
          String sId = doc['storeId']?.toString() ?? '';
          if (sId.isNotEmpty) {
            fertilizerStockMap[sId] = {
              'price': (doc['price'] as num?)?.toDouble() ?? 0.0,
              'stock': (doc['stock'] as num?)?.toInt() ?? 0,
              'isAvailable': doc['isAvailable'] == true,
            };
          }
        }
      }

      // If still empty, use fallback: show all verified stores with default price
      // This handles cases where storeFertilizers data is not synced
      bool usingFallback = fertilizerStockMap.isEmpty;
      if (usingFallback) {
        print(
          'DEBUG: No stock data found. Using fallback strategy - showing all verified stores.',
        );
        // We'll create default entries for all verified stores
        // This will be populated after fetching all stores
      }

      // 3. Fetch All Stores (To get location/details)
      // Optimization: We could filter by IDs if we had a batch query, but
      // getting all active stores is fine since we cache it or it's small.
      Map<String, dynamic> storesData;
      try {
        storesData = await _firestoreService.getCollection(
          AppConstants.storesCollection,
        );
      } catch (e) {
        _error = 'Error fetching stores: $e';
        _isLoading = false;
        notifyListeners();
        return;
      }

      List<Store> allStores = [];
      if (storesData['success'] == true) {
        final storesList = storesData['data'];
        print('DEBUG: Total stores in database: ${storesList.length}');

        for (var doc in storesList) {
          try {
            final store = Store.fromMap(doc, doc['id']);
            allStores.add(store);
          } catch (e) {
            print('DEBUG: Error parsing store ${doc['id']}: $e');
          }
        }
        print('DEBUG: Successfully loaded $allStores.length stores');
      } else {
        _error = storesData['message'] ?? 'Error fetching stores list';
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (allStores.isEmpty) {
        _error = 'No stores available in the system.';
        _stores = [];
        _bestShop = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (!usingFallback && fertilizerStockMap.isNotEmpty) {
        final storeIdSet = allStores.map((s) => s.id).toSet();
        final hasMatch = fertilizerStockMap.keys.any(storeIdSet.contains);
        if (!hasMatch) {
          usingFallback = true;
          print(
            'DEBUG: Stock IDs do not match any store IDs. Enabling fallback.',
          );
        }
      }

      // 4. Filter and Rank Stores
      await _processStores(allStores, fertilizerStockMap, usingFallback);
    } catch (e) {
      _error = 'Search failed: $e';
    } finally {
      if (_stores.isEmpty && _error == null) {
        _error = 'No stores found nearby.';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _processStores(
    List<Store> allStores,
    Map<String, Map<String, dynamic>> stockMap,
    bool usingFallback,
  ) async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) {
        _error =
            'Unable to get your location. Please enable location services.';
        _stores = [];
        _bestShop = null;
        return;
      }
    }

    List<StoreSearchResult> tempResults = [];
    print(
      'DEBUG: Processing ${allStores.length} stores against ${stockMap.length} stock entries...',
    );
    print(
      'DEBUG: Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
    );

    // Debug stats
    int droppedVerified = 0;
    int droppedStock = 0; // Not in stockMap
    int droppedDistance = 0;
    int droppedBadLocation = 0;

    for (var store in allStores) {
      // Filter 1: Check if store has valid location data
      if (store.latitude == 0.0 && store.longitude == 0.0) {
        droppedBadLocation++;
        print(
          'DEBUG: Dropped store ${store.storeName} (id: ${store.id}) - Invalid Location (0,0)',
        );
        continue;
      }

      // Filter 2: Is Verified
      // In fallback mode, we still only show verified stores
      if (!store.isVerified) {
        droppedVerified++;
        print(
          'DEBUG: Dropped store ${store.storeName} (id: ${store.id}) - Not Verified',
        );
        continue; // Always skip unverified stores
      }

      // Filter 3: Has Stock (Check if storeId exists in our map)
      // In fallback mode, skip this check and show all verified stores
      if (!usingFallback && !stockMap.containsKey(store.id)) {
        droppedStock++;
        print(
          'DEBUG: Dropped store ${store.storeName} (id: ${store.id}) - No Stock Entry',
        );
        continue;
      }

      var stockInfo = stockMap.containsKey(store.id)
          ? stockMap[store.id]!
          : (usingFallback
                ? null
                : {'price': 0.0, 'stock': 1, 'isAvailable': true});

      if (stockInfo == null && !usingFallback) continue;
      stockInfo ??= {'price': null, 'stock': 1, 'isAvailable': true};

      // Calculate Distance
      double distance = _geoService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        store.latitude,
        store.longitude,
      );

      print('DEBUG: Store ${store.storeName} distance: $distance km');

      // Filter 4: Radius - 5KM radius as per requirement
      const double searchRadius = 5.0;
      if (distance <= searchRadius) {
        tempResults.add(
          StoreSearchResult(
            store: store,
            distance: distance,
            score: 0.0, // Calculated in ranking service
            price: (stockInfo['price'] as num?)?.toDouble(),
            inStock: ((stockInfo['stock'] as num?)?.toInt() ?? 1) > 0,
          ),
        );
      } else {
        droppedDistance++;
        print(
          'DEBUG: Dropped store ${store.storeName} (id: ${store.id}) - Too Far ($distance km > ${searchRadius}km)',
        );
      }
    }

    // Smart Ranking
    if (tempResults.isNotEmpty) {
      _stores = _rankingService.rankStores(tempResults);
      _bestShop = _stores.isNotEmpty ? _stores.first : null;
      _error = null; // Clear any previous errors
      print('DEBUG: Found ${_stores.length} stores after ranking');
    } else {
      _stores = [];
      _bestShop = null;

      print(
        'DEBUG: droppedVerified=$droppedVerified, droppedStock=$droppedStock, droppedDistance=$droppedDistance, droppedBadLocation=$droppedBadLocation',
      );
      print('DEBUG: Using fallback: $usingFallback');
      print(
        'DEBUG: Stock map size: ${stockMap.length}, Total stores: ${allStores.length}',
      );

      // Only set error message if no stores were found
      _error =
          'No stores found within 5km radius.\n'
          'Please check your location and try again.';
    }
  }

  Future<void> navigateToStore(Store store) async {
    if (_currentPosition == null) return;

    _isLoading = true; // Maybe local loading state for map?
    notifyListeners();

    try {
      _routePolyline = await _mapboxService.getRoute(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        LatLng(store.latitude, store.longitude),
      );
    } catch (e) {
      print('Navigation error: $e');
      _error = 'Could not fetch route';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get bounds for the current route to fit in camera view
  Map<String, double>? getRouteBounds() {
    if (_routePolyline.isEmpty) return null;

    double minLat = _routePolyline.first.latitude;
    double maxLat = _routePolyline.first.latitude;
    double minLng = _routePolyline.first.longitude;
    double maxLng = _routePolyline.first.longitude;

    for (var point in _routePolyline) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLng': minLng,
      'maxLng': maxLng,
      'centerLat': (minLat + maxLat) / 2,
      'centerLng': (minLng + maxLng) / 2,
    };
  }

  Future<Map<String, dynamic>> rateStore(Store store, double newRating) async {
    final userId = _authService.currentUserId;
    if (userId == null) {
      _error = 'Please sign in to rate stores.';
      notifyListeners();
      return {'success': false, 'message': _error};
    }

    if (newRating < 1 || newRating > 5) {
      _error = 'Rating must be between 1 and 5 stars.';
      notifyListeners();
      return {'success': false, 'message': _error};
    }

    _isLoading = true;
    notifyListeners();
    try {
      final db = FirebaseFirestore.instance;
      final storeRef = db.collection(AppConstants.storesCollection).doc(store.id);
      final ratingRef = storeRef.collection('ratings').doc(userId);

      await db.runTransaction((transaction) async {
        final storeSnapshot = await transaction.get(storeRef);
        if (!storeSnapshot.exists) {
          throw Exception('Store not found');
        }

        final storeData = storeSnapshot.data() as Map<String, dynamic>? ?? const {};
        final double currentRating = (storeData['rating'] as num?)?.toDouble() ?? store.rating;
        final int currentReviews = (storeData['totalReviews'] as num?)?.toInt() ?? store.totalReviews;
        final double currentRatingSum = (storeData['ratingSum'] as num?)?.toDouble() ??
            (currentReviews > 0 ? currentRating * currentReviews : 0.0);

        final ratingSnapshot = await transaction.get(ratingRef);
        final double? previousUserRating = ratingSnapshot.exists
            ? (ratingSnapshot.data()?['rating'] as num?)?.toDouble()
            : null;

        final updated = calculateStoreRatingUpdate(
          currentRating: currentRating,
          currentReviews: currentReviews,
          currentRatingSum: currentRatingSum,
          newRating: newRating,
          previousUserRating: previousUserRating,
        );

        transaction.set(
          ratingRef,
          {
            'storeId': store.id,
            'userId': userId,
            'rating': newRating,
            'updatedAt': FieldValue.serverTimestamp(),
            if (!ratingSnapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        transaction.update(storeRef, {
          'rating': updated.rating,
          'totalReviews': updated.totalReviews,
          'ratingSum': updated.ratingSum,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      if (_selectedFertilizer != null) {
        await searchFertilizer(_selectedFertilizer!.name);
      }
      return {'success': true, 'message': 'Store rated successfully'};
    } catch (e) {
      _error = 'Failed to submit rating: $e';
      return {'success': false, 'message': _error};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
