// import 'package:breffini_staff/controller/calls_page_controller.dart';
// import 'package:breffini_staff/controller/individual_call_controller.dart';
// import 'package:breffini_staff/controller/live_controller.dart';
// import 'package:breffini_staff/controller/ongoing_call_controller.dart';
// import 'package:breffini_staff/controller/profile_controller.dart';
// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:breffini_staff/core/utils/common_utils.dart';
// import 'package:breffini_staff/core/utils/extentions.dart';
// import 'package:breffini_staff/core/utils/firebase_utils.dart';
// import 'package:breffini_staff/core/utils/key_center.dart';
// import 'package:breffini_staff/core/utils/pref_utils.dart';
// import 'package:breffini_staff/http/chat_socket.dart';
// import 'package:breffini_staff/http/http_urls.dart';
// import 'package:breffini_staff/main.dart';
// import 'package:breffini_staff/model/current_call_model.dart';
// import 'package:breffini_staff/model/save_call_model.dart';
// import 'package:breffini_staff/model/student_call_model.dart';
// import 'package:breffini_staff/view/pages/home_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart' as scheduler;
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class IncomingCallPage extends StatefulWidget {
//   String liveLink;
//   String callId;
//   String studentId;
//   String profileImageUrl;
//   String studentName;
//   bool video;
//   IncomingCallPage({
//     super.key,
//     required this.liveLink,
//     required this.callId,
//     required this.studentId,
//     required this.video,
//     required this.profileImageUrl,
//     required this.studentName,
//   });

//   @override
//   State<IncomingCallPage> createState() => _IncomingCallPageState();
// }

// class _IncomingCallPageState extends State<IncomingCallPage>
//     with SingleTickerProviderStateMixin {
//   final ProfileController profileNameController = Get.put(ProfileController());

//   // CallOngoingController callOngoingController = Get.find();
//   // final IndividualCallController callController =
//   // Get.put(IndividualCallController());
//   final CallOngoingController onGoingController =
//       Get.put(CallOngoingController());
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final CallandChatController callandChatController =
//       Get.put(CallandChatController());

//   final IndividualCallController controller =
//       Get.put(IndividualCallController());
//   var uuid = const Uuid();

//   // AnimationController? animationController;
//   // late Animation<double> _animation;
//   String busyMessage = "";

//   @override
//   void initState() {
//     super.initState();
//     // animationController = AnimationController(
//     //   vsync: this,
//     //   duration: const Duration(milliseconds: 800),
//     // )..repeat(); // Repeat animation indefinitely
//     //
//     // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//     //   parent: animationController!,
//     //   curve: Curves.easeInOut,
//     // ));

//     if (!widget.profileImageUrl.isNullOrEmpty() &&
//         !widget.profileImageUrl.startsWith("http")) {
//       //setting base url when empty path
//       widget.profileImageUrl = HttpUrls.imgBaseUrl + widget.profileImageUrl;
//     }
//     scheduler.SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await FlutterCallkitIncoming.endCall(widget.callId);

//       if (widget.callId.isNullOrEmpty()) {
//         widget.liveLink = uuid.v1();
//         setState(() {});
//         // if(await checkUserAvailability()) {
//         // await setupCall(PrefUtils().getTeacherId(),widget.studentId,widget.video?"Video":
//         // "Voice",widget.studentName);

//         SaveStudentCallModel callModel = SaveStudentCallModel(
//             id: 0,
//             teacherId: 0,
//             studentId: int.parse(widget.studentId),
//             studentName: (widget.studentName),
//             callStart: DateTime.now(),
//             callEnd: '',
//             callDuration: null,
//             callType: widget.video ? 'Video' : 'Audio',
//             isStudentCalled: 0,
//             liveLink: widget.liveLink,
//             profileUrl: PrefUtils().getProfileUrl());
//         controller.saveStudentCall(callModel).then((value) async {
//           if (!value.isNullOrEmpty()) {
//             widget.callId = value;

//             FirebaseUtils.checkForRecentCallWithSameStudent(
//                     widget.studentId.toString())
//                 .then((value) async {
//               if (value) {
//                 await ZegoUIKitPrebuiltCallController().hangUp(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                       content: Text(
//                           "Cant place new call. While you are in another call")),
//                 );
//                 controller.updateCallStatusFailed(widget.callId);
//                 if (Get.currentRoute == "/IncomingCallPage") {
//                   safeBack();
//                 }
//               } else {
//                 if (Get.currentRoute == "/IncomingCallPage") {
//                   await FirebaseUtils.saveCall(
//                       [widget.studentId],
//                       [widget.studentName],
//                       widget.callId,
//                       "",
//                       widget.video ? 'Video' : 'Audio',
//                       widget.liveLink,
//                       PrefUtils().getProfileUrl(),
//                       "new_call");
//                   FirebaseUtils.listeningToCurrentCall(
//                       widget.studentId, widget.callId);
//                 }

//                 callandChatController.currentCallModel.value = CurrentCallModel(
//                     callerId: widget.studentId,
//                     callId: (widget.callId),
//                     callerName: widget.studentName,
//                     isVideo: widget.video,
//                     profileImg: widget.profileImageUrl,
//                     liveLink: widget.liveLink,
//                     studentIds: [widget.studentId],
//                     type: "new_call");
//                 // callandChatController.currentCallId.value = int.parse(widget.callId);
//                 // callandChatController.currentCallerName.value = widget.studentName;
//                 // callandChatController.currentCallerId.value = widget.studentId;
//               }
//             });
//           }
//         });
//         // }
//       } else {
//         FirebaseUtils.checkIfCallExists(widget.studentId, widget.callId)
//             .then((value) async {
//           if (!value) {
//             callandChatController.currentCallModel.value = CurrentCallModel();
//             await ZegoUIKitPrebuiltCallController().hangUp(context);
//             callandChatController.disconnectCall(
//                 true, false, widget.studentId, widget.callId);

//             if (Get.currentRoute == "/IncomingCallPage") {
//               safeBack();
//             }
//           } else {
//             FirebaseUtils.listeningToCurrentCall(
//                 widget.studentId, widget.callId);

//             FirebaseUtils.updateCallStatus(
//                 widget.studentId.toString(), FirebaseUtils.callAccepted);
//             controller.updateCallStatusAccept(widget.callId);

//             callandChatController.currentCallModel.value = CurrentCallModel(
//                 callerId: widget.studentId,
//                 callId: (widget.callId),
//                 callerName: widget.studentName,
//                 isVideo: widget.video,
//                 profileImg: widget.profileImageUrl,
//                 liveLink: widget.liveLink,
//                 studentIds: [widget.studentId],
//                 type: "new_call");
//           }
//         });

//         // callandChatController.currentCallId.value = int.parse(widget.callId);
//         // callandChatController.currentCallerName.value = widget.studentName;
//         // callandChatController.currentCallerId.value = widget.studentId;
//       }
//       setState(() {});
//     });
//     // callandChatController.initNotification(
//     //     widget.liveLink,
//     //     widget.studentId,
//     //     widget.callId,
//     //     widget.video,
//     //     widget.profileImageUrl,
//     //     widget.studentName);
//   }

//   setupCall(userNum, friendNum, msg, _contactName) async {
//     await FirebaseFirestore.instance.collection('calls').doc("8").set({
//       "callerId": userNum,
//       "callreceiverId": friendNum,
//       "message": msg,
//       "type": "text",
//       "date": DateTime.now(),
//     });
//     // .then((value) {
//     //   FirebaseFirestore.instance
//     //       .collection('o2ocalls')
//     //       .doc(userNum)
//     //       .collection('records')
//     //       .doc(friendNum)
//     //       .set({
//     //     'present_call': msg,
//     //     'timestamp': FieldValue.serverTimestamp(),
//     //   });
//     // }).then((value) {
//     //   FirebaseFirestore.instance.collection('o2ocalls').doc(friendNum).set({
//     //     'caller': userNum,
//     //     'present_call': msg,
//     //     'timestamp': FieldValue.serverTimestamp(),
//     //   });
//     // });
//     //
//     // await FirebaseFirestore.instance
//     //     .collection('o2ocalls')
//     //     .doc(friendNum)
//     //     .collection('records')
//     //     .doc(userNum)
//     //     .collection("log")
//     //     .add({
//     //   "callerId": userNum,
//     //   "callreceiverId": friendNum,
//     //   "message": msg,
//     //   "type": "text",
//     //   "date": DateTime.now(),
//     // }).then((value) {
//     //   FirebaseFirestore.instance
//     //       .collection('o2ocalls')
//     //       .doc(friendNum)
//     //       .collection('records')
//     //       .doc(userNum)
//     //       .set({
//     //     "present_call": msg,
//     //     'timestamp': FieldValue.serverTimestamp(),
//     //   });
//     // });
//     // try {
//     //   // DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
//     //   //     .collection('users')
//     //   //     .doc(friendNum)
//     //   //     .get();
//     //   //
//     //   // if (friendSnapshot.exists) {
//     //   //   Map<String, dynamic>? friendData =
//     //   //   friendSnapshot.data() as Map<String, dynamic>?;
//     //   //
//     //   //   if (friendData != null && friendData.containsKey('Token')) {
//     //   //     String? friendToken = friendData['Token'];
//     //   //     print('Friend Token: $friendToken');
//     //   //     // sendPushNotification(
//     //   //     //     friendToken!, _contactName!, "incoming $msg call...");
//     //   //   } else {
//     //   //     print('Token field not found in friend document or value is null');
//     //   //   }
//     //   // } else {
//     //   //   print('Friend document does not exist');
//     //   // }
//     // } catch (e) {
//     //   print('Error retrieving friend token: $e');
//     // }
//   }

//   @override
//   void dispose() {
//     // if (null != animationController && animationController!.isDismissed) {
//     //   animationController?.dispose();
//     // }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             child: PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (bool didPop, callBack) async {
//         if (didPop) {
//         } else {
//           if (!ZegoUIKitPrebuiltCallController().minimize.minimize(
//                 context,
//                 rootNavigator: true,
//               )) {
//             safeBack(canPop: false);
//             // return;
//           }
//         }

//         /// not support end by return button
//       },
//       child: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           ZegoUIKitPrebuiltCall(
//             onDispose: () {
//               print("efresdfr");
//             },
//             // events: ZegoUIKitPrebuiltCallEvents(
//             //   onCallEnd: (event, defaultAction) async {
//             //     log("Live stop Id///////${widget.liveLink}");
//             //     await liveController.stopVideoCall(widget.callId,widget.studentId);-
//             //     // // await callController.stopLive();
//             //     // log('/////////started');
//             //     // await onGoingController.getOngoingCalls();
//             //     // log('///////////////worked');
//             //     Get.back();
//             //   },
//             // ),
//             appID: ZegoUtils.appID,
//             appSign: ZegoUtils.appSign,
//             userID: PrefUtils().getTeacherId(),
//             userName: PrefUtils().getTeacherName(),
//             callID: widget.liveLink,
//             config: widget.video
//                 ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//                 : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//               ..topMenuBar.isVisible = true
//               ..topMenuBar = ZegoCallTopMenuBarConfig(
//                 hideAutomatically: false,
//                 height: 50,
//                 margin: EdgeInsets.only(top: 10),
//                 padding: EdgeInsets.all(0),
//                 style: ZegoCallMenuBarStyle.light,
//               )
//               ..rootNavigator = true
//               ..topMenuBar.buttons = [
//                 ZegoCallMenuBarButtonName.minimizingButton,
//                 if (widget.video) ZegoCallMenuBarButtonName.switchCameraButton,
//                 // ZegoCallMenuBarButtonName.showMemberListButton,
//               ]
//               ..layout = ZegoLayout.gallery(
//                 showScreenSharingFullscreenModeToggleButtonRules:
//                     ZegoShowFullscreenModeToggleButtonRules.alwaysHide,
//                 showNewScreenSharingViewInFullscreenMode: false,
//               )

//               // ZegoUIKit().getScreenSharingStateNotifier().value
//               //     ? ZegoLayout.gallery(
//               //         showScreenSharingFullscreenModeToggleButtonRules:
//               //             ZegoShowFullscreenModeToggleButtonRules.alwaysHide,
//               //         showNewScreenSharingViewInFullscreenMode: false,
//               //       )
//               //     : ZegoLayout.pictureInPicture(
//               //         showScreenSharingFullscreenModeToggleButtonRules:
//               //             ZegoShowFullscreenModeToggleButtonRules.alwaysHide,
//               //         showNewScreenSharingViewInFullscreenMode: false,
//               //       )
//               ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
//                 hideAutomatically: false,
//                 height: 64,
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 3,
//                   vertical: 32,
//                 ),
//                 backgroundColor: Colors.grey.withOpacity(.5),
//                 buttons: [
//                   if (widget.video)
//                     ZegoCallMenuBarButtonName.toggleScreenSharingButton,
//                   if (widget.video)
//                     ZegoCallMenuBarButtonName.toggleCameraButton,
//                   ZegoCallMenuBarButtonName.switchAudioOutputButton,
//                   ZegoCallMenuBarButtonName.toggleMicrophoneButton,
//                   ZegoCallMenuBarButtonName.hangUpButton,
//                 ],
//               )
//               ..foreground = Align(
//                 alignment: Alignment.topCenter,
//                 child: Obx(() => Container(
//                       padding: const EdgeInsets.all(10),
//                       margin: const EdgeInsets.only(top: 40),
//                       height: 150,
//                       // color: Color(0xff4A4B4D),
//                       alignment: Alignment.topCenter,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 widget.studentName,
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15),
//                                 textAlign: TextAlign.center,
//                               ),
//                               Text(
//                                 callandChatController
//                                             .audioCallFormatedTime.value ==
//                                         "00:00"
//                                     ? "Connecting"
//                                     : callandChatController
//                                         .audioCallFormatedTime.value,
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),

