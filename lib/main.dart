import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:live_location_services/controllers/global_controller.dart';
import 'package:live_location_services/screens/home_screen.dart';
import 'package:live_location_services/utils/background_services.dart';
import 'package:live_location_services/utils/flutter_background_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Define notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  // Initialize FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notification channel
  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  // Create notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Configure background service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: backgroundServiceLogic, // Use the background service logic from the utils file
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializingooo',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: backgroundServiceLogic,
      onBackground: onIosBackground,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LIVE LOCATION SERVICES',
      getPages: GetPages.getPages,
      initialBinding: RootBindings(),
      initialRoute: RouteName.homeScreen,
    );
  }
}

class RootBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
  }
}

class RouteName {
  static const String homeScreen = "/homeScreen";
}

class GetPages {
  static List<GetPage> get getPages => [
        GetPage(
          name: RouteName.homeScreen,
          page: () => const HomeScreen(),
        ),
      ];
}
