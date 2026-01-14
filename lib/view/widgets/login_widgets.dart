import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget elevatedButtonWidget(
    {required String text,
    required String logo,
    required void Function()? onPressed,
    required BuildContext context}) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width,
    height: 48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorResources.colorwhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(logo),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: ColorResources.colorgrey700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buttonWidget({
  required BuildContext context,
  required String text,
  required Color? backgroundColor,
  required Color? txtColor,
  required double height,
  required double width,
  required double fontSize,
  required void Function()? onPressed,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: FittedBox(
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            color: txtColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          // overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}

Widget textFieldWidget(
    {required TextEditingController? controller,
    required String? labelText,
    required double? height,
    void Function(String)? onChanged,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon}) {
  return SizedBox(
    height: height,
    child: TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      controller: controller,
      style: GoogleFonts.plusJakartaSans(
        color: ColorResources.colorgrey800,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: labelText,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: ColorResources.colorgrey600,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        fillColor: ColorResources.colorwhite,
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: ColorResources.colorgrey700, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: ColorResources.colorgrey400, width: 1.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorResources.colorgrey200)),
      ),
    ),
  );
}