//                           // if(callandChatController.audioCallFormatedTime.value=="00:00")
//                           //   AnimatedBuilder(
//                           //     animation: _animation,
//                           //     builder: (context, child) {
//                           //       return Padding(
//                           //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           //         child: Row(
//                           //           mainAxisAlignment: MainAxisAlignment.center,
//                           //           children: [
//                           //             _buildDot(_animation.value < 0.5 ? 1.0 : 0.5), // Dot 1
//                           //             const SizedBox(width: 8),
//                           //             _buildDot(_animation.value), // Dot 2
//                           //             const SizedBox(width: 8),
//                           //             _buildDot(_animation.value < 0.5 ? 0.5 : 1.0), // Dot 3
//                           //           ],
//                           //         ),
//                           //       );
//                           //     },
//                           //   )
//                         ],
//                       ),
//                     )),
//               )
//               ..audioVideoView = ZegoCallAudioVideoViewConfig(
//                 useVideoViewAspectFill: true,
//               )
//               // ..background = Text("thtyhtryrtyht")
//               // ..foreground = Text("fjhjfgherjfrhekfjheoifthruoih")
//               ..duration = ZegoCallDurationConfig(
//                   isVisible: false,
//                   onDurationUpdate: (Duration duration) async {
//                     if (callandChatController.enteredUserList.isEmpty &&
//                         duration.inSeconds == 35) {
//                       // to disconnect call ringing after 35 second
//                       // animationController?.dispose();

