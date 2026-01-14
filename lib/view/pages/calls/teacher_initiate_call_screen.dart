// import 'package:breffini_staff/controller/individual_call_controller.dart';
// import 'package:breffini_staff/controller/live_controller.dart';
// import 'package:breffini_staff/controller/profile_controller.dart';
// import 'package:breffini_staff/core/utils/key_center.dart';
// import 'package:breffini_staff/model/save_call_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
//
// class TeacherInitiateCallScreen extends StatefulWidget {
//   final int studentId;
//   final bool video;
//   const TeacherInitiateCallScreen({
//     super.key,
//     required this.studentId,
//     required this.video,
//   });
//
//   @override
//   State<TeacherInitiateCallScreen> createState() =>
//       _TeacherInitiateCallScreenState();
// }
//
// class _TeacherInitiateCallScreenState extends State<TeacherInitiateCallScreen> {
//   var uuid = const Uuid();
//   String uniqId = '';
//   final ProfileController profileNameController = Get.put(ProfileController());
//
//   final LiveClassController liveController = Get.put(LiveClassController());
//   final IndividualCallController controller =
//       Get.put(IndividualCallController());
//   String callId="";
//
//   @override
//   void initState() {
//     super.initState();
//     uniqId = uuid.v1();
//
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//
//       controller.saveStudentCall(SaveStudentCallModel(
//           id: 0,
//           teacherId: 0,
//           studentId: widget.studentId,
//           callStart: DateTime.now(),
//           callEnd: '',
//           callDuration: null,
//           callType: widget.video == true ? 'Video' : 'Audio',
//           isStudentCalled: 0,
//           liveLink: uniqId)).then((value) {
//         callId = value;
//         setState(() {
//
//         });
//       });
//     });
//
//   }
//
//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(
//                 'Exit Call',
//                 style: TextStyle(
//                     fontSize: 16.w,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xff283B52)),
//               ),
//               content: Text(
//                 'Are you sure you want to exit the call?',
//                 style:
//                     TextStyle(fontSize: 15.w, color: const Color(0xff283B52)),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () async {
//                     await controller.stopLive(
//                         studentId: widget.studentId.toString(),
//                         isStudentCalled: false,callId: callId);
//                     Get.back();
//                     Get.back();
//                   },
//                   child: Text(
//                     'Yes',
//                     style: TextStyle(
//                         fontSize: 14.w,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xff283B52)),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   child: Text(
//                     'No',
//                     style: TextStyle(
//                         fontSize: 14.w,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xff283B52)),
//                   ),
//                 ),
//               ],
//             );
//           },
//         )) ??
//         false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: Obx(
//           () => SafeArea(
//             child: ZegoUIKitPrebuiltCall(
//               onDispose: () async {
//                 await controller.stopLive(
//                     isStudentCalled: false,
//                     studentId: widget.studentId.toString(),
//                 callId: callId);
//                 // Get.back();
//               },
//               appID: ZegoUtils.appID,
//               appSign: ZegoUtils.appSign,
//               userID: profileNameController.getTeacher[0].userId.toString(),
//               userName: profileNameController.getTeacher[0].firstName,
//               callID: uniqId,
//               config: widget.video == true
//                   ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//                   : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
//                 ..duration = ZegoCallDurationConfig(isVisible: false)
//                 ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
//                   style: ZegoCallMenuBarStyle.dark,
//                   height: 64.h,
//                   buttons: [
//                     ZegoCallMenuBarButtonName.toggleMicrophoneButton,
//                     ZegoCallMenuBarButtonName.hangUpButton,
//                     ZegoCallMenuBarButtonName.switchAudioOutputButton,
//                     if (widget.video)
//                       ZegoCallMenuBarButtonName.toggleCameraButton,
//                     if (widget.video)
//                       ZegoCallMenuBarButtonName.switchCameraButton,
//                   ],
//                   margin:
//                       EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//                   backgroundColor: Colors.grey.withOpacity(.5),
//                 )
//                 ..audioVideoView = ZegoCallAudioVideoViewConfig(
//                   useVideoViewAspectFill: true,
//                 ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
