import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Container commonBackgroundLinearColor({required Widget childWidget}) {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ColorResources.backgroundColors)),
    child: childWidget,
  );
}
