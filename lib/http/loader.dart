import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Loader {
  static void showLoader({bool dismissible = true}) {
    showDialog(
      barrierDismissible: dismissible,
      barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (ctx) => Center(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.white,
          ),
          child: const CircularProgressIndicator(
            color: ColorResources.colorBlue600,
          ),
        ),
      ),
    );
  }

  static void showLoaderChat() {
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (ctx) => Center(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: const CircularProgressIndicator(
            color: ColorResources.colorBlue500,
          ),
        ),
      ),
    );
  }

  static void stopLoader() {
    Get.back(closeOverlays: false);
  }
}
