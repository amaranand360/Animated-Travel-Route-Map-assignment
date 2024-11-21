import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

final List<Color> segmentColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.yellow,
];

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

          // Create polyline for each segment with different styles
          final polylineSegment = Polyline(
            polylineId: PolylineId('segment_$_currentPointIndex'),
            points: [
              routePoints[_currentPointIndex],
              routePoints[_currentPointIndex + 1],
            ],
            color: segmentColors[_currentPointIndex % segmentColors.length],
            width: 4,
          );

          // Add the polyline to the set
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
        // Curved line for planes
        return _getCurvedPolylinePattern();
      case 'Train':
        // Dashed pattern for trains
        return [PatternItem.dash(10), PatternItem.gap(10)];
      default:
        // Solid line for cars
        return [];
    }
  }

  List<PatternItem> _getCurvedPolylinePattern() {
    // This method generates a "curved" line by adding multiple intermediate points between the two main points
    return [
      PatternItem.dash(20),
      PatternItem.gap(20),
    ];
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




// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';

// final List<Color> segmentColors = [
//   Colors.red,
//   Colors.blue,
//   Colors.purple,
//   Colors.deepOrangeAccent,
//   Colors.grey,
//   Colors.yellow,
// ];

// class AnimatedRouteMap extends StatefulWidget {
//   final List<String> locations;
//   final List<String> transportModes;

//   const AnimatedRouteMap({
//     super.key,
//     required this.locations,
//     required this.transportModes,
//   });

//   @override
//   State<AnimatedRouteMap> createState() => _AnimatedRouteMapState();
// }

// class _AnimatedRouteMapState extends State<AnimatedRouteMap> {
//   late GoogleMapController _controller;
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   List<LatLng> routePoints = [];
//   BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor trainIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor planeIcon = BitmapDescriptor.defaultMarker;

//   Timer? _animationTimer;
//   int _currentPointIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomIcons();
//     _initializeMarkersAndRoute();
//   }

//   @override
//   void dispose() {
//     _animationTimer?.cancel();
//     super.dispose();
//   }

//   /// Load custom icons for markers
//   void _loadCustomIcons() async {
//     print('Attempting to load custom icons...');
//     try {
//       carIcon = await BitmapDescriptor.asset(
//         const ImageConfiguration(devicePixelRatio: 2.5),
//         'assets/images/car_icon.png',
//       );
//       trainIcon = await BitmapDescriptor.asset(
//         const ImageConfiguration(devicePixelRatio: 2.5),
//         'assets/images/train_icon.png',
//       );
//       planeIcon = await BitmapDescriptor.asset(
//         const ImageConfiguration(devicePixelRatio: 2.5),
//         'assets/images/plane_icon.png',
//       );

//       setState(() {});
//     } catch (e) {
//       print('Error loading icons: $e');
//     }
//   }

//   /// Initialize markers and route points from the given locations
//   Future<void> _initializeMarkersAndRoute() async {
//     print('Initializing markers and route...');
//     for (int i = 0; i < widget.locations.length; i++) {
//       final location = widget.locations[i];
//       final transportMode = widget.transportModes[i];

//       try {
//         final List<Location> locations = await locationFromAddress(location);
//         final LatLng point = LatLng(locations[0].latitude, locations[0].longitude);

//         setState(() {
//           // Add marker with transport mode icon
//           markers.add(
//             Marker(
//               markerId: MarkerId(location),
//               position: point,
//               infoWindow: InfoWindow(title: location, snippet: transportMode),
//               icon: _getIconForMode(transportMode),
//               onTap: () {
//                 _controller.animateCamera(
//                   CameraUpdate.newLatLngZoom(point, 6),
//                 );
//               },
//             ),
            
//           );
//           routePoints.add(point);
//         });
//       } catch (e) {
//         print('Error finding location for $location: $e');
//       }
//     }

//     // Start animating the route
//     _animateRoute();
//   }

//   /// Get the icon for the transport mode
//   BitmapDescriptor _getIconForMode(String mode) {
//     switch (mode) {
//       case 'Train':
//         return trainIcon;
//       case 'Plane':
//         return planeIcon;
//       default:
//         return carIcon;
//     }
//   }

//   /// Animate the route by progressively adding segments as polylines
//   void _animateRoute() {
//     print('Starting route animation...');
//     _animationTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
//       if (_currentPointIndex < routePoints.length - 1) {
//         setState(() {
//           // Create a polyline segment for the current route
//           final polylineSegment = Polyline(
//             polylineId: PolylineId('segment_${_currentPointIndex}'),
//             points: [
//               routePoints[_currentPointIndex],
//               routePoints[_currentPointIndex + 1],
//             ],
//             color: segmentColors[_currentPointIndex % segmentColors.length],
//             width: 4,
//           );

//           // Add the polyline segment to the polylines set
//           polylines.add(polylineSegment);
//         });

//         // Move the camera to the current point
//         _controller.animateCamera(
//           CameraUpdate.newLatLng(routePoints[_currentPointIndex]),
//         );

//         print(
//             'Added segment ${_currentPointIndex}: ${routePoints[_currentPointIndex]} -> ${routePoints[_currentPointIndex + 1]}');

//         _currentPointIndex++;
//       } else {
//         // Stop the timer when the animation is complete
//         print('Route animation completed.');
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Animated Travel Route Map')),
//       body: GoogleMap(
//         initialCameraPosition: const CameraPosition(
//           target: LatLng(28.7041, 77.1025), // India center
//           zoom: 5,
//         ),
//         markers: markers,
//         polylines: polylines, // Use the dynamic polyline set
//         onMapCreated: (controller) {
//           _controller = controller;
//         },
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:travel_app/components/current_location.dart';
// import 'package:travel_app/components/google_map_polyline.dart';

// class GoogleMapScreen extends StatefulWidget {
//   final List<String> locations;
//   final List<String> transportModes;

//   const GoogleMapScreen({
//     super.key,
//     required this.locations,
//     required this.transportModes,
//   });

//   @override
//   State<GoogleMapScreen> createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   late GoogleMapController _controller;
//   Set<Marker> _markers = {};
//   List<LatLng> _routePoints = [];
//   List<LatLng> _animatedPoints = [];
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _initializeMap();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   Future<void> _initializeMap() async {
//     try {
//       final List<LatLng> locations = [];
//       for (String location in widget.locations) {
//         LatLng coordinates =
//             await GetMyLocation.getCoordinatesFromAddress(location);
//         locations.add(coordinates);

//         setState(() {
//           _markers.add(
//             Marker(
//               markerId: MarkerId(location),
//               position: coordinates,
//               infoWindow: InfoWindow(title: location),
//             ),
//           );
//         });
//       }

//       if (locations.isNotEmpty) {
//         _routePoints = await MapPolylineForRoute.getRoutePoints(
//             locations, 'AIzaSyDM5Yq_9zHc71-Dm2z8Sr90n5WxJ1PDzgM');
//         _startAnimation();
//       }
//     } catch (e) {
//       print('Error initializing map: $e');
//     }
//   }

//   void _startAnimation() {
//     int index = 0;

//     _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
//       if (index < _routePoints.length) {
//         setState(() {
//           _animatedPoints.add(_routePoints[index]);
//         });

//         _controller.animateCamera(
//           CameraUpdate.newLatLng(_routePoints[index]),
//         );

//         index++;
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   // Permission Dialog and Current Location Logic
//   Future<void> _requestPermissionAndGetLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled.');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied.');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw Exception(
//           'Location permissions are permanently denied. Please enable them in settings.',
//         );
//       }

//       // Fetch the current location
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       // Center the map on the current location
//       LatLng currentLocation = LatLng(position.latitude, position.longitude);
//       _controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: currentLocation, zoom: 16),
//         ),
//       );

//       // Add a marker for the current location
//       setState(() {
//         _markers.add(
//           Marker(
//             markerId: const MarkerId('current_location'),
//             position: currentLocation,
//             infoWindow: const InfoWindow(title: 'My Location'),
//           ),
//         );
//       });
//     } catch (e) {
//       // Show error if location permissions or services are unavailable
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Permission Required'),
//           content: Text(e.toString()),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Travel Itinerary')),
//       body: GoogleMap(
//         initialCameraPosition: const CameraPosition(
//           target: LatLng(20.5937, 78.9629),
//           zoom: 8,
//         ),
//         onMapCreated: (controller) => _controller = controller,
//         markers: _markers,
//         polylines: {
//           Polyline(
//             polylineId: const PolylineId('animatedRoute'),
//             points: _animatedPoints,
//             color: Colors.blue,
//             width: 4,
//           ),
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         onPressed: _requestPermissionAndGetLocation,
//         child: const Icon(
//           Icons.my_location,
//           size: 30,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }





// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// class GoogleMapScreen extends StatefulWidget {
//   final List<String> locations;
//   final List<String> transportModes;

//   const GoogleMapScreen({
//     super.key,
//     required this.locations,
//     required this.transportModes,
//   });

//   @override
//   State<GoogleMapScreen> createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   late GoogleMapController _controller;
//   Set<Marker> _markers = {};
//   List<LatLng> _routePoints = [];
//   List<LatLng> _animatedPoints = [];
//   Timer? _timer;

//   // Icons for transport modes
//   BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor trainIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor planeIcon = BitmapDescriptor.defaultMarker;

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomIcons();
//     _initializeMap();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _loadCustomIcons() async {
//     carIcon = await BitmapDescriptor.asset(
//       const ImageConfiguration(),
//       'assets/images/marker1.jpg',
//     );
//     trainIcon = await BitmapDescriptor.asset(
//       const ImageConfiguration(),
//       'assets/images/marker21.png',
//     );
//     planeIcon = await BitmapDescriptor.asset(
//       const ImageConfiguration(),
//       'assets/images/marker1.jpg',
//     );
//   }

//   Future<void> _initializeMap() async {
//     final List<LatLng> locations = [];

//     for (String location in widget.locations) {
//       try {
//         final LatLng coordinates = await _getCoordinates(location);
//         locations.add(coordinates);

//         setState(() {
//           _markers.add(
//             Marker(
//               markerId: MarkerId(location),
//               position: coordinates,
//               infoWindow: InfoWindow(title: location),
//               icon: _getIconForMode(widget.transportModes[locations.length - 1]),
//             ),
//           );
//         });
//       } catch (e) {
//         print('Error decoding location: $e');
//       }
//     }

//     if (locations.isNotEmpty) {
//       _routePoints = await _getPolylinePoints(locations);
//       _startAnimation();
//     }
//   }

//   Future<LatLng> _getCoordinates(String address) async {
//     try {
//       final List<Location> locations = await locationFromAddress(address);
//       return LatLng(locations[0].latitude, locations[0].longitude);
//     } catch (e) {
//       print('Error fetching coordinates for $address: $e');
//       throw Exception('Location not found');
//     }
//   }

//   BitmapDescriptor _getIconForMode(String mode) {
//     switch (mode) {
//       case 'Train':
//         return trainIcon;
//       case 'Plane':
//         return planeIcon;
//       default:
//         return carIcon;
//     }
//   }

//   Future<List<LatLng>> _getPolylinePoints(List<LatLng> locations) async {
//     List<LatLng> polylinePoints = [];

//       for (int i = 0; i < locations.length - 1; i++) {
//     PolylinePoints polylinePointsGenerator = PolylinePoints();
//     PolylineResult result = await polylinePointsGenerator.getRouteBetweenCoordinates(
//       googleApiKey: 'AIzaSyDM5Yq_9zHc71-Dm2z8Sr90n5WxJ1PDzgM',
//       request: PolylineRequest(
//         origin: PointLatLng(locations[i].latitude, locations[i].longitude),
//         destination: PointLatLng(locations[i + 1].latitude, locations[i + 1].longitude),
//         mode: TravelMode.driving, // Change mode as per your requirement
//       ),
//     );


//       if (result.points.isNotEmpty) {
//         polylinePoints.addAll(result.points.map((point) => LatLng(point.latitude, point.longitude)));
//       }
//     }
//     return polylinePoints;
//   }

//   void _startAnimation() {
//     int index = 0;

//     _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
//       if (index < _routePoints.length) {
//         setState(() {
//           _animatedPoints.add(_routePoints[index]);
//         });

//         _controller.animateCamera(
//           CameraUpdate.newLatLng(_routePoints[index]),
//         );

//         index++;
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Route Animation')),
//       body: GoogleMap(
//         initialCameraPosition: const CameraPosition(
//           target: LatLng(20.5937, 78.9629),
//           zoom: 5,
//         ),
//         onMapCreated: (controller) {
//           _controller = controller;
//         },
//         markers: _markers,
//         polylines: {
//           Polyline(
//             polylineId: const PolylineId('animatedRoute'),
//             points: _animatedPoints,
//             color: Colors.redAccent,
//             width: 4,
//           ),
//         },
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geocoding/geocoding.dart';

// class GoogleMapScreen extends StatefulWidget {
//   @override
//   _GoogleMapScreenState createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   LatLng myCurrentLocation = const LatLng(27.7172, 85.3240);
//   BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

//   @override
//   void initState() {
//     super.initState();
//     customMarker();
//   }

//   void customMarker() {
//     BitmapDescriptor.asset(
//       const ImageConfiguration(),
//       "assets/images/marker1.jpg",
//     ).then((icon) {
//       setState(() {
//         customIcon = icon;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: myCurrentLocation,
//           zoom: 5,
//         ), // CameraPosition
//         markers: {
//           Marker(
//             markerId: const MarkerId("MarkerId"),
//             position: myCurrentLocation,
//             draggable: true,
//             onDragEnd: (value) {},
//             infoWindow: const InfoWindow(
//               title: "Title of the marker",
//               snippet: "More info about marker",
//             ), // InfoWindow
//             icon: customIcon,
//           ), // Marker
//         }, // markers
//       ), // GoogleMap
//     ); // Scaffold
//   } // Widget
// } // _GoogleMapScreenState


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';

// class GoogleMapScreen extends StatefulWidget {
//   final List<String> locations;
//   final List<String> transportModes;

//   const GoogleMapScreen({
//     super.key,
//     required this.locations,
//     required this.transportModes,
//   });

//   @override
//   State<GoogleMapScreen> createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {```dart
// Icons for transport modes
// BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;
// BitmapDescriptor trainIcon = BitmapDescriptor.defaultMarker;
// BitmapDescriptor planeIcon = BitmapDescriptor.defaultMarker;

// // ...

// void _loadCustomIcons() async {
//   carIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     'assets/images/car_marker.png',
//   );
//   trainIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     'assets/images/train_marker.png',
//   );
//   planeIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     'assets/images/plane_marker.png',
//   );
// }

// // ...

// BitmapDescriptor _getIconForMode(String mode) {
//   switch (mode) {
//     case 'Train':
//       return trainIcon;
//     case 'Plane':
//       return planeIcon;
//     default:
//       return carIcon;
//   }
// }

// // ...

// Future<void> _initializeMap() async {
//   final List<LatLng> locations = [];

//   for (String location in widget.locations) {
//     try {
//       final LatLng coordinates = await _getCoordinates(location);
//       locations.add(coordinates);

//       setState(() {
//         _markers.add(
//           Marker(
//             markerId: MarkerId(location),
//             position: coordinates,
//             infoWindow: InfoWindow(title: location),
//             icon: _getIconForMode(widget.transportModes[locations.length - 1]),
//           ),
//         );
//       });
//     } catch (e) {
//       print('Error decoding location: $e');
//     }
//   }

//   if (locations.isNotEmpty) {
//     _routePoints = await _getPolylinePoints(locations);
//     _startAnimation();
//   }
// }

// // ...

// void _startAnimation() {
//   int index = 0;

//   _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
//     if (index < _routePoints.length) {
//       setState(() {
//         _animatedPoints.add(_routePoints[index]);
//       });

//       _controller.animateCamera(
//         CameraUpdate.newLatLng(_routePoints[index]),
//       );

//       index++;
//     } else {
//       timer.cancel();
//     }
//   });
// }

// ...

// Future<List<LatLng>> _getPolylinePoints(List<LatLng> locations) async {
//   List<LatLng> polylinePoints = [];

//   for (int i = 0; i < locations.length - 1; i++) {
//     PolylinePoints polylinePointsGenerator = PolylinePoints();
//     PolylineResult result = await polylinePointsGenerator.getRouteBetweenCoordinates(
//       googleApiKey: 'AIzaSyDM5Yq_9zHc71-Dm2z8Sr90n5WxJ1PDzgM',
//       request: PolylineRequest(
//         origin: PointLatLng(locations[i].latitude, locations[i].longitude),
//         destination: PointLatLng(locations[i + 1].latitude, locations[i + 1].longitude),
//         mode: TravelMode.driving, // Change mode as per your requirement
//       ),
//     );

//     if (result.points.isNotEmpty) {
//       polylinePoints.addAll(result.points.map((point) => LatLng(point.latitude, point.longitude)));
//     }
//   }
//   return polylinePoints;
// }

// ...

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: const Text('Route Animation')),
//     body: GoogleMap(
//       initialCameraPosition: const CameraPosition(
//         target: LatLng(20.5937, 78.9629),
//         zoom: 5,
//       ),
//       onMapCreated: (controller) {
//         _controller = controller;
//       },
//       markers: _markers,
//       polylines: {
//         Polyline(
//           polylineId: const PolylineId('animatedRoute
//   late GoogleMapController _controller;
//   Set<Marker> markers = {};
//   List<LatLng> routePoints = [];
//   BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor trainIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor planeIcon = BitmapDescriptor.defaultMarker;

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomIcons();
//     _initializeMarkers();
//   }

//   void _loadCustomIcons() async {
//     carIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     'assets/images/marker21.png',
//       );
//        trainIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     'assets/images/marker21.png',
//       );
//        planeIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     'assets/images/marker21.png',
//       );
//   }

//   Future<void> _initializeMarkers() async {
//     for (int i = 0; i < widget.locations.length; i++) {
//       final location = widget.locations[i];
//       final transportMode = widget.transportModes[i];

//       try {
//         final List<Location> locations = await locationFromAddress(location);
//         final LatLng point = LatLng(locations[0].latitude, locations[0].longitude);

//         setState(() {
//           markers.add(
//             Marker(
//               markerId: MarkerId(location),
//               position: point,
//               infoWindow: InfoWindow(title: location),
//               icon: _getIconForMode(transportMode),
//             ),
//           );
//           routePoints.add(point);
//         });
//       } catch (e) {
//         print('Error finding location for $location: $e');
//       }
//     }
//   }

//   BitmapDescriptor _getIconForMode(String mode) {
//     switch (mode) {
//       case 'Train':
//         return trainIcon;
//       case 'Plane':
//         return planeIcon;
//       default:
//         return carIcon;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Travel Route Map')),
//       body: GoogleMap(
//         initialCameraPosition: const CameraPosition(
//           target: LatLng(20.5937, 78.9629),
//           zoom: 5,
//         ),
//         markers: {
//           Marker(markerId: const MarkerId('start'),
//            position: routePoints[0],
//            icon: carIcon,
//            infoWindow: const InfoWindow(
//             title: 'Start',
//             snippet: 'Start of the route'
//             ),
//            ),
//         },
//         polylines: {
//           Polyline(
//             polylineId: const PolylineId('route'),
//             points: routePoints,
//             color: Colors.redAccent,
//             width: 4,
//           ),
//         },
//         onMapCreated: (controller) {
//           _controller = controller;
//         },
//       ),
//     );
//   }
// }
