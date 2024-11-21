import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPolylineForRoute {
  static Future<List<LatLng>> getRoutePoints(
    List<LatLng> locations, String apiKey) async {
    List<LatLng> polylinePoints = [];
    for (int i = 0; i < locations.length - 1; i++) {
      PolylinePoints polylinePointsGenerator = PolylinePoints();
      PolylineResult result =
          await polylinePointsGenerator.getRouteBetweenCoordinates(
          googleApiKey: 'AIzaSyDM5Yq_9zHc71-Dm2z8Sr90n5WxJ1PDzgM',
          request: PolylineRequest(
          origin: PointLatLng(locations[i].latitude, locations[i].longitude),
          destination: PointLatLng(
            locations[i + 1].latitude, locations[i + 1].longitude),
            mode: TravelMode.driving, // Change mode as per your requirement
        ),
      );

      if (result.points.isNotEmpty) {
        polylinePoints.addAll(result.points
            .map((point) => LatLng(point.latitude, point.longitude)));
      }
    }
    return polylinePoints;
  }
}
