import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:travel_app/utils/color_utils.dart';



class AnimatedRouteMap extends StatefulWidget {
  final List<String> locations;
  final List<String> transportModes;

  const AnimatedRouteMap({
    super.key,
    required this.locations,
    required this.transportModes,
  });

  @override
  State<AnimatedRouteMap> createState() => _AnimatedRouteMapState();
}

class _AnimatedRouteMapState extends State<AnimatedRouteMap> {
  late GoogleMapController _controller;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> routePoints = [];
  BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor trainIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor planeIcon = BitmapDescriptor.defaultMarker;

  Timer? _animationTimer;
  int _currentPointIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _initializeMarkersAndRoute();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _loadCustomIcons() async {
    try {
      carIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/car_icon.png',
      );
      trainIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/train_icon.png',
      );
      planeIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/plane_icon.png',
      );
      setState(() {});
    } catch (e) {
      print('Error loading icons: $e');
    }
  }

  Future<void> _initializeMarkersAndRoute() async {
    for (int i = 0; i < widget.locations.length; i++) {
      final location = widget.locations[i];
      final transportMode = widget.transportModes[i];

      try {
        final List<Location> locations = await locationFromAddress(location);
        final LatLng point = LatLng(locations[0].latitude, locations[0].longitude);

        setState(() {
          markers.add(Marker(
            markerId: MarkerId(location),
            position: point,
            infoWindow: InfoWindow(title: location, snippet: transportMode),
            icon: _getIconForMode(transportMode),
            onTap: () {
              _controller.animateCamera(
                CameraUpdate.newLatLngZoom(point, 6),
              );
            },
          ));
          routePoints.add(point);
        });
      } catch (e) {
        print('Error finding location for $location: $e');
      }
    }

    _animateRoute();

    setState(() {
      _isLoading = false;
    });
  }

  BitmapDescriptor _getIconForMode(String mode) {
    switch (mode) {
      case 'Train':
        return trainIcon;
      case 'Plane':
        return planeIcon;
      default:
        return carIcon;
    }
  }

  void _animateRoute() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_currentPointIndex < routePoints.length - 1) {
        setState(() {
          String transportMode = widget.transportModes[_currentPointIndex];

          final polylineSegment = Polyline(
            polylineId: PolylineId('segment_$_currentPointIndex'),
            points: [
              routePoints[_currentPointIndex],
              routePoints[_currentPointIndex + 1],
            ],
            color: segmentColors[_currentPointIndex % segmentColors.length],
            width: 4,
            patterns: _getPolylinePatternForMode(transportMode),
          );

          polylines.add(polylineSegment);
        });

        _controller.animateCamera(
          CameraUpdate.newLatLng(routePoints[_currentPointIndex]),
        );

        _currentPointIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  List<PatternItem> _getPolylinePatternForMode(String mode) {
    switch (mode) {
      case 'Plane':
        return [PatternItem.dash(20), PatternItem.gap(20)];
      case 'Train':
        return [PatternItem.dash(10), PatternItem.gap(10)];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Travel Route Map')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(20.5937, 78.9629),
                zoom: 5,
              ),
              markers: markers,
              polylines: polylines,
              onMapCreated: (controller) {
                _controller = controller;
              },
            ),
    );
  }
}