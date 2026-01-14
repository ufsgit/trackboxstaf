import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/pages/courses/widgets/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: ResponsiveExtension(12).h),
    child: Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: ColorResources.colorgrey700,
      ),
    ),
  );
}

Widget profileActionTile({
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(bottom: ResponsiveExtension(8).h),
      padding: EdgeInsets.symmetric(
          horizontal: 16, vertical: ResponsiveExtension(14).h),
      decoration: BoxDecoration(
        color: ColorResources.colorwhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorResources.colorgrey700,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    ),
  );
}
