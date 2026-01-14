import 'package:get/get.dart';

class TabControllerState extends GetxController {
  // Rx variable to hold the current tab index
  var currentIndex = 0.obs;

  // Method to update the current tab index
  void setIndex(int index) {
    currentIndex.value = index;
  }
}
