// import 'dart:developer';
//
// import 'package:breffini_staff/view/pages/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
// import '../../../../controller/live_controller.dart';
// import '../../../../core/theme/color_resources.dart';
//
// // ignore: must_be_immutable
// class BottomBarWidget extends StatefulWidget {
//   BottomBarWidget(
//       {super.key,
//       required this.videoCallCtrl,
//       required this.callID,
//       this.localViewID,
//       this.localView,
//       required this.isIndividual,
//       required this.logout});
//   Widget? localView;
//   int? localViewID;
//   final String callID;
//   final bool isIndividual;
//   final Future<ZegoRoomLogoutResult> Function() logout;
//   final LiveClassController videoCallCtrl;
//
//   @override
//   State<BottomBarWidget> createState() => _BottomBarWidgetState();
// }
//
// class _BottomBarWidgetState extends State<BottomBarWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//         bottom: widget.isIndividual ? 30 : 08,
//         left: widget.videoCallCtrl.userCount.value >= 1 ? 40 : 70,
//         right: widget.videoCallCtrl.userCount.value >= 1 ? 40 : 70,
//         child: Obx(
//           () => Container(
//             padding: const EdgeInsets.symmetric(horizontal: 05, vertical: 05),
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white),
//                 borderRadius: BorderRadius.circular(28),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.black26, blurRadius: 10),
//                 ],
//                 color:
//                     widget.isIndividual ? Colors.white : Colors.grey.shade600),
//             height: widget.isIndividual ? 157 : 64,
//             child: widget.isIndividual
//                 ? Column(
//                     children: [
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           // mainAxisSize: MainAxisSize.min,
//                           children: [
//                             GestureDetector(
//                               onTap: () {},
//                               child: Container(
//                                 padding: const EdgeInsets.all(15),
//                                 height: 56,
//                                 width: 56,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   // borderRadius: BorderRadius.circular(24),
//                                   color: Colors.white,
//                                   border: Border.all(color: Colors.black26),
//                                 ),
//                                 child: SvgPicture.asset(
//                                     "assets/images/Vector.svg"),
//                               ),
//                             ),
//                             // if (widget.videoCallCtrl.userCount.value > 1)
//                             GestureDetector(
//                               onTap: () {
//                                 if (widget.videoCallCtrl.isAudioEnabled.value ==
//                                     true) {
//                                   widget.videoCallCtrl
//                                       .turnMicrophoneOn(false, context);
//                                 } else {
//                                   widget.videoCallCtrl
//                                       .turnMicrophoneOn(true, context);
//                                 }
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(15),
//                                 height: 56,
//                                 width: 56,
//                                 decoration: BoxDecoration(
//                                     // borderRadius: BorderRadius.circular(24),
//                                     shape: BoxShape.circle,
//                                     border: Border.all(color: Colors.black26),
//                                     color: widget
//                                             .videoCallCtrl.isAudioEnabled.value
//                                         ? Colors.white
//                                         : Colors.grey.shade800),
//                                 child: SvgPicture.asset(
//                                     "assets/images/MicrophoneSlash.svg",
//                                     color: widget
//                                             .videoCallCtrl.isAudioEnabled.value
//                                         ? Colors.blue
//                                         : Colors.white),
//                               ),
//                             ),
//                             // GestureDetector(
//                             //   onTap: () {
//                             //     if (widget.videoCallCtrl.isVideoEnabled.value) {
//                             //       widget.videoCallCtrl
//                             //           .turnCameraOn(false, context);
//                             //     } else {
//                             //       widget.videoCallCtrl
//                             //           .turnCameraOn(true, context);
//                             //     }
//                             //   },
//                             //   child: Container(
//                             //     padding: const EdgeInsets.symmetric(
//                             //         horizontal: 15, vertical: 15),
//                             //     decoration: BoxDecoration(
//                             //         // borderRadius: BorderRadius.circular(24),
//                             //         border: Border.all(color: Colors.black26),
//                             //         shape: BoxShape.circle,
//                             //         color: widget
//                             //                 .videoCallCtrl.isVideoEnabled.value
//                             //             ? Colors.grey.shade800
//                             //             : Colors.white),
//                             //     child: SvgPicture.asset(
//                             //       "assets/images/VideoCameraSlash.svg",
//                             //       color:
//                             //           widget.videoCallCtrl.isVideoEnabled.value
//                             //               ? Colors.white
//                             //               : Colors.blue,
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () async {
//                             Get.back();
//                             stopListenEvent();
//                             logoutRoom();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(24),
//                                 color: ColorResources.colorLeaveButton),
//                             child: Center(
//                               child: SvgPicture.asset(
//                                   'assets/images/phone_hang_up.svg'),
//                               // child: Text(
//                               //   "Leave",
//                               //   style: GoogleFonts.plusJakartaSans(
//                               //       color: ColorResources.colorwhite,
//                               //       fontSize: 12,
//                               //       fontWeight: FontWeight.w600),
//                               // ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if (widget.videoCallCtrl.isAudioEnabled.value ==
//                               true) {
//                             widget.videoCallCtrl
//                                 .turnMicrophoneOn(false, context);
//                           } else {
//                             widget.videoCallCtrl
//                                 .turnMicrophoneOn(true, context);
//                           }
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(15),
//                           height: 56,
//                           width: 56,
//                           decoration: BoxDecoration(
//                               // borderRadius: BorderRadius.circular(24),
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.black26),
//                               color: widget.videoCallCtrl.isAudioEnabled.value
//                                   ? Colors.grey.shade800
//                                   : Colors.white),
//                           child: SvgPicture.asset(
//                               "assets/images/MicrophoneSlash.svg",
//                               color: widget.videoCallCtrl.isAudioEnabled.value
//                                   ? Colors.white
//                                   : Colors.blue),
//                         ),
//                       ),
//                       if (widget.videoCallCtrl.userCount.value > 1)
//                         GestureDetector(
//                           onTap: () {
//                             if (widget.videoCallCtrl.isAudioEnabled.value ==
//                                 true) {
//                               widget.videoCallCtrl
//                                   .turnMicrophoneOn(false, context);
//                             } else {
//                               widget.videoCallCtrl
//                                   .turnMicrophoneOn(true, context);
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height: 56,
//                             width: 56,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(24),
//                                 color: widget.videoCallCtrl.isAudioEnabled.value
//                                     ? Colors.grey.shade800
//                                     : Colors.white),
//                             child: SvgPicture.asset(
//                                 "assets/images/MicrophoneSlash.svg",
//                                 color: widget.videoCallCtrl.isAudioEnabled.value
//                                     ? Colors.white
//                                     : Colors.blue),
//                           ),
//                         ),
//                       GestureDetector(
//                         onTap: () {
//                           if (widget.videoCallCtrl.isVideoEnabled.value) {
//                             widget.videoCallCtrl.turnCameraOn(false, context);
//                           } else {
//                             widget.videoCallCtrl.turnCameraOn(true, context);
//                           }
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 15),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(24),
//                               color: widget.videoCallCtrl.isVideoEnabled.value
//                                   ? Colors.grey.shade800
//                                   : Colors.white),
//                           child: SvgPicture.asset(
//                             "assets/images/VideoCameraSlash.svg",
//                             color: widget.videoCallCtrl.isVideoEnabled.value
//                                 ? Colors.white
//                                 : Colors.blue,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {},
//                         child: Container(
//                           padding: const EdgeInsets.all(15),
//                           height: 56,
//                           width: 56,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(24),
//                               color: Colors.grey.shade800),
//                           child:
//                               SvgPicture.asset("assets/images/UsersThree.svg"),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           Get.off(() => const HomePage(
//                                 initialIndex: 3,
//                               ));
//                           stopListenEvent();
//                           await logoutRoom();
//                           widget.videoCallCtrl.isVideoEnabled.value = false;
//                         },
//                         child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(24),
//                                 color: ColorResources.colorLeaveButton),
//                             child: Center(
//                                 child: Text(
//                               "Leave",
//                               style: GoogleFonts.plusJakartaSans(
//                                   color: ColorResources.colorwhite,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600),
//                             ))),
//                       ),
//                     ],
//                   ),
//           ),
//         ));
//   }
//
//   Future<ZegoRoomLogoutResult> logoutRoom() async {
//     widget.videoCallCtrl.timer!.cancel();
//     widget.videoCallCtrl.disconnectUser();
//     widget.videoCallCtrl.stopLive();
//     stopPreview();
//     stopPublish();
//     log('<<<<<<<<<<<<<<<<<<<<<<<Logged Out>>>>>>>>>>>>>>>>>>>>>>>');
//     return ZegoExpressEngine.instance.logoutRoom(widget.callID);
//   }
//
//   Future<void> stopPublish() async {
//     return ZegoExpressEngine.instance.stopPublishingStream();
//   }
//
//   Future<void> stopPreview() async {
//     ZegoExpressEngine.instance.stopPreview();
//     log('<<<<<<<<<<1>>>>>>>>>>');
//     log('<<<<<<${widget.localViewID}>>>>>>');
//
//     if (widget.localViewID != null) {
//       log('<<<<<<<<<<2>>>>>>>>>>');
//       await ZegoExpressEngine.instance.destroyCanvasView(widget.localViewID!);
//       if (mounted) {
//         log('<<<<<<<<<<3>>>>>>>>>>');
//         setState(() {
//           widget.localViewID = null;
//           widget.localView = null;
//         });
//       }
//     }
//   }
//
//   void stopListenEvent() {
//     ZegoExpressEngine.onRoomUserUpdate = null;
//     ZegoExpressEngine.onRoomStreamUpdate = null;
//     ZegoExpressEngine.onRoomStateUpdate = null;
//     ZegoExpressEngine.onPublisherStateUpdate = null;
//     ZegoExpressEngine.onRemoteCameraStateUpdate = null;
//     ZegoExpressEngine.onRoomOnlineUserCountUpdate = null;
//     ZegoExpressEngine.onRemoteMicStateUpdate = null;
//     ZegoExpressEngine.onRemoteCameraStateUpdate = null;
//   }
// }
