import 'package:breffini_staff/controller/course_enrol_controller.dart';
import 'package:breffini_staff/controller/course_module_controler.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/pages/chats/widgets/loading_circle.dart';
import 'package:breffini_staff/view/pages/courses/course_content_by_category_screen.dart';
import 'package:breffini_staff/view/pages/courses/course_recording_screen.dart';
import 'package:breffini_staff/view/pages/courses/mock_test_module.dart';
import 'package:breffini_staff/view/pages/courses/widgets/grid_view_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class DayCategoryScreen extends StatefulWidget {
  final String courseId;
  final String moduleId;
  final String dayId;
  final String appBarTitle;
  final bool isFromBatch;
  final bool isLibrary;
  final bool isTab;
  final String? batchId;
  const DayCategoryScreen(
      {super.key,
      required this.courseId,
      required this.moduleId,
      required this.appBarTitle,
      required this.dayId,
      required this.isFromBatch,
      this.batchId,
      required this.isTab,
      required this.isLibrary});

  @override
  State<DayCategoryScreen> createState() => _DayCategoryScreenState();
}

class _DayCategoryScreenState extends State<DayCategoryScreen> {
  final CourseEnrolController enrolController = Get.find();

  final CourseModuleController controller = Get.find();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().scheduleFrameCallback(
      (timeStamp) {
        controller.getSectionByCourse(courseId: widget.courseId);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFFF4F7FA),
          appBar: PreferredSize(
            preferredSize: widget.isTab
                ? const Size.fromHeight(0)
                : const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.isTab == false)
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ColorResources.colorBlue100,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: ColorResources.colorBlack.withOpacity(.4),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    widget.appBarTitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: ColorResources.colorBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Obx(
            () =>
                //  controller.isSectionLoading.value
                //     ? widget.isTab
                //         ? const Column(
                //             children: [
                //               SizedBox(
                //                 height: 100,
                //               ),
                //               LoadingCircle()
                //             ],
                //           )
                //         : const Center(
                //             child: LoadingCircle(),
                //           )
                //     :
                controller.sectionByModule.isEmpty
                    ? const Center(
                        child: Text('No Library Contents to show'),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GridviewCategoryWidget(
                          sectionByCourse: controller.sectionByModule,
                          onDayTapped: (day) {
                            Get.to(() => CourseDetailsPage1Screen(
                                  isFromBatch: widget.isFromBatch,
                                  isLibrary: widget.isLibrary,
                                  batchId: widget.batchId ?? '',
                                  appBarTitle: day.sectionName,
                                  courseId: widget.courseId,
                                  moduleId: widget.moduleId,
                                  sectionId: day.sectionId.toString(),
                                  dayId: widget.dayId,
                                ));
                          },
                          isTab: widget.isTab,
                          onRecordingTapped: () {
                            Get.to(() => CourseRecordingsScreen(
                                courseId: widget.courseId.toString()));
                          },
                        )),
          )),
    );
  }
}
