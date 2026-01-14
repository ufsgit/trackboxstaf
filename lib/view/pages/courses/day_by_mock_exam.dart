// import 'package:breffini_staff/controller/course_enrol_controller.dart';
// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class DayByMockExamScreen extends StatefulWidget {
//   final String courseId;
//   final String moduleId;
//   final String appBarTitle;
//   int? isEnrollCourse;
//   DayByMockExamScreen({
//     super.key,
//     required this.courseId,
//     required this.moduleId,
//     required this.appBarTitle,
//     this.isEnrollCourse,
//   });

//   @override
//   State<DayByMockExamScreen> createState() => _DayByMockExamScreenState();
// }

// class _DayByMockExamScreenState extends State<DayByMockExamScreen> {
//   final CourseEnrolController enrolController = Get.find();
//   @override
//   void initState() {
//     enrolController.getExamWithDays(widget.courseId, widget.moduleId!);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(60),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Container(
//                       height: 24,
//                       width: 24,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(50),
//                         color: ColorResources.colorBlue100,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Icon(
//                           Icons.arrow_back_ios,
//                           color: ColorResources.colorBlack.withOpacity(.4),
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     widget.appBarTitle,
//                     style: GoogleFonts.plusJakartaSans(
//                       color: ColorResources.colorBlack,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: GridViewMockExamWidget(
//                 examDays: enrolController.examDayList,
//                 onDayTapped: (day) {
//                   Get.to(() => DayCategoryScreen(
//                       IsEnrollCourse: widget.isEnrollCourse,
//                       isTab: false,
//                       isExam: true,
//                       isLibrary: false,
//                       dayId: day.daysId.toString(),
//                       courseId: widget.courseId,
//                       moduleId: widget.moduleId!,
//                       appBarTitle:
//                           '${widget.appBarTitle} - Test ${day.daysId}'));
//                 },
//               ))),
//     );
//   }
// }
