import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ModuleWidget extends StatelessWidget {
  final String badgeIcon;
  final String moduleName;
  final VoidCallback? onTap;
  final bool isLocked;
  final bool isSelected;

  const ModuleWidget({
    super.key,
    required this.badgeIcon,
    required this.moduleName,
    required this.onTap,
    required this.isLocked,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: !isLocked ? Colors.white : ColorResources.colorgrey300,
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : (!isLocked
                    ? ColorResources.colorgrey100
                    : ColorResources.colorgrey400),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 40,
                          child: Image.asset(badgeIcon),
                        ),
                        const Expanded(child: SizedBox()),
                        isLocked
                            ? SizedBox(
                                width: 25,
                                height: 25,
                                child:
                                    Image.asset('assets/images/LockSimple.png'),
                              )
                            : const SizedBox()
                      ],
                    ),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            moduleName,
                            style: GoogleFonts.plusJakartaSans(
                              color: ColorResources.colorgrey700,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // Text(
                          //   '28/28 Days',
                          //   style: GoogleFonts.plusJakartaSans(
                          //     color: ColorResources.colorgrey600,
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: GoogleFonts.plusJakartaSans(
            color: ColorResources.colorgrey700,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: ColorResources.colorgrey600,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
