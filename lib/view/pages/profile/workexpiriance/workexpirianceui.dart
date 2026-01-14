import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/pages/profile/workexpiriance/addworkexpiriancepage.dart';
import 'package:breffini_staff/view/pages/profile/workexpiriance/workexpiriancemodal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget workExperienceSection({
  required BuildContext context,
  required List<WorkExperience> workExperienceList,
  required Future<void> Function() refresh,
  required Future<void> Function(WorkExperience exp) deleteExperience,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Work Experience",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),

      SizedBox(height: 12.h),

      /// ➕ Add
      InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddWorkExperiencePage(),
            ),
          );

          if (result == true) {
            await refresh();
          }
        },
        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorResources.colorgrey300),
          ),
          child: Row(
            children: const [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text("Add Work Experience"),
            ],
          ),
        ),
      ),

      SizedBox(height: 12.h),

      if (workExperienceList.isEmpty)
        Text(
          "No work experience added",
          style: GoogleFonts.plusJakartaSans(fontSize: 12.sp),
        ),

      ...workExperienceList.map((exp) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorResources.colorwhite,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exp.role,
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700)),
                    Text(exp.company),
                    Text(exp.duration),
                  ],
                ),
              ),
              Row(
                children: [
                  /// ✅ EDIT
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddWorkExperiencePage(experience: exp),
                        ),
                      );

                      if (result == true) {
                        await refresh(); // 🔥 reload backend data
                      }
                    },
                  ),

                  /// ✅ DELETE
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Work Experience"),
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
                        await deleteExperience(exp); // ✅ THIS LINE
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
