import 'package:breffini_staff/core/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillWhiteA => ElevatedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );
// Gradient button style
  static BoxDecoration get gradientBlueToBlueDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.gray5005e,
          width: 1.h,
        ),
        gradient: LinearGradient(
          begin: const Alignment(0.0, 0),
          end: const Alignment(1.0, 0),
          colors: [appTheme.blue60003, appTheme.blue80002],
        ),
      );
  static BoxDecoration get gradientBlueToBlueTL16Decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              1,
              2,
            ),
          )
        ],
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 0),
          colors: [appTheme.blue60001, appTheme.blue80003],
        ),
      );
  static BoxDecoration get gradientBlueToBlueTL17Decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(17.h),
        gradient: LinearGradient(
          begin: const Alignment(0.0, 0),
          end: const Alignment(1.06, 0),
          colors: [appTheme.blue60003, appTheme.blue80002],
        ),
      );
  static BoxDecoration get gradientBlueToSecondaryContainerDecoration =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(14.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blueGray90066,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              4,
            ),
          )
        ],
        gradient: LinearGradient(
          begin: const Alignment(-0.17, 0),
          end: const Alignment(1.19, 1),
          colors: [appTheme.blue5001, theme.colorScheme.secondaryContainer],
        ),
      );
// Outline button style
  static ButtonStyle get outlineBlue => OutlinedButton.styleFrom(
        backgroundColor: appTheme.blue800,
        side: BorderSide(
          color: appTheme.blue800,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get outlineBlueGray => OutlinedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        side: BorderSide(
          color: appTheme.blueGray500,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get outlineBlueGrayTL12 => OutlinedButton.styleFrom(
        backgroundColor: appTheme.gray10002,
        side: BorderSide(
          color: appTheme.blueGray500,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get outlineBlueGrayTL18 => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: appTheme.blueGray20001,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.h),
        ),
      );
  static ButtonStyle get outlineBlueGrayTL20 => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide.none,

        // BorderSide(
        //   color: appTheme.blueGray80003,
        //   width: 1,
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
      );
  static ButtonStyle get outlineBlueTL12 => OutlinedButton.styleFrom(
        backgroundColor: appTheme.blue800,
        side: BorderSide(
          color: appTheme.blue800,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get outlineBlueTL121 => OutlinedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        side: BorderSide(
          color: appTheme.blue800,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get outlinePrimary => ElevatedButton.styleFrom(
        backgroundColor: appTheme.blue80003,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
        shadowColor: theme.colorScheme.primary,
        elevation: 2,
      );
// text button style
  static ButtonStyle get none => ButtonStyle(
        side: WidgetStateProperty.all<BorderSide?>(BorderSide.none),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
      );
}
