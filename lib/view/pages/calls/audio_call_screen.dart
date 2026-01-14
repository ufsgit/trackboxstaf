// import 'dart:developer';
//
// import 'package:breffini_staff/controller/live_controller.dart';
// import 'package:breffini_staff/controller/ongoing_call_controller.dart';
// import 'package:breffini_staff/controller/profile_controller.dart';
// import 'package:breffini_staff/core/utils/key_center.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
//
// class AudioScreen extends StatefulWidget {
//   final String liveLink;
//   final String callId;
//   final String studentId;
//   const AudioScreen({super.key, required this.liveLink, required this.callId,required this.studentId});
//
//   @override
//   State<AudioScreen> createState() => _AudioScreenState();
// }
//
// class _AudioScreenState extends State<AudioScreen> {
//   var uuid = const Uuid();
//   String uniqId = '';
//   final ProfileController profileNameController = Get.put(ProfileController());
//
//   final LiveClassController liveController = Get.put(LiveClassController());
//
//   // final CallOngoingController onGoingController =
//   //     Get.put(CallOngoingController());
//   final CallOngoingController onGoingController =
//       Get.find<CallOngoingController>();
//   @override
//   void initState() {
//     uniqId = uuid.v1();
//
//     // liveController.saveLiveClass(SaveLiveClassTeacher(
//     //     liveClassId: 0,
//     //     courseId: int.parse(
//     //       widget.courseId,
//     //     ),
//     //     teacherId: 1,
//     //     batchId: int.parse(
//     //       widget.batchId,
//     //     ),
//     //     scheduledDateTime: DateTime.now(),
//     //     duration: 1,
//     //     startTime: DateTime.now(),
//     //     liveLink: uniqId));
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('$uniqId'),
//       //   centerTitle: true,
//       // ),
//       body: Obx(() => SafeArea(
//             child: ZegoUIKitPrebuiltCall(
//               events: ZegoUIKitPrebuiltCallEvents(
//                 onCallEnd: (event, defaultAction) async {
//                   await liveController.stopVideoCall(widget.studentId,widget.callId);
//                   // log('/////////started');
//                   // await onGoingController.getOngoingCalls();
//                   // log('///////////////worked');
//                   Get.back();
//                 },
//               ),
//               appID: ZegoUtils.appID,
//               appSign: ZegoUtils.appSign,
//               userID: profileNameController.getTeacher[0].userId.toString(),
//               userName: profileNameController.getTeacher[0].firstName,
//               callID: widget.liveLink,
//               config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
//                 ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   hideAutomatically: false,
//                   // hideByClick: false,
//                   height: 64.h,
//                   margin:
//                       EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//                   backgroundColor: Colors.grey.withOpacity(.5),
//                   buttons: [
//                     ZegoCallMenuBarButtonName.toggleMicrophoneButton,
//                     ZegoCallMenuBarButtonName.hangUpButton,
//                     ZegoCallMenuBarButtonName.switchAudioOutputButton,
//                   ],
//                 )
//                 ..audioVideoView = ZegoCallAudioVideoViewConfig(
//                   useVideoViewAspectFill: true,
//                 ),
//             ),
//           )),
//     );
//   }
// }