//                       //remove this if onCallEnd trigger
//                       // ZegoUIKit.instance.uninit();
//                       callandChatController.disconnectCall(
//                           true, false, widget.studentId, widget.callId);
//                       FlutterCallkitIncoming.endCall(widget.callId);
//                       if (Get.currentRoute == "/IncomingCallPage") {
//                         safeBack();
//                       }
//                     }
//                     // print(duration.toString()+"dddddddddddddddddd");
//                   })
//               ..avatarBuilder = (BuildContext context, Size size,
//                   ZegoUIKitUser? user, Map extraInfo) {
//                 return user != null
//                     ? CachedNetworkImage(
//                         height: size.height,
//                         width: size.width,
//                         imageUrl: user.id == widget.studentId.toString()
//                             ? widget.profileImageUrl
//                                     .contains(HttpUrls.imgBaseUrl)
//                                 ? widget.profileImageUrl
//                                 : HttpUrls.imgBaseUrl + widget.profileImageUrl
//                             : HttpUrls.imgBaseUrl + PrefUtils().getProfileUrl(),
//                         imageBuilder: (context, imageProvider) => Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                         progressIndicatorBuilder:
//                             (context, url, downloadProgress) =>
//                                 CircularProgressIndicator(
//                                     value: downloadProgress.progress),
//                         errorWidget: (context, url, error) => const Center(
//                               child: Icon(
//                                 Icons.image_not_supported_outlined,
//                                 color: ColorResources.colorBlue100,
//                                 size: 40,
//                               ),
//                             ))
//                     : const SizedBox();
//               },
//             events: ZegoUIKitPrebuiltCallEvents(
//                 audioVideo: ZegoCallAudioVideoEvents(
//                   onAudioOutputChanged: (ZegoUIKitAudioRoute ss) {
//                     print("jknkj");
//                   },
//                 ),
//                 onError: (error) {
//                   // if(kDebugMode) {
//                   //   ScaffoldMessenger.of(context).showSnackBar(
//                   //     SnackBar(content: Text(error.message)),
//                   //   );
//                   // }
//                 },
//                 room: ZegoCallRoomEvents(
//                   onStateChanged: (ZegoUIKitRoomState roomState) {
//                     if (roomState.errorCode == 100) {
//                       print(
//                           'Room disconnected, possibly due to network issues');
//                       // Handle disconnection
//                     }
//                   },
//                 ),
//                 user: ZegoCallUserEvents(
//                   onEnter: (ZegoUIKitUser user) {
//                     if (kDebugMode) {
//                       ZegoUIKit().turnMicrophoneOn(!ZegoUIKit()
//                           .getMicrophoneStateNotifier(
//                               ZegoUIKit().getLocalUser().id)
//                           .value);
//                     }
//                     if (user.id.toString() == widget.studentId.toString()) {
//                       callandChatController.startTimer();
//                       // if(null!=animationController && animationController!.isDismissed){
//                       //   animationController?.dispose();
//                       // }
//                       callandChatController.enteredUserList.add(user.id);

