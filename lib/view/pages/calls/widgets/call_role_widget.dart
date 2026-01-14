import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/color_resources.dart';

class CallRoleWidget extends StatelessWidget {
  const CallRoleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 130,
      left: 15,
      right: 15,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 08),
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey.shade300,
            ),
            child: Row(
              children: [
                SvgPicture.asset("assets/images/Headset.svg"),
                const SizedBox(
                  width: 05,
                ),
                Text(
                  "You are Listner",
                  style: GoogleFonts.plusJakartaSans(
                      color: ColorResources.colorBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
