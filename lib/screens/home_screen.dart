import 'dart:async';
import 'package:flutter/material.dart';
import 'package:live_location_services/widgets/log_list.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:live_location_services/controllers/global_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Location location;
  StreamSubscription<LocationData>?
      _locationSubscription; // Declare stream subscription

  // Controller instance
  final GlobalController _globalController = Get.find();

  @override
  void initState() {
    super.initState();
    location = Location();
    checkPermission();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel(); // Cancel subscription on dispose
    super.dispose();
  }

  // Check permission function
  void checkPermission() async {
    final isLocationServiceEnabled = await location.serviceEnabled();
    if (!isLocationServiceEnabled) {
      print("LOCATION SERVICE DISABLED");
      // Prompt user to enable
    } else {
      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission == PermissionStatus.denied) {
          print("LOCATION PERMISSION DENIED");
          // Handle permission denial
        } else {
          startTrackingLocation();
        }
      } else {
        startTrackingLocation();
      }
    }
  }

  // Start tracking location
  Future<void> startTrackingLocation() async {
    // Change location settings if needed
    await changeSettings();

    // Enable background mode
    location.enableBackgroundMode(enable: true);

    // Subscribe to location changes
    _locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      _globalController.lattitude.value = currentLocation.latitude!;
      _globalController.longitude.value = currentLocation.longitude!;
      print(
          "Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}");
    });
  }

  // Change location settings
  Future<void> changeSettings({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int interval = 1000,
    double distanceFilter = 2,
  }) async {
    await location.changeSettings(
      accuracy: accuracy,
      interval: interval,
      distanceFilter: distanceFilter,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LIVE LOCATION SERVICES"),
      ),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Live Latitude: ${_globalController.lattitude.value}"),
            Text("Live Longitude: ${_globalController.longitude.value}"),
Expanded(child: ListViewWidget())          ],
        ),
      ),
    );
  }
}
