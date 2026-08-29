import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../profile/profile_controller.dart';
import 'fertilizer_search_controller.dart';
import 'fertilizer_search_model.dart';
import '../../../core/utils/app_theme.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../../l10n/app_localizations.dart';

class FertilizerSearchScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const FertilizerSearchScreen({super.key, this.onNavigateToTab});

  @override
  State<FertilizerSearchScreen> createState() => _FertilizerSearchScreenState();
}

class _FertilizerSearchScreenState extends State<FertilizerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AuthService _authService = AuthService();
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  PolylineAnnotationManager? _polylineAnnotationManager;
  CircleAnnotationManager? _circleAnnotationManager;

  late final FertilizerSearchController _controller;

  // For overlay
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Track last shown error to prevent duplicate SnackBars
  String? _lastShownError;

  // Track if user is interacting with map
  bool _isInteractingWithMap = false;

  // Track if initial camera position has been set
  bool _initialCameraSet = false;

  @override
  void initState() {
    super.initState();
    _controller = FertilizerSearchController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initialize();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _controller.filterSuggestions(_searchController.text);
      if (_controller.suggestions.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      _removeOverlay();
    }
  }

  /// Calculate estimated time to reach based on distance
  /// Assumes average speed of 30 km/h in urban areas
  String _getEstimatedTime(double distanceInKm) {
    const double averageSpeedKmh = 30.0; // Urban driving speed
    double timeInHours = distanceInKm / averageSpeedKmh;
    int timeInMinutes = (timeInHours * 60).round();

    if (timeInMinutes < 1) {
      return 'Less than 1 min';
    } else if (timeInMinutes < 60) {
      return '$timeInMinutes min';
    } else {
      int hours = timeInMinutes ~/ 60;
      int minutes = timeInMinutes % 60;
      if (minutes == 0) {
        return '$hours hr';
      } else {
        return '$hours hr $minutes min';
      }
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32, // Match padding
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 50.0), // Height of text field + padding
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ChangeNotifierProvider.value(
              value: _controller,
              child: Consumer<FertilizerSearchController>(
                builder: (context, controller, child) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: controller.suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = controller.suggestions[index];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(suggestion.name),
                            if (suggestion.manufacturer.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  suggestion.manufacturer,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          _searchController.text = suggestion.name;
                          _removeOverlay();
                          FocusScope.of(context).unfocus();
                          context
                              .read<ProfileController>()
                              .incrementSearchCount();
                          controller.searchFertilizer(suggestion.name);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showRatingDialog(BuildContext context, StoreSearchResult result) {
    double _rating = 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Rate ${result.store.storeName}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How was your experience with this store?'),
                  const SizedBox(height: 16),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _rating > 0
                      ? () async {
                          Navigator.pop(context);

                          if (_authService.currentUserId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please sign in to rate stores.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final resultData = await _controller.rateStore(
                            result.store,
                            _rating,
                          );
                          final success = resultData['success'] == true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Rating submitted successfully!'
                                    : (resultData['message']?.toString() ??
                                          'Failed to submit rating'),
                              ),
                              backgroundColor: success
                                  ? AppColors.success
                                  : Colors.red,
                            ),
                          );
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _fitRouteBounds() {
    if (_mapboxMap == null) return;

    final bounds = _controller.getRouteBounds();
    if (bounds == null) return;

    // Calculate the distance span
    final latSpan = (bounds['maxLat']! - bounds['minLat']!).abs();
    final lngSpan = (bounds['maxLng']! - bounds['minLng']!).abs();
    final maxSpan = latSpan > lngSpan ? latSpan : lngSpan;

    // Calculate appropriate zoom level based on span
    // For reference: zoom 13 = ~5km, zoom 14 = ~2.5km, zoom 15 = ~1.2km
    double zoom = 13.0;
    if (maxSpan < 0.01) {
      zoom = 15.0; // Very close (< 1km)
    } else if (maxSpan < 0.03) {
      zoom = 14.0; // Close (1-3km)
    } else if (maxSpan < 0.06) {
      zoom = 13.0; // Medium (3-6km)
    } else {
      zoom = 12.0; // Far (> 6km)
    }

    // Fly camera to center of route with appropriate zoom
    _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(bounds['centerLng']!, bounds['centerLat']!),
        ),
        zoom: zoom,
        padding: MbxEdgeInsets(
          top: 80,
          left: 40,
          bottom: 250, // Extra padding for store list at bottom
          right: 40,
        ),
      ),
      MapAnimationOptions(duration: 1500, startDelay: 0),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    // Disable default gestures if needed, or adjust settings
    // mapboxMap.gestures.updateSettings(GesturesSettings(scrollEnabled: true));

    // Create managers sequentially to ensure correct z-ordering (Polyline < Circle < Point)

    mapboxMap.annotations
        .createPolylineAnnotationManager()
        .then((polylineManager) {
          _polylineAnnotationManager = polylineManager;
          return mapboxMap.annotations.createCircleAnnotationManager();
        })
        .then((circleManager) {
          _circleAnnotationManager = circleManager;
          return mapboxMap.annotations.createPointAnnotationManager();
        })
        .then((pointManager) {
          _pointAnnotationManager = pointManager;
          _updateMapMarkers(); // Update markers once manager is ready
        });

    _addMarkerImage();
  }

  bool _markerImageReady = false;

  Future<void> _addMarkerImage() async {
    try {
      if (_mapboxMap == null) return;

      // Regular Store Marker (Green)
      final regularMarker = await _buildMarkerImage(const Color(0xFF43A047));
      await _mapboxMap?.style.addStyleImage(
        "regular_store_marker",
        2.0,
        MbxImage(width: 100, height: 120, data: regularMarker),
        false,
        [],
        [],
        null,
      );

      // Best Store Marker (Gold)
      final bestMarker = await _buildMarkerImage(const Color(0xFFFFAB00));
      await _mapboxMap?.style.addStyleImage(
        "best_store_marker",
        2.0,
        MbxImage(width: 100, height: 120, data: bestMarker),
        false,
        [],
        [],
        null,
      );

      // User Location Marker (Blue)
      final userMarker = await _buildUserLocationMarkerImage(
        const Color(0xFF2196F3),
      );
      await _mapboxMap?.style.addStyleImage(
        "user_location_marker",
        2.0,
        MbxImage(width: 100, height: 120, data: userMarker),
        false,
        [],
        [],
        null,
      );

      _markerImageReady = true;
      _updateMapMarkers(); // Update markers once images are ready
    } catch (e) {
      debugPrint("Error adding marker images: $e");
    }
  }

  Future<Uint8List> _buildMarkerImage(Color color) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = ui.Size(100, 120);

    // 1. Draw Pin Body
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, size.height); // Bottom tip (50, 120)

    // Right curve to shoulder
    path.cubicTo(
      size.width / 2,
      size.height * 0.7, // Control point 1
      size.width * 0.95,
      size.height * 0.6, // Control point 2
      size.width * 0.95,
      45, // End point (Right shoulder at 95, 45)
    );

    // Top Arc
    path.arcToPoint(
      Offset(size.width * 0.05, 45), // Left shoulder at (5, 45)
      radius: const Radius.circular(
        45,
      ), // Radius 45 fits within 100 width with 5px padding
      clockwise: false,
    );

    // Left curve back to tip
    path.cubicTo(
      size.width * 0.05,
      size.height * 0.6, // Control point 1
      size.width / 2,
      size.height * 0.7, // Control point 2
      size.width / 2,
      size.height, // End point (Tip)
    );

    path.close();
    canvas.drawPath(path, paint);

    // 2. Draw White Inner Circle
    final circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      const Offset(50, 45), // Center matches the top arc center
      30, // Radius
      circlePaint,
    );

    // 3. Draw Store Icon
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.store.codePoint),
      style: TextStyle(
        fontSize: 36,
        fontFamily: Icons.store.fontFamily,
        color: color, // Icon color matches pin color
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        45 - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> _buildUserLocationMarkerImage(Color color) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = ui.Size(100, 120);

    // 1. Draw Pin Body
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, size.height); // Bottom tip

    // Right curve
    path.cubicTo(
      size.width / 2,
      size.height * 0.7,
      size.width * 0.95,
      size.height * 0.6,
      size.width * 0.95,
      45,
    );

    // Top Arc
    path.arcToPoint(
      Offset(size.width * 0.05, 45),
      radius: const Radius.circular(45),
      clockwise: false,
    );

    // Left curve
    path.cubicTo(
      size.width * 0.05,
      size.height * 0.6,
      size.width / 2,
      size.height * 0.7,
      size.width / 2,
      size.height,
    );

    path.close();
    canvas.drawPath(path, paint);

    // 2. Draw White Inner Circle
    final circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(50, 45), 30, circlePaint);

    // 3. Draw User Icon (Person)
    final iconIcon = Icons.person; // User icon
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconIcon.codePoint),
      style: TextStyle(
        fontSize: 40, // Slightly larger than store icon
        fontFamily: iconIcon.fontFamily,
        color: color, // Match pin color (Blue)
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        45 - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _updateMapMarkers() async {
    if (_circleAnnotationManager == null) return;

    await _circleAnnotationManager?.deleteAll();

    if (_controller.currentPosition != null) {
      // Logic moved to _pointAnnotationManager block below
      // Removed CircleAnnotations for user location
    }

    // Stores & User Location
    if (_pointAnnotationManager != null && _markerImageReady) {
      await _pointAnnotationManager?.deleteAll();

      // User Location
      if (_controller.currentPosition != null) {
        // Only fly to user location on initial setup, not on every update
        if (!_initialCameraSet) {
          _mapboxMap?.flyTo(
            CameraOptions(
              center: Point(
                coordinates: Position(
                  _controller.currentPosition!.longitude,
                  _controller.currentPosition!.latitude,
                ),
              ),
              zoom: 13.0, // Zoom level to show ~5km radius area
              padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            ),
            MapAnimationOptions(duration: 1000, startDelay: 0),
          );
          _initialCameraSet = true;
        }

        await _pointAnnotationManager?.create(
          PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(
                _controller.currentPosition!.longitude,
                _controller.currentPosition!.latitude,
              ),
            ),
            iconImage: "user_location_marker",
            iconSize: 0.8,
            iconAnchor: IconAnchor.BOTTOM,
            iconOffset: [0.0, -15.0],
          ),
        );
      }

      // Stores
      for (var result in _controller.stores) {
        final isBest = _controller.bestShop?.store.id == result.store.id;

        await _pointAnnotationManager?.create(
          PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(
                result.store.longitude,
                result.store.latitude,
              ),
            ),
            iconImage: isBest ? "best_store_marker" : "regular_store_marker",
            iconSize: isBest ? 0.7 : 0.6, // Best store is larger
            iconAnchor: IconAnchor.BOTTOM,
            iconOffset: [0.0, -15.0], // Slightly raise so tip is on point
          ),
        );
      }
    }
  }

  Future<void> _updateRoute() async {
    if (_polylineAnnotationManager == null) return;

    await _polylineAnnotationManager?.deleteAll();

    if (_controller.routePolyline.isNotEmpty) {
      final List<Point> points = _controller.routePolyline.map((
        ll.LatLng latLng,
      ) {
        return Point(coordinates: Position(latLng.longitude, latLng.latitude));
      }).toList();

      await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(
            coordinates: points.map((e) => e.coordinates).toList(),
          ),
          lineColor: Colors.blue.value,
          lineWidth: 4.0,
          lineJoin: LineJoin.ROUND,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.white, // Match clean white background
        body: SafeArea(
          child: Consumer<FertilizerSearchController>(
            builder: (context, controller, child) {
              if (_mapboxMap != null) {
                _updateMapMarkers();
                _updateRoute();
              }

              // Show error only if it's new and different from last shown
              if (controller.error != null &&
                  controller.error!.isNotEmpty &&
                  controller.error != _lastShownError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _lastShownError = controller.error;
                  String errorMessage = controller.error!;
                  String actionMessage = '';

                  // Check if it's a permission error
                  if (errorMessage.contains('permission-denied') ||
                      errorMessage.contains('permission denied')) {
                    errorMessage = 'Database permission error detected';
                    actionMessage =
                        'Please ensure Firestore rules are deployed. Contact support if issue persists.';
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            errorMessage,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (actionMessage.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              actionMessage,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () {
                          _lastShownError = null; // Reset to allow new error
                          controller.initialize();
                        },
                      ),
                    ),
                  );
                });
              }

              // Clear last shown error when error is null
              if (controller.error == null || controller.error!.isEmpty) {
                _lastShownError = null;
              }

              return Column(
                children: [
                  // App Bar / Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.onNavigateToTab != null) {
                              widget.onNavigateToTab!(0); // go to Home tab
                            } else if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context).search,
                                  style: AppTextStyles.heading3.copyWith(
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).findNearbyStoreSubtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Field
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Urea',
                          hintStyle: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Rounded pill shape
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (value) {
                          _removeOverlay();
                          print('DEBUG: Search submitted via keyboard: $value');
                          context
                              .read<ProfileController>()
                              .incrementSearchCount();
                          controller.searchFertilizer(value);
                        },
                      ),
                    ),
                  ),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: _isInteractingWithMap
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Fertilizer Info Card
                          if (controller.selectedFertilizer != null)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFE8F5E9,
                                          ), // Light Green
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child:
                                            controller
                                                .selectedFertilizer!
                                                .imageUrl
                                                .isNotEmpty
                                            ? Image.network(
                                                controller
                                                    .selectedFertilizer!
                                                    .imageUrl,
                                                width: 24,
                                                height: 24,
                                                errorBuilder: (c, e, s) =>
                                                    const Icon(
                                                      Icons.science_outlined,
                                                      color: AppColors.primary,
                                                    ),
                                              )
                                            : const Icon(
                                                Icons.science_outlined,
                                                color: AppColors.primary,
                                              ), // Flask icon
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller
                                                  .selectedFertilizer!
                                                  .name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (controller
                                                .selectedFertilizer!
                                                .manufacturer
                                                .isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Text(
                                                  controller
                                                      .selectedFertilizer!
                                                      .manufacturer,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              controller
                                                  .selectedFertilizer!
                                                  .category
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          'NPK: ${controller.selectedFertilizer!.npkComposition}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // No suitableCrops in simplified Fertilizer model as per requirements?
                                              // Assuming I should remove or use placeholder/description if available.
                                              // Requirements said "Fertilizer Master: name, category, NPK, description, image, isActive".
                                              // So I'll show description instead.
                                              const Text(
                                                'Description',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                controller
                                                        .selectedFertilizer!
                                                        .description
                                                        .isNotEmpty
                                                    ? controller
                                                          .selectedFertilizer!
                                                          .description
                                                    : 'No description available',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          // Map - Fixed height for scrollable layout
                          Listener(
                            onPointerDown: (_) {
                              setState(() {
                                _isInteractingWithMap = true;
                              });
                            },
                            onPointerUp: (_) {
                              setState(() {
                                _isInteractingWithMap = false;
                              });
                            },
                            onPointerCancel: (_) {
                              setState(() {
                                _isInteractingWithMap = false;
                              });
                            },
                            child: Container(
                              height: controller.stores.isNotEmpty ? 400 : 500,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  MapWidget(
                                    mapOptions: MapOptions(
                                      pixelRatio: MediaQuery.of(
                                        context,
                                      ).devicePixelRatio,
                                    ),
                                    styleUri: MapboxStyles.OUTDOORS,
                                    onMapCreated: _onMapCreated,
                                    cameraOptions: CameraOptions(
                                      center: Point(
                                        coordinates: Position(
                                          controller
                                                  .currentPosition
                                                  ?.longitude ??
                                              77.5946, // Delhi longitude as fallback
                                          controller
                                                  .currentPosition
                                                  ?.latitude ??
                                              12.9716, // Bangalore latitude as fallback
                                        ),
                                      ),
                                      zoom:
                                          13.0, // Zoom level to show ~5km radius
                                    ),
                                  ),
                                  // "Within 5KM" Lozenge
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.success,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'WITHIN 5KM',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (controller.isLoading)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Stores List Section
                          if (controller.stores.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      'Nearby Stores (${controller.stores.length})',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.stores.length,
                                    itemBuilder: (context, index) {
                                      final result = controller.stores[index];
                                      final isBest =
                                          controller.bestShop?.store.id ==
                                          result.store.id;

                                      return GestureDetector(
                                        onTap: () =>
                                            _showRatingDialog(context, result),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: isBest
                                                  ? const Color(
                                                      0xFFFFAB00,
                                                    ) // Gold for best
                                                  : const Color(
                                                      0xFF43A047,
                                                    ), // Green for regular stores
                                              width:
                                                  2.0, // Same width as best store
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            result
                                                                .store
                                                                .storeName,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        if (result
                                                            .store
                                                            .isVerified) ...[
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          const Icon(
                                                            Icons.verified,
                                                            color: Colors.blue,
                                                            size: 14,
                                                          ),
                                                        ],
                                                        if (isBest) ...[
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 2,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  const Color(
                                                                    0xFFFFAB00,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                            child: const Text(
                                                              'BEST SHOP',
                                                              style: TextStyle(
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),

                                                    const SizedBox(height: 4),
                                                    Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      spacing: 2,
                                                      runSpacing: 4,
                                                      children: [
                                                        const Icon(
                                                          Icons.star,
                                                          size: 12,
                                                          color: Colors.amber,
                                                        ),
                                                        Text(
                                                          '${result.store.rating} (${result.store.totalReviews})',
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        const Icon(
                                                          Icons.location_on,
                                                          size: 12,
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                        Text(
                                                          '${result.distance.toStringAsFixed(1)} km',
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.access_time,
                                                          size: 12,
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                        const SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          _getEstimatedTime(
                                                            result.distance,
                                                          ),
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: result.inStock
                                                            ? AppColors.success
                                                                  .withOpacity(
                                                                    0.1,
                                                                  )
                                                            : Colors.red
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 6,
                                                            height: 6,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  result.inStock
                                                                  ? AppColors
                                                                        .success
                                                                  : Colors.red,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            result.inStock
                                                                ? 'IN STOCK'
                                                                : 'OUT STOCK',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  result.inStock
                                                                  ? AppColors
                                                                        .success
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    result.price != null
                                                        ? '₹${result.price!.toStringAsFixed(2)}'
                                                        : 'Price N/A',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          result.price != null
                                                          ? AppColors
                                                                .textPrimary
                                                          : AppColors
                                                                .textSecondary,
                                                    ),
                                                  ),
                                                  if (result.price != null)
                                                    const Text(
                                                      'per unit',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                  const SizedBox(height: 8),
                                                  InkWell(
                                                    onTap: () async {
                                                      // Increment store visit count
                                                      context
                                                          .read<
                                                            ProfileController
                                                          >()
                                                          .incrementStoreVisitCount();

                                                      // Load navigation route
                                                      await controller
                                                          .navigateToStore(
                                                            result.store,
                                                          );

                                                      // Wait a bit for route to be drawn, then fit camera
                                                      if (controller
                                                          .routePolyline
                                                          .isNotEmpty) {
                                                        // Small delay to ensure route is rendered
                                                        await Future.delayed(
                                                          const Duration(
                                                            milliseconds: 300,
                                                          ),
                                                        );
                                                        _fitRouteBounds();

                                                        // Show success message
                                                        if (mounted) {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                'Route calculated successfully',
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                    seconds: 2,
                                                                  ),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .success,
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .background,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .navigation_outlined,
                                                            size: 12,
                                                            color: AppColors
                                                                .textPrimary,
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            'Navigate',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