//                       // showCallNotification(context);
//                     }
//                     setState(() {});
//                   },
//                   onLeave: (ZegoUIKitUser user) {
//                     callandChatController.enteredUserList.remove(user.id);
//                     setState(() {});
//                   },
//                 ),
//                 onCallEnd: (
//                   ZegoCallEndEvent event,
//                   VoidCallback defaultAction,
//                 ) async {
//                   // ZegoUIKit.instance.uninit();

//                   defaultAction.call();
//                   callandChatController.disconnectCall(
//                       true, false, widget.studentId, widget.callId);
//                   FlutterCallkitIncoming.endCall(widget.callId);

//                   // await cancelNotification();
//                   if (Get.currentRoute == "/IncomingCallPage") {
//                     safeBack();
//                   }
//                 }),
//           ),
//         ],
//       ),
//     )));
//   }

//   Widget _buildDot(double scale) {
//     return Transform.scale(
//       scale: scale,
//       child: Container(
//         width: 5,
//         height: 5,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }

//   Future<void> cancelNotification() async {
//     await flutterLocalNotificationsPlugin
//         .cancel(0); // Cancel notification with ID 0
//   }

//   Future<bool> checkUserAvailability() async {
//     busyMessage =
//         await controller.checkCallAvailability(widget.studentId.toString()) ??
//             "";

//     if (!busyMessage.isNullOrEmpty()) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         safeBack();
//         Get.showSnackbar(GetSnackBar(
//           message: busyMessage,
//           duration: const Duration(milliseconds: 3000),
//         ));
//       });
//     }
//     setState(() {});
//     return busyMessage.isNullOrEmpty();
//   }
// }
