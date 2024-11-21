import 'package:flutter/material.dart';
import 'package:travel_app/utils/icon_utils.dart';

class LocationListItem extends StatelessWidget {
  final String location;
  final String transportMode;
  final int index;

  const LocationListItem({
    super.key,
    required this.location,
    required this.transportMode,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          getIconForIndex(index),
          color: Colors.purple,
        ),
        title: Text(
          location,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Transport: $transportMode',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Icon(
          getIconForTransport(transportMode),
          color: Colors.purple,
        ),
      ),
    );
  }
}
