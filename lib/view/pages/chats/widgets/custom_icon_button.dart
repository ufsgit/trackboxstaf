import 'package:breffini_staff/core/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineWhiteA => BoxDecoration(
        color: appTheme.blue80001,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.whiteA700.withOpacity(0.22),
          width: 1.h,
        ),
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.circular(30.h),
      );
  static BoxDecoration get gradientBlueToBlue => BoxDecoration(
        borderRadius: BorderRadius.circular(24.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blueGray20019.withOpacity(0.5),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              4,
            ),
          )
        ],
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          colors: [appTheme.blue60001, appTheme.blue80003],
        ),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray10002,
        borderRadius: BorderRadius.circular(28.h),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.circular(25.h),
        border: Border.all(
          color: appTheme.gray100,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGrayTL25 => BoxDecoration(
        color: appTheme.gray10002,
        borderRadius: BorderRadius.circular(25.h),
        border: Border.all(
          color: appTheme.gray100,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGrayTL24 => BoxDecoration(
        color: appTheme.gray800,
        borderRadius: BorderRadius.circular(24.h),
        border: Border.all(
          color: appTheme.gray700,
          width: 1.h,
        ),
      );
  static BoxDecoration get fillRed => BoxDecoration(
        color: appTheme.red400,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get gradientBlueToBlueTL18 => BoxDecoration(
        borderRadius: BorderRadius.circular(18.h),
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          colors: [appTheme.blue60001, appTheme.blue80003],
        ),
      );
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.alignment,
      this.height,
      this.width,
      this.padding,
      this.decoration,
      this.child,
      this.onTap});

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  color: appTheme.blue50,
                  borderRadius: BorderRadius.circular(12.h),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}
