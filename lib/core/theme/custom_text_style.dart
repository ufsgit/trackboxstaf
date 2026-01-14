import 'package:breffini_staff/core/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get plusJakartaSans {
    return copyWith(
      fontFamily: 'Plus Jakarta Sans',
    );
  }

  TextStyle get syne {
    return copyWith(
      fontFamily: 'Syne',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static get bodyLargePlusJakartaSansBluegray80003 =>
      theme.textTheme.bodyLarge!.plusJakartaSans.copyWith(
        color: appTheme.blueGray80003,
      );
  static get bodyMediumBlack900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
      );
  static get bodyMediumBluegray40002 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray40002,
      );
  static get bodyMediumBluegray500 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray500,
      );
  static get bodyMediumBluegray500_1 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray500,
      );
  static get bodyMediumBluegray80001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray80001,
      );
  static get bodyMediumInterGray200 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: appTheme.gray200,
      );
  static get bodyMediumOnErrorContainer => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer.withOpacity(0.5),
      );
  static get bodyMedium_1 => theme.textTheme.bodyMedium!;
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
        fontSize: 12.sp,
      );
  static get bodySmallBlack900_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );
  static get bodySmallBlue80003 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blue80003,
      );
  static get bodySmallBluegray40001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray40001,
      );
  static get bodySmallBluegray500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500,
      );
  static get bodySmallBluegray50012 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500,
        fontSize: 12.sp,
      );
  static get bodySmallBluegray500_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500,
      );
  static get bodySmallBluegray500_2 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray500,
      );
  static get bodySmallBluegray700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray700,
        fontSize: 12.sp,
      );
  static get bodySmallBluegray80003 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray80003,
      );
  static get bodySmallGray600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
        fontSize: 12.sp,
      );
  static get bodySmallGray600_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
      );
  static get bodySmallWhiteA700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.whiteA700,
      );
  static get bodySmallWhiteA70012 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 12.sp,
      );
  static get bodySmallWhiteA70012_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 12.sp,
      );
// Headline text style
  static get headlineSmallBluegray800 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.blueGray800,
        fontWeight: FontWeight.w600,
      );
  static get headlineSmallWhiteA700 => theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.whiteA700,
      );
// Label text style
  static get labelLargeAmber700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.amber700,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBlack900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBlue800 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blue800,
      );
  static get labelLargeBlue80003 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blue80003,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBluegray500 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
      );
  static get labelLargeBluegray500Medium =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBluegray500Medium_1 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBluegray500_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
      );
  static get labelLargeBluegray500_2 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
      );
  static get labelLargeBluegray500_3 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
      );
  static get labelLargeGray10002 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray10002,
      );
  static get labelLargeGray80001 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray80001,
      );
  static get labelLargeGray80001Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray80001,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInter => theme.textTheme.labelLarge!.inter.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get labelLargeInterBlack900 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeInterBlack900Bold =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeInterBlack900Medium =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.black900.withOpacity(0.4),
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterBlack900Medium_1 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterBlack900_1 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.black900,
      );
  static get labelLargeInterBlue800 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.blue800,
      );
  static get labelLargeInterBluegray500 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterBluegray500Bold =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeInterBluegray800 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.blueGray800,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeInterOnError =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: theme.colorScheme.onError,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterPrimaryContainer =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterWhiteA700 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeMedium => theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get labelLargeOnError => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onError,
        fontWeight: FontWeight.w500,
      );
  static get labelLargePrimaryContainer => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get labelLargeWhiteA700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeWhiteA700Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.whiteA700.withOpacity(0.65),
        fontWeight: FontWeight.w500,
      );
  static get labelLarge_1 => theme.textTheme.labelLarge!;
  static get labelMediumBlack900 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.black900,
      );
  static get labelMediumBluegray500 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w600,
      );
  static get labelMediumBluegray500SemiBold =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w600,
      );
  static get labelMediumWhiteA700 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.whiteA700.withOpacity(0.8),
        fontWeight: FontWeight.w500,
      );
// Title text style
  static get titleMedium18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.sp,
      );
  static get titleMedium18_1 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.sp,
      );
  static get titleMediumBluegray800 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray800,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumBluegray80001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray80001,
        fontSize: 18.sp,
      );
  static get titleMediumBluegray8000118 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray80001,
        fontSize: 18.sp,
      );
  static get titleMediumBluegray80018 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray800,
        fontSize: 18.sp,
      );
  static get titleMediumBluegray800Medium =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray800.withOpacity(0.67),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumMedium_1 => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumSyne => theme.textTheme.titleMedium!.syne.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumWhiteA700 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
      );
  static get titleMedium_1 => theme.textTheme.titleMedium!;
  static get titleMedium_2 => theme.textTheme.titleMedium!;
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
      );
  static get titleSmallBlack900Medium => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBlack900_1 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
      );
  static get titleSmallBlue800 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blue800,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray300 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray300,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray300Medium =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray300,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray500 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray500Medium =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray500Medium_1 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray800 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray800,
      );
  static get titleSmallBluegray80001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray80001,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray80001Medium =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray80001.withOpacity(0.6),
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray800Medium =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray800.withOpacity(0.67),
        fontWeight: FontWeight.w500,
      );
  static get titleSmallGray80001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray80001,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallInterBlack900 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallInterWhiteA700 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallMedium => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallMedium_1 => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallMedium_2 => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallMedium_3 => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallMedium_4 => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallPrimaryContainer => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get titleSmallPrimaryContainerMedium =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get titleSmallWhiteA700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
      );
  static get titleSmallWhiteA700Medium => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallWhiteA700SemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallWhiteA700_1 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
      );
  static get titleSmall_1 => theme.textTheme.titleSmall!;
}
