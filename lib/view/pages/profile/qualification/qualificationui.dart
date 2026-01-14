import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/pages/profile/qualification/addqualificationpage.dart';
import 'package:breffini_staff/view/pages/profile/qualification/qualificationmodal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget qualificationSection({
  required BuildContext context,
  required List<Qualification> qualificationList,
  required Future<void> Function() refresh,
  required Future<void> Function(Qualification q) onDelete,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Title
      Text(
        "Qualification",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),

      SizedBox(height: 12.h),

      /// ➕ Add Qualification
      InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddQualificationPage(),
            ),
          );

          if (result == true) {
            await refresh(); // 🔥 reload from backend
          }
        },
        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorResources.colorgrey300),
          ),
          child: Row(
            children: [
              Icon(Icons.add, color: ColorResources.colorgrey700),
              SizedBox(width: 8.w),
              Text(
                "Add Qualification",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(height: 12.h),

      /// EMPTY STATE
      if (qualificationList.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text(
            "No qualification added",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: ColorResources.colorgrey500,
            ),
          ),
        ),

      /// LIST
      ...qualificationList.asMap().entries.map((entry) {
        final index = entry.key;
        final q = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorResources.colorwhite,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.degree,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      q.institute,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        color: ColorResources.colorgrey600,
                      ),
                    ),
                    Text(
                      q.year,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        color: ColorResources.colorgrey500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddQualificationPage(qualification: q),
                        ),
                      );

                      if (result == true) {
                        await refresh();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Qualification"),
                          content: const Text("Are you sure?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await onDelete(q); // 🔥 delegate to parent
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    ],
  );
}
