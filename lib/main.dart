import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_location_services/controllers/global_controller.dart';
import 'package:live_location_services/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
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
