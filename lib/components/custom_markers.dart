import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkers {
  static Future<BitmapDescriptor> loadCustomIcon(String path) async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      path,
    );
  }
}
