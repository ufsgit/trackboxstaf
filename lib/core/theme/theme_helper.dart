import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  final _appTheme = PrefUtils().getThemeData();

// A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

// A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [newTheme].
  void changeTheme(String newTheme) {
    PrefUtils().setThemeData(newTheme);
    Get.forceAppUpdate();
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.gray10002,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: const BorderSide(
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.blue800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          shadowColor: colorScheme.primary,
          elevation: 2,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.indigo50,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.onErrorContainer.withOpacity(0.5),
          fontSize: 16.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.blueGray80003,
          fontSize: 14.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: colorScheme.primaryContainer.withOpacity(1),
          fontSize: 10.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: TextStyle(
          color: appTheme.blueGray80003,
          fontSize: 24.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: appTheme.blueGray80003,
          fontSize: 12.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 10.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: appTheme.blueGray80003,
          fontSize: 16.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: appTheme.blueGray80003,
          fontSize: 14.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = const ColorScheme.light(
    primary: Color(0X669B9B9B),
    primaryContainer: Color(0X87212A35),
    secondaryContainer: Color(0XFF5E9AF2),
    errorContainer: Color(0XFF256ECF),
    onError: Color(0XFF9199A2),
    onErrorContainer: Color(0X42000A13),
    onPrimary: Color(0X07101828),
    onPrimaryContainer: Color(0X99DDE6F9),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Amber
  Color get amber600 => const Color(0XFFFEB500);
  Color get amber700 => const Color(0XFFE4A400);
// Black
  Color get black900 => const Color(0XFF000000);
// Blue
  Color get blue100 => const Color(0XFFAECDF8);
  Color get blue20075 => const Color(0X75A2C6EB);
  Color get blue50 => const Color(0XFFE9F2FF);
  Color get blue5001 => const Color(0XFFDDEEFF);
  Color get blue5002 => const Color(0XFFE6EEFB);
  Color get blue600 => const Color(0XFF2B83D4);
  Color get blue60001 => const Color(0XFF3A7EE2);
  Color get blue60002 => const Color(0XFF1A7AE8);
  Color get blue60003 => const Color(0XFF1680E4);
  Color get blue70087 => const Color(0X87266ECF);
  Color get blue800 => const Color(0XFF1762D3);
  Color get blue80001 => const Color(0XFF055FD9);
  Color get blue80002 => const Color(0XFF0056D6);
  Color get blue80003 => const Color(0XFF0055D6);
  Color get blue900 => const Color(0XFF0B4AA7);
  Color get blueA200 => const Color(0XFF3A83E6);
// BlueGray
  Color get blueGray100 => const Color(0XFFCDD7DD);
  Color get blueGray10001 => const Color(0XFFD9D9D9);
  Color get blueGray200 => const Color(0XFFB1B5BC);
  Color get blueGray20001 => const Color(0XFFBAC1CA);
  Color get blueGray20019 => const Color(0X19ABC2D9);
  Color get blueGray300 => const Color(0XFF919CB0);
  Color get blueGray400 => const Color(0XFF7D8AA1);
  Color get blueGray40001 => const Color(0XFF888888);
  Color get blueGray40002 => const Color(0XFF7E8BA2);
  Color get blueGray50 => const Color(0XFFEEF1F4);
  Color get blueGray500 => const Color(0XFF6A7487);
  Color get blueGray5001 => const Color(0XFFF0F2F4);
  Color get blueGray700 => const Color(0XFF444B66);
  Color get blueGray800 => const Color(0XFF2F3D4D);
  Color get blueGray80001 => const Color(0XFF2F3D4E);
  Color get blueGray80002 => const Color(0XFF2D3A55);
  Color get blueGray80003 => const Color(0XFF273B51);
  Color get blueGray90066 => const Color(0X660C1E42);
// Gray
  Color get gray100 => const Color(0XFFF3F6F9);
  Color get gray10001 => const Color(0XFFF3F3F3);
  Color get gray10002 => const Color(0XFFF4F7FA);
  Color get gray200 => const Color(0XFFEEEEEE);
  Color get gray50 => const Color(0XFFF9FBFE);
  Color get gray600 => const Color(0XFF76777A);
  Color get gray700 => const Color(0XFF595959);
  Color get gray800 => const Color(0XFF414141);
  Color get gray80001 => const Color(0XFF393939);
// Graye
  Color get gray5005e => const Color(0X5EA8A8A8);
// Green
  Color get green800 => const Color(0XFF19B500);
  Color get greenA700 => const Color(0XFF00D648);
// Indigo
  Color get indigo100 => const Color(0XFFACC7EE);
  Color get indigo50 => const Color(0XFFE4EAF1);
  Color get indigo5001 => const Color(0XFFE3E7EE);
  Color get indigo900 => const Color(0XFF10347D);
// Indigoc
  Color get indigo1004c => const Color(0X4CC3D3E8);
// Indigoe
  Color get indigo1005e => const Color(0X5EB6C8E5);
// Orange
  Color get orange50 => const Color(0XFFF6EDD5);
// Red
  Color get red400 => const Color(0XFFF45F5F);
  Color get red40001 => const Color(0XFFF35E5E);
// White
  Color get whiteA700 => const Color(0XFFFFFFFF);
// Yellow
  Color get yellow700 => const Color(0XFFFFC024);
}
