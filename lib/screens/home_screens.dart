// import 'dart:async';
// import 'package:flutter/material.dart';
// //package imports
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// //getX controller imports
// import 'package:live_location_services/controllers/global_controller.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late StreamSubscription<Position> positionStreamSubscription;

// // Controller instance
//   final GlobalController _globalController = Get.find();

// //init state
//   @override
//   void initState() {
//     super.initState();
//     checkPermission();
//   }

// //dispose
//   @override
//   void dispose() {
//     positionStreamSubscription.cancel();
//     super.dispose();
//   }

//   // Check permission function
//   void checkPermission() async {
//     final isLocationServiceEnabled =
//         await Geolocator.isLocationServiceEnabled();
//     if (!isLocationServiceEnabled) {
//       print("LOCATION SERVICE DISABLED");
//       Geolocator.openLocationSettings();
//       LocationPermission locationPermission =
//           await Geolocator.checkPermission();
//       if (locationPermission == LocationPermission.denied) {
//         locationPermission = await Geolocator.requestPermission();
//         if (locationPermission == LocationPermission.denied) {
//           print("LOCATION PERMISSION DENIED");
//           Geolocator.openAppSettings();
//         } else {
//           fetchLiveLocation();
//         }
//       }
//     } else {
//       fetchLiveLocation();
//     }
//   }

//   // Live location service function
//   final LocationSettings geoLocatorSettings = const LocationSettings(
//       accuracy: LocationAccuracy.best, distanceFilter: 10);

//   void fetchLiveLocation() {
//     positionStreamSubscription =
//         Geolocator.getPositionStream(locationSettings: geoLocatorSettings)
//             .listen((position) {
//       print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
//       _globalController.lattitude.value = position.latitude;
//       _globalController.longitude.value = position.longitude;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("LIVE LOCATION SERVICES"),
//       ),
//       body: Obx(
//         () => Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Live Latitude: ${_globalController.lattitude.value}"),
//             Text("Live Longitude: ${_globalController.longitude.value}")
//           ],
//         ),
//       ),
//     );
//   }
// }
