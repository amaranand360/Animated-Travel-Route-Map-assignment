// import 'package:flutter/material.dart';

// class InputScreen extends StatefulWidget {
//   const InputScreen({super.key});

//   @override
//   State<InputScreen> createState() => _InputScreenState();
// }

// class _InputScreenState extends State<InputScreen> {
//   final List<Map<String, String>> journeyData = [];
//   final TextEditingController sourceController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//   String selectedTransportMode = 'Car';

//   void addJourney() {
//     String source = sourceController.text.trim();
//     String destination = destinationController.text.trim();

//     if (source.isEmpty || destination.isEmpty) {
//       _showErrorDialog("Please enter valid source and destination.");
//       return;
//     }

//     setState(() {
//       journeyData.add({
//         'source': source,
//         'destination': destination,
//         'transportMode': selectedTransportMode,
//       });
//     });

//     // Clear the input fields after adding the journey
//     sourceController.clear();
//     destinationController.clear();
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Error"),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Travel Route Input'),
//         backgroundColor: Colors.purple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Source Text Field
//             TextField(
//               controller: sourceController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Source',
//                 hintText: 'e.g., Delhi',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Destination Text Field
//             TextField(
//               controller: destinationController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Destination',
//                 hintText: 'e.g., Mumbai',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Transport Mode Dropdown
//             DropdownButtonFormField<String>(
//               value: selectedTransportMode,
//               items: const [
//                 DropdownMenuItem(value: 'Car', child: Text('Car')),
//                 DropdownMenuItem(value: 'Bus', child: Text('Bus')),
//                 DropdownMenuItem(value: 'Train', child: Text('Train')),
//                 DropdownMenuItem(value: 'Plane', child: Text('Plane')),
//               ],
//               onChanged: (mode) {
//                 if (mode != null) {
//                   setState(() {
//                     selectedTransportMode = mode;
//                   });
//                 }
//               },
//               decoration: const InputDecoration(
//                 labelText: 'Mode of Transport',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Add Button
//             ElevatedButton(
//               onPressed: addJourney,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.purple,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
//               ),
//               child: const Text(
//                 'Add Journey',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // List of Added Journeys
//             Expanded(
//               child: journeyData.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: journeyData.length,
//                       itemBuilder: (context, index) {
//                         var journey = journeyData[index];
//                         return Card(
//                           elevation: 4,
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             leading: Icon(
//                               Icons.location_on,
//                               color: Colors.purple,
//                             ),
//                             title: Text(
//                               '${journey['source']} to ${journey['destination']}',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               'Transport: ${journey['transportMode']}',
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                             trailing: Icon(
//                               Icons.directions_car,
//                               color: Colors.purple,
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : const Center(
//                       child: Text(
//                         'No journeys added yet!',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:travel_app/screens/google_map.dart';


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
        title: const Text('Travel Route Input'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Enter Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedTransportMode,
              items: const [
                DropdownMenuItem(value: 'Car', child: Text('Car')),
                DropdownMenuItem(value: 'Bus', child: Text('Bus')),
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

// class InputScreen extends StatefulWidget {
//   const InputScreen({super.key});

//   @override
//   State<InputScreen> createState() => _InputScreenState();
// }

// class _InputScreenState extends State<InputScreen> {
//   final List<String> locations = [];
//   final List<String> transportModes = [];
//   final TextEditingController locationController = TextEditingController();

//   // Add location and transport mode
//   void addLocation(String location, String transportMode) {
//     setState(() {
//       // Capitalize the first letter of the location
//       String formattedLocation = location.trim();
//       if (formattedLocation.isEmpty) {
//       // Show a dialog for empty input
//       _showErrorDialog("Please enter a valid city name.");
//       return;
//       }
//       else if (formattedLocation.isNotEmpty) {
//         formattedLocation =
//             formattedLocation[0].toUpperCase() + formattedLocation.substring(1);
//       }

//       locations.add(formattedLocation);
//       transportModes.add(transportMode);
//     });
//     locationController.clear();
//   }

//    // Function to show an error dialog
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Invalid Input'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to return different icons for locations
//   IconData _getIconForIndex(int index) {
//     switch (index % 4) {
//       case 0:
//         return Icons.location_on; // Red pin
//       case 1:
//         return Icons.place; // Blue pin
//       case 2:
//         return Icons.map; // Yellow map icon
//       case 3:
//         return Icons.location_pin; // Green flag
//       default:
//         return Icons.location_searching; // Default
//     }
//   }

//   // Function to return different colors for locations
//   Color _getColorForIndex(int index) {
//     switch (index % 4) {
//       case 0:
//         return Colors.red; // Red for the first icon
//       case 1:
//         return Colors.blue; // Blue for the second icon
//       case 2:
//         return Colors.yellow.shade700; // Yellow for the third icon
//       case 3:
//         return Colors.green; // Green for the fourth icon
//       default:
//         return Colors.grey; // Default color
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Travel Route Input'),
//         backgroundColor: Colors.purple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Location Input Field
//             TextField(
//               controller: locationController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Location',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Dropdown for transport mode
//             DropdownButtonFormField<String>(
//               value: 'Car',
//               items: const [
//                 DropdownMenuItem(value: 'Car', child: Text('Car')),
//                 DropdownMenuItem(value: 'Bus', child: Text('Bus')),
//                 DropdownMenuItem(value: 'Train', child: Text('Train')),
//                 DropdownMenuItem(value: 'Plane', child: Text('Plane')),
//               ],
//               onChanged: (mode) {
//                 // Handle transport mode selection
//               },
//               decoration: const InputDecoration(
//                 labelText: 'Mode of Transport',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Add Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (locationController.text.isNotEmpty) {
//                     addLocation(locationController.text, 'Car');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15.0, horizontal: 25.0),
//                 ),
//                 child: const Text(
//                   'Add Location',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Display list of locations
//             Expanded(
//               child: locations.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: locations.length,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           elevation: 4,
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             leading: Icon(
//                               _getIconForIndex(index), // Dynamic icon
//                               color: _getColorForIndex(
//                                   index), // Dynamic color based on index
//                               size: 30,
//                             ),
//                             title: Text(
//                               locations[index],
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               'Transport: ${transportModes[index]}',
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                             trailing: Icon(
//                               transportModes[index] == 'Car'
//                                   ? Icons.directions_car
//                                   : transportModes[index] == 'Bus'
//                                       ? Icons.directions_bus
//                                       : transportModes[index] == 'Train'
//                                           ? Icons.train
//                                           : Icons.flight,
//                               color: Colors.purple,
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : const Center(
//                       child: Text(
//                         'No locations added yet!',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 10),
//             // Visualize Route Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (locations.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => GoogleMapFlutter(
//                           locations: locations,
//                           transportModes: transportModes,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15.0, horizontal: 25.0),
//                 ),
//                 child: const Text(
//                   'Visualize Route',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }