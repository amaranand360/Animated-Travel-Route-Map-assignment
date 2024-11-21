import 'package:flutter/material.dart';
import 'package:travel_app/screens/google_map.dart';
import 'package:travel_app/components/error_dialog.dart';
import 'package:travel_app/components/location_list_item.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final List<String> locations = [];
  final List<String> transportModes = [];
  final TextEditingController locationController = TextEditingController();
  String selectedTransportMode = 'Car';

  void addLocation() {
    String formattedLocation = locationController.text.trim();

    if (formattedLocation.isEmpty) {
      _showErrorDialog("Please enter a valid city name.");
      return;
    }

    setState(() {
      formattedLocation =
          formattedLocation[0].toUpperCase() + formattedLocation.substring(1);
      locations.add(formattedLocation);
      transportModes.add(selectedTransportMode);
    });

    locationController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Travel Route Input')),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Enter Location or City',
                suffixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedTransportMode,
              items: const [
                DropdownMenuItem(value: 'Car', child: Text('Car')),
                DropdownMenuItem(value: 'Train', child: Text('Train')),
                DropdownMenuItem(value: 'Plane', child: Text('Plane')),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  setState(() {
                    selectedTransportMode = mode;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Mode of Transport',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: addLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                ),
                child: const Text(
                  'Add Location',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: locations.isNotEmpty
                  ? ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        return LocationListItem(
                          location: locations[index],
                          transportMode: transportModes[index],
                          index: index,
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No locations added yet!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (locations.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimatedRouteMap(
                          locations: locations,
                          transportModes: transportModes,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                ),
                child: const Text(
                  'Visualize Route',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
