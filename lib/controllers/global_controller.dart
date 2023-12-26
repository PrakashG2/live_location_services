import 'package:get/get.dart';

class GlobalController extends GetxController {
  RxBool locationPermission = false.obs;

  RxDouble lattitude = 0.00.obs;
  RxDouble longitude = 0.00.obs;
}
