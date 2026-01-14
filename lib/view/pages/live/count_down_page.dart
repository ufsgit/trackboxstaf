import 'package:breffini_staff/controller/live_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/model/save_live_class_model.dart';
import 'package:breffini_staff/view/pages/calls/live_call_screen.dart';
import 'package:breffini_staff/view/pages/live/widgets/count_down_timer.dart';
import 'package:breffini_staff/view/pages/live/widgets/zego_license.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class CountDownPage extends StatefulWidget {
  final String courseName;
  final String batchName;
  final String courseId;
  final String batchId;
  final String slotId;
  final bool isEnd;

  CountDownPage(
      {super.key,
      required this.courseName,
      required this.batchName,
      required this.batchId,
      required this.courseId,
      required this.slotId,
      required this.isEnd});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  // final LiveClassController liveController = Get.put(LiveClassController());
  void _onCountdownComplete() {
    // String liveLink = uuid.v1();
    // await liveController.saveLiveClass(SaveLiveClassTeacher(
    //     slotId: int.parse(slotId),
    //     liveClassId: 0,
    //     courseId: int.parse(courseId),
    //     teacherId: 1,
    //     batchId: int.parse(batchId),
    //     scheduledDateTime: DateTime.now(),
    //     duration: 1,
    //     startTime: DateTime.now(),
    //     liveLink: liveLink));
    Get.off(() => LiveCallScreen(
          liveClassId: "",
          liveLink: '',
          // isEnd: widget.isEnd,
          batchId: widget.batchId,
          courseId: widget.courseId,
          slotId: widget.slotId,
        ));
  }

  @override
  void initState() {
    // getZegoEffectsLicense();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.w),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: CircleAvatar(
                      backgroundColor: ColorResources.colorBlue100,
                      radius: 18.r,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: ColorResources.colorgrey600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Finding Your Candidate",
                    style: GoogleFonts.plusJakartaSans(
                      color: ColorResources.colorgrey700,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Spacer(),
              CountdownTimer(
                duration: 5,
                onCountdownComplete: _onCountdownComplete,
              ),
              const Spacer(),
              Text(
                "Live starts in",
                style: GoogleFonts.plusJakartaSans(
                  color: ColorResources.colorgrey600,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "Course: ${widget.courseName}",
                style: GoogleFonts.plusJakartaSans(
                  color: ColorResources.colorgrey600,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Batch: ${widget.batchName}",
                style: GoogleFonts.plusJakartaSans(
                  color: ColorResources.colorgrey600,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
