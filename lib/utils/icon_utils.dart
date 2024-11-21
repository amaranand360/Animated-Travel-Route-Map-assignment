import 'package:flutter/material.dart';

IconData getIconForTransport(String transportMode) {
  switch (transportMode) {
    case 'Car':
      return Icons.directions_car;
    case 'Bus':
      return Icons.directions_bus;
    case 'Train':
      return Icons.train;
    case 'Plane':
      return Icons.flight;
    default:
      return Icons.help_outline;
  }
}

IconData getIconForIndex(int index) {
  switch (index % 3) {
    case 0:
      return Icons.location_on;
    case 1:
      return Icons.place;
    case 2:
      return Icons.location_pin;
    default:
      return Icons.location_pin;
  }
}
