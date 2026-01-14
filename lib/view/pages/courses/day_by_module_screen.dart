import 'package:breffini_staff/controller/course_enrol_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/pages/chats/widgets/loading_circle.dart';
import 'package:breffini_staff/view/pages/courses/day_category_screen.dart';
import 'package:breffini_staff/view/pages/courses/widgets/grid_view_day_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class DayByModuleScreen extends StatefulWidget {
  final String courseId;
  final String moduleId;
  final bool isFromBatch;
  final bool isLibrary;
  final String? batchId;
  final String appBarTitle;
  DayByModuleScreen({
    super.key,
    required this.courseId,
    required this.moduleId,
    required this.appBarTitle,
    required this.isFromBatch,
    this.batchId,
    required this.isLibrary,
  });

  @override
  State<DayByModuleScreen> createState() => _DayByModuleScreenState();
}

class _DayByModuleScreenState extends State<DayByModuleScreen> {
  final CourseEnrolController enrolController = Get.find();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().scheduleFrameCallback(
      (timeStamp) {
        enrolController.getBatchWithDays(widget.courseId, widget.moduleId);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFF4F7FA),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
            () => enrolController.isLoading.value
                ? const Center(
                    child: LoadingCircle(),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GridViewDayWidget(
                      batchDays: enrolController.batchDaysList,
                      onDayTapped: (day) {
                        Get.to(() => DayCategoryScreen(
                            isTab: false,
                            isLibrary: widget.isLibrary,
                            isFromBatch: widget.isFromBatch,
                            batchId: widget.batchId,
                            dayId: day.daysId.toString(),
                            courseId: widget.courseId,
                            moduleId: widget.moduleId,
                            appBarTitle:
                                '${widget.appBarTitle}-${day.dayName}'));
                      },
                    )),
          )),
    );
  }
}
