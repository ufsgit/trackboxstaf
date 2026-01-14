import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void safeBack({bool canPop = true}) {
  try {
    final currentState = Get.key.currentState;
    if (currentState != null && currentState.canPop()) {
      Get.back(canPop: canPop);
    } else {
      // Handle null state or no routes
      // For example:
      print('Cannot go back - navigator state is null or no routes to pop');
    }
  } catch (e) {
    print('Error during navigation: $e');
    // Handle the error appropriately
  }
}

Future<void> handleChatNotification() async {
  // // Store current route to check if we're already on home
  // final currentRoute = Get.currentRoute;
  //
  // // If we're not already on home screen, navigate back to it
  // if (currentRoute != '/') {
  //   // Get back to home screen by popping until home
  //   while (Get.currentRoute != '/') {
  //     if (Get.previousRoute == '') break; // Stop if no more routes
  //     await Future.delayed(const Duration(milliseconds: 100));
  //     safeBack();
  //   }
  //
  //   // // If we couldn't find home in stack, navigate directly
  //   // if (Get.currentRoute != '/home') {
  //   //   Get.offAll(() => HomeScreen());
  //   // }
  // }
  //
  // // Short delay to ensure home screen is loaded
  // await Future.delayed(const Duration(milliseconds: 100));
}

Future<bool> isCallExist(BuildContext context,CallandChatController controller) async {
  bool isCallExist=false;
  if(controller.currentCallModel.value.callId.isNullOrEmpty()){
    isCallExist= false;
  }else{
    if(controller.currentCallModel.value.type=="new_call") {
      isCallExist = await FirebaseUtils.isAnyCallExists();
    }else{
      isCallExist= true;

    }
  }
  if(!controller.currentCallModel.value.callId.isNullOrEmpty()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
          Text("Cant place new call. While you are in another call or live")),
    );
  }
  return isCallExist;
}
