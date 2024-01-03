import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:live_location_services/controllers/global_controller.dart';
import 'package:live_location_services/utils/background_services.dart';
import 'package:intl/intl.dart';

class ListViewWidget extends StatefulWidget {
  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  // Controller instance
  final GlobalController _globalController = Get.put(GlobalController());
  List<Map<String, dynamic>> locationList = [];
    late Timer _timer;


   @override
  void initState() {
    super.initState();
    fetchLocalDb();

    // Start a periodic timer
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      fetchLocalDb();
    });
  }

  // Rest of the code remains the same

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }


  Future<void> fetchLocalDb() async {
    final db = await openDatabase();

    final locations = await db.query('locations');
    print('Retrieved locations:');

    // Map the data and add to the list
    locationList = locations.map((location) {
      return {
        'latitude': location['latitude'],
        'longitude': location['longitude'],
        'timestamp': location['timestamp'],
      };
    }).toList();

    // Print or use the mapped locationList
    print('Mapped Location List: $locationList');

    setState(() {
      
    });

    // Ensure the widget is still mounted before calling setState
    
  }

  String formatTimestamp(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final DateFormat formatter = DateFormat('HH:mm:ss dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      itemCount: locationList.isEmpty
          ? 1
          : locationList.length, // Access length reactively
      itemBuilder: (context, index) {
        if (locationList.isEmpty) {
          return ListTile(
            title: Text("empty"), // Access value reactively
          );
        } else {
           final reversedIndex = locationList.length - 1 - index;
      final currentLocation = locationList[reversedIndex];
          return Container(
            
            
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Location Icon
                Icon(Icons.location_on, size: 32.0, color: Colors.blue),

                // Padding between icon and information
                SizedBox(width: 16.0),

                // Column containing latitude, longitude, and timestamp
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(
                  'Latitude: ${currentLocation['latitude']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Longitude: ${currentLocation['longitude']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Timestamp: ${currentLocation['timestamp']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
