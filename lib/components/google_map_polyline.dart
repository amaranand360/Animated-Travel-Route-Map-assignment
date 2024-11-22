import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

class MapPolylineForRoute {
  static Future<List<LatLng>> getRoutePoints(
    List<LatLng> locations, String apiKey) async {
    List<LatLng> polylinePoints = [];
    for (int i = 0; i < locations.length - 1; i++) {
      PolylinePoints polylinePointsGenerator = PolylinePoints();
      PolylineResult result =
          await polylinePointsGenerator.getRouteBetweenCoordinates(
          googleApiKey: googleApiKey,
          request: PolylineRequest(
          origin: PointLatLng(locations[i].latitude, locations[i].longitude),
          destination: PointLatLng(
            locations[i + 1].latitude, locations[i + 1].longitude),
            mode: TravelMode.driving,
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
