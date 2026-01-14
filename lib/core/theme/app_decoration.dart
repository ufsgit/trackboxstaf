import 'package:breffini_staff/core/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlack => BoxDecoration(
        color: appTheme.black900.withOpacity(0.5),
      );
  static BoxDecoration get fillBlack900 => BoxDecoration(
        color: appTheme.black900.withOpacity(0.6),
      );
  static BoxDecoration get fillBlack9001 => BoxDecoration(
        color: appTheme.black900,
      );
  static BoxDecoration get fillBlack9002 => BoxDecoration(
        color: appTheme.black900.withOpacity(0.3),
      );
  static BoxDecoration get fillBlue => BoxDecoration(
        color: appTheme.blue800,
      );
  static BoxDecoration get fillBlue5002 => BoxDecoration(
        color: appTheme.blue5002,
      );
  static BoxDecoration get fillBlue80003 => BoxDecoration(
        color: appTheme.blue80003.withOpacity(0.1),
      );
  static BoxDecoration get fillErrorContainer => BoxDecoration(
        color: theme.colorScheme.errorContainer,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray10002,
      );
  static BoxDecoration get fillIndigo => BoxDecoration(
        color: appTheme.indigo5001,
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange50,
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );
// Gradient decorations
  static BoxDecoration get gradientBlueToBlue => const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
            Color(0xffFFFFFF),

            Color.fromARGB(255, 86, 141, 217),
            //  Color(0xff1580E3),
            // Color(0xffFFFFFF),
          ]));

  //  BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment(1, 0.5),
  //         end: Alignment(0.02, 0.19),
  //         colors: [appTheme.blue800.withOpacity(0), appTheme.blue800],
  //       ),
  //     );
  static BoxDecoration get gradientGrayToGray => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.52, -0.02),
          end: const Alignment(0.52, 0.44),
          colors: [appTheme.gray10002.withOpacity(0), appTheme.gray10002],
        ),
      );
  static BoxDecoration get gradientWhiteAToWhiteA => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.53, 0.43),
          end: const Alignment(0.53, 0),
          colors: [appTheme.whiteA700, appTheme.whiteA700.withOpacity(0)],
        ),
      );
  static BoxDecoration get gradientWhiteAToWhiteA700 => BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: const Alignment(0.53, 0.28),
          end: const Alignment(0.53, 0),
          colors: [appTheme.whiteA700, appTheme.whiteA700.withOpacity(0)],
        ),
      );
// Outline decorations
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: appTheme.blueGray5001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBluegray20001 => BoxDecoration(
        color: appTheme.indigo5001,
        border: Border.all(
          color: appTheme.blueGray20001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBluegray20019 => BoxDecoration(
        color: appTheme.blueGray80003,
        boxShadow: [
          BoxShadow(
            color: appTheme.blueGray20019.withOpacity(0.4),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              4,
            ),
          )
        ],
      );
  static BoxDecoration get outlineBluegray200191 => BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: appTheme.blueGray20019,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              4,
            ),
          )
        ],
      );
  static BoxDecoration get outlineBluegray50 => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: appTheme.blueGray50,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBluegray501 => BoxDecoration(
        color: appTheme.black900.withOpacity(0.4),
        border: Border.all(
          color: appTheme.blueGray50.withOpacity(0.2),
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: appTheme.gray10002,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineIndigo => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: appTheme.indigo5001,
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.indigo1004c,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              2,
            ),
          )
        ],
      );
  static BoxDecoration get outlineIndigo5001 => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: appTheme.indigo5001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOnErrorContainer => BoxDecoration(
        color: appTheme.whiteA700,
        border: Border.all(
          color: theme.colorScheme.onErrorContainer,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOnPrimary => const BoxDecoration();
  static BoxDecoration get outlineWhiteA => BoxDecoration(
        border: Border.all(
          color: appTheme.whiteA700.withOpacity(0.6),
          width: 1.h,
        ),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder18 => BorderRadius.circular(
        18.h,
      );
  static BorderRadius get circleBorder21 => BorderRadius.circular(
        21.h,
      );
  static BorderRadius get circleBorder38 => BorderRadius.circular(
        38.h,
      );
// Custom borders
  static BorderRadius get customBorderBL12 => BorderRadius.vertical(
        bottom: Radius.circular(12.h),
      );
  static BorderRadius get customBorderBL21 => BorderRadius.only(
        topRight: Radius.circular(21.h),
        bottomLeft: Radius.circular(21.h),
        bottomRight: Radius.circular(21.h),
      );
  static BorderRadius get customBorderBL24 => BorderRadius.vertical(
        bottom: Radius.circular(24.h),
      );
  static BorderRadius get customBorderTL12 => BorderRadius.vertical(
        top: Radius.circular(12.h),
      );
  static BorderRadius get customBorderTL121 => BorderRadius.only(
        topLeft: Radius.circular(12.h),
        topRight: Radius.circular(12.h),
        bottomLeft: Radius.circular(12.h),
      );
  static BorderRadius get customBorderTL122 => BorderRadius.only(
        topLeft: Radius.circular(12.h),
        topRight: Radius.circular(12.h),
        bottomRight: Radius.circular(12.h),
      );
  static BorderRadius get customBorderTL18 => BorderRadius.vertical(
        top: Radius.circular(18.h),
      );
// Rounded borders
  static BorderRadius get roundedBorder1 => BorderRadius.circular(
        1.h,
      );
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h,
      );
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15.h,
      );
  static BorderRadius get roundedBorder4 => BorderRadius.circular(
        4.h,
      );
  static BorderRadius get roundedBorder62 => BorderRadius.circular(
        62.h,
      );
  static BorderRadius get roundedBorder71 => BorderRadius.circular(
        71.h,
      );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h,
      );
  static BorderRadius get roundedBorder81 => BorderRadius.circular(
        81.h,
      );
}
