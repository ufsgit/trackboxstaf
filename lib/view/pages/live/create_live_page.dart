// import 'package:breffini_staff/controller/profile_controller.dart';
// import 'package:breffini_staff/controller/teacher_course_controller.dart';
// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:breffini_staff/core/widgets/common_widgets.dart';
// import 'package:breffini_staff/model/teacher_course_model.dart';
// import 'package:breffini_staff/view/pages/live/count_down_page.dart';
// import 'package:breffini_staff/view/widgets/common_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CreateLivePage extends StatefulWidget {
//   const CreateLivePage({super.key});

//   @override
//   State<CreateLivePage> createState() => _CreateLivePageState();
// }

// class _CreateLivePageState extends State<CreateLivePage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   TextEditingController timeController = TextEditingController();
//   final TeacherCourseController teacherCourseController =
//       Get.put(TeacherCourseController());

//   bool isSwitched = false;
//   TeacherCourseModel? selectedCourse;
//   TeacherCourseModel? selectedBatch;

//   @override
//   void initState() {
//     teacherCourseController.getTeacherCourse();
//     profileController.fetchTeacherProfile();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorResources.colorgrey200,
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Create Live",
//                   style: GoogleFonts.plusJakartaSans(
//                     color: ColorResources.colorgrey700,
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Text(
//                   "General Details",
//                   style: GoogleFonts.plusJakartaSans(
//                     color: ColorResources.colorgrey500,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 commonTextFieldWidget(
//                   controller: nameController,
//                   labelText: 'Live Name',
//                   onChanged: (value) {
//                     setState(() {});
//                   },
//                 ),
//                 SizedBox(height: 10.h),
//                 Obx(
//                   () => dropdownButtonFormFieldWidget(
//                     labelText: 'Course Name',
//                     items: teacherCourseController.teacherCourse.map((course) {
//                       return DropdownMenuItem<TeacherCourseModel>(
//                         value: course,
//                         child: Text(course.courseName),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedCourse = value;
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Obx(
//                   () => dropdownButtonFormFieldWidget(
//                     labelText: 'Batch Name',
//                     items: teacherCourseController.teacherCourse.map((course) {
//                       return DropdownMenuItem<TeacherCourseModel>(
//                         value: course,
//                         child: Text(course.batchName),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedBatch = value;
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Schedule Later",
//                       style: GoogleFonts.plusJakartaSans(
//                         color: ColorResources.colorgrey500,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Transform.scale(
//                       scale: .60,
//                       child: Switch(
//                         trackOutlineColor: const MaterialStatePropertyAll(
//                             ColorResources.colorwhite),
//                         thumbIcon: MaterialStateProperty.all(const Icon(
//                           Icons.circle,
//                           color: ColorResources.colorwhite,
//                         )),
//                         activeTrackColor: ColorResources.switchButtonColor,
//                         inactiveTrackColor: ColorResources.colorgrey400,
//                         inactiveThumbColor: ColorResources.colorwhite,
//                         value: isSwitched,
//                         onChanged: (value) {
//                           setState(() {
//                             isSwitched = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 if (isSwitched)
//                   Column(
//                     children: [
//                       datePickerWidget(
//                         controller: dobController,
//                         labelText: 'Date',
//                         onTap: () {
//                           setState(() {
//                             selectDate(context, dobController);
//                           });
//                         },
//                       ),
//                       SizedBox(height: 10.h),
//                       timeAndDurationTextFieldWidget(
//                         controller: timeController,
//                         onTap: () {
//                           setState(() {
//                             selectTime(context, timeController);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.w),
//           child: buttonWidget(
//             backgroundColor: nameController.text.isEmpty
//                 ? ColorResources.colorgrey400
//                 : ColorResources.colorBlue600,
//             txtColor: nameController.text.isEmpty
//                 ? ColorResources.colorgrey600
//                 : ColorResources.colorwhite,
//             context: context,
//             text: isSwitched ? 'Schedule for Later' : 'Go Live',
//             onPressed: () async {
//               if (selectedCourse != null && selectedBatch != null) {
//                 Get.to(() => CountDownPage(
//                       courseId: selectedCourse!.courseId.toString(),
//                       courseName: selectedCourse!.courseName,
//                       batchId: selectedBatch!.batchId.toString(),
//                       batchName: selectedBatch!.batchName,
//                     ));
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget dropdownButtonFormFieldWidget({
//     required String labelText,
//     required List<DropdownMenuItem<TeacherCourseModel>>? items,
//     required void Function(TeacherCourseModel?)? onChanged,
//   }) {
//     return SizedBox(
//       height: 54.h,
//       child: DropdownButtonFormField(
//         onChanged: onChanged,
//         items: items,
//         style: GoogleFonts.plusJakartaSans(
//           color: ColorResources.colorBlue800,
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w600,
//         ),
//         decoration: InputDecoration(
//           labelText: labelText,
//           labelStyle: GoogleFonts.plusJakartaSans(
//             color: ColorResources.colorgrey600,
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w400,
//           ),
//           contentPadding:
//               EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
//           fillColor: ColorResources.colorwhite,
//           filled: true,
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.w),
//             borderSide: const BorderSide(color: ColorResources.colorBlack),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.w),
//             borderSide: const BorderSide(color: ColorResources.colorgrey300),
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.w),
//             borderSide: const BorderSide(color: ColorResources.colorgrey200),
//           ),
//         ),
//       ),
//     );
//   }
// }
