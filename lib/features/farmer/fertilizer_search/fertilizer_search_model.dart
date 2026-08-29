class Fertilizer {
  final String id;
  final String name;
  final String npkComposition;
  final String category;
  final String imageUrl;
  final bool isActive;
  final String description;
  final String suitableCrops;
  final String recommendedDosage;
  final String manufacturer;

  Fertilizer({
    required this.id,
    required this.name,
    required this.npkComposition,
    required this.category,
    required this.imageUrl,
    required this.isActive,
    required this.description,
    required this.suitableCrops,
    required this.recommendedDosage,
    this.manufacturer = '',
  });

  factory Fertilizer.fromMap(Map<String, dynamic> data, String id) {
    bool active = true; // Default to true if field is missing

    // Helper to check a value
    bool checkValue(dynamic val) {
      if (val == null) return false;
      if (val == true) return true;
      if (val is num && val == 1) return true;
      if (val is String) {
        final v = val.toLowerCase();
        return v == 'true' || v == '1' || v == 'yes' || v == 'active';
      }
      return false;
    }

    if (data.containsKey('is_active')) {
      active = checkValue(data['is_active']);
    } else if (data.containsKey('isActive')) {
      active = checkValue(data['isActive']);
    } else if (data.containsKey('active')) {
      active = checkValue(data['active']);
    } else {
      print(
        'Warning: is_active field missing for fertilizer $id. Defaulting to TRUE.',
      );
      active = true;
    }

    // Helper to safe parse int
    String getVal(Map<String, dynamic> d, List<String> keys) {
      for (var k in keys) {
        if (d.containsKey(k)) return d[k].toString();
      }
      return '0';
    }

    String n = getVal(data, ['n_value', 'N', 'n', 'nitrogen']);
    String p = getVal(data, ['p_value', 'P', 'p', 'phosphorus']);
    String k = getVal(data, ['k_value', 'K', 'k', 'potassium']);

    return Fertilizer(
      id: id,
      name: data['name']?.toString() ?? '',
      npkComposition: '$n:$p:$k',
      category: data['category']?.toString() ?? '',
      imageUrl: data['image_url']?.toString() ?? '',
      isActive: active,
      description: data['description']?.toString() ?? '',
      suitableCrops: data['suitable_crops']?.toString() ?? 'All Crops',
      recommendedDosage:
          data['recommended_dosage']?.toString() ?? 'As per soil test',
      manufacturer:
          data['manufacturer']?.toString() ?? data['brand']?.toString() ?? '',
    );
  }
}

class Store {
  final String id;
  final String storeName;
  final double latitude;
  final double longitude;
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final List<String> stock;
  final Map<String, double> priceList;

  Store({
    required this.id,
    required this.storeName,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.totalReviews,
    required this.isVerified,
    required this.stock,
    required this.priceList,
  });

  factory Store.fromMap(Map<String, dynamic> data, String id) {
    // Parse Location (GeoPoint) - Try multiple field names
    double lat = 0.0;
    double lng = 0.0;

    // Try 'location' field first
    if (data['location'] != null) {
      try {
        final loc = data['location'];
        if (loc is Map) {
          lat = (loc['latitude'] as num?)?.toDouble() ?? 0.0;
          lng = (loc['longitude'] as num?)?.toDouble() ?? 0.0;
        } else {
          // If it's a GeoPoint object
          lat = (loc.latitude as num?)?.toDouble() ?? 0.0;
          lng = (loc.longitude as num?)?.toDouble() ?? 0.0;
        }
      } catch (e) {
        print('Error parsing location field: $e');
      }
    }

    // Try direct latitude/longitude fields if location is not available
    if (lat == 0.0 && lng == 0.0) {
      lat = (data['latitude'] as num?)?.toDouble() ?? 0.0;
      lng = (data['longitude'] as num?)?.toDouble() ?? 0.0;
    }

    // Try coordinates field
    if (lat == 0.0 && lng == 0.0 && data['coordinates'] != null) {
      try {
        final coords = data['coordinates'];
        if (coords is Map) {
          lat = (coords['latitude'] as num?)?.toDouble() ?? 0.0;
          lng = (coords['longitude'] as num?)?.toDouble() ?? 0.0;
        }
      } catch (e) {
        print('Error parsing coordinates field: $e');
      }
    }

    // Parse Price List
    Map<String, double> prices = {};
    if (data['price_list'] is Map) {
      (data['price_list'] as Map).forEach((key, value) {
        prices[key.toString()] = (value as num).toDouble();
      });
    }

    // Get store name - use storeName (primary), fallback to others
    String storeName =
        data['storeName']?.toString() ??
        data['shop_name']?.toString() ??
        data['store_name']?.toString() ??
        data['name']?.toString() ??
        '';

    // Get verification status - isVerified is the standard field
    bool isVerified =
        data['isVerified'] == true ||
        data['is_verified'] == true ||
        data['verified'] == true;

    print(
      'DEBUG: Store $id - Name: $storeName, Location: ($lat, $lng), Verified: $isVerified',
    );

    return Store(
      id: id,
      storeName: storeName,
      latitude: lat,
      longitude: lng,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews:
          (data['totalReviews'] as num?)?.toInt() ??
          (data['total_reviews'] as num?)?.toInt() ??
          0,
      isVerified: isVerified,
      stock: (data['stock'] as List?)?.map((e) => e.toString()).toList() ?? [],
      priceList: prices,
    );
  }
}

class StoreSearchResult {
  final Store store;
  final double distance;
  final double score;
  final double? price; // null means price not available
  final bool inStock;

  StoreSearchResult({
    required this.store,
    required this.distance,
    required this.score,
    this.price, // nullable
    required this.inStock,
  });
}
