import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/color_resources.dart';

class PopUpMenuItems extends StatelessWidget {
  const PopUpMenuItems(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final String icon;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(
            width: 05,
          ),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
                color: ColorResources.colorBlack,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
