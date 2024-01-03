// utils/background_service.dart

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_location_services/controllers/global_controller.dart';
import 'package:live_location_services/widgets/log_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

// Controller instance
final GlobalController _globalController = Get.put(GlobalController());

Future<bool> onIosBackground(ServiceInstance service) async {
  // Handle background logic for iOS
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

Future<Database> openDatabase() async {
  return sql.openDatabase(
    'location_db.db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE locations (id INTEGER PRIMARY KEY, latitude REAL, longitude REAL, timestamp TEXT)',
      );
    },
  );
}

Future<void> backgroundServiceLogic(ServiceInstance service) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  Geolocator geolocator = Geolocator();
  LocationSettings locationOptions = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 10, // set to your desired distance filter
  );

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );

          final db = await openDatabase();
          await db.insert(
            'locations',
            {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'timestamp': DateTime.now().toIso8601String(),
            },
          );
          // print('Location stored in database: ${position.latitude}, ${position.longitude}');

          // // Retrieve and print stored locations (optional)
          // final locations = await db.query('locations');
          // print('Retrieved locations:');
          // for (var location in locations) {
          //   print(
          //     'Latitude: ${location['latitude']}, Longitude: ${location['longitude']}, Timestamp: ${location['timestamp']}',
          //   );
          // }
          // Add the location log entry
          // _globalController.log.add(
          //   "Latitude: ${position.latitude}, Longitude: ${position.longitude}",
          // );

          // print("[[[[[[[[]]]]]]]]");
          // print(_globalController.log);
          // print(_globalController.log.length.toString());
          // print("[[[[[[[[]]]]]]]]");
        } catch (e) {
          print('Error fetching or storing location: $e');
        }
      }

      service.setForegroundNotificationInfo(
        title: "RUNNING IN BACKGROUND",
        content: "UPDATED ON ${DateTime.now()}",
      );
    }

    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');


    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}
