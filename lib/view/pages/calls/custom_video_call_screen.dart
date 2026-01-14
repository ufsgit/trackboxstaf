// import 'dart:developer';
// import 'dart:math' as math;

// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:breffini_staff/model/save_call_model.dart';
// import 'package:breffini_staff/view/pages/chats/widgets/common_widgets.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
// import '../../../controller/live_controller.dart';
// import '../../../controller/profile_controller.dart';
// import '../../../core/utils/key_center.dart';
// import '../../../core/utils/zego_token_utils.dart';
// import '../../../model/save_live_class_model.dart';
// import 'widgets/bottom_bar.dart';
// import 'widgets/live_data_widget.dart';
// import 'widgets/pop_up_menu_container.dart';
// import 'widgets/remote_user_widget.dart';
// import 'widgets/top_bar_widget.dart';

// class CustomVideoCallScreen extends StatefulWidget {
//   const CustomVideoCallScreen({
//     super.key,
//     this.courseId = '',
//     this.batchId = '',
//     // required this.isIndividualVideoCall,
//     required this.isIndividualAudioCall,
//     this.studentId = 0,
//     this.profileUrl,
//     this.studentName,
//     this.liveLink,
//     this.stopLink,
//   });
//   final String courseId;
//   final String batchId;
//   final String? profileUrl;
//   final String? studentName;
//   final int studentId;
//   final String? liveLink;
//   final String? stopLink;
//   // final bool isIndividualVideoCall;
//   final bool isIndividualAudioCall;
//   @override
//   State<CustomVideoCallScreen> createState() => _CustomVideoCallScreenState();
// }

// class _CustomVideoCallScreenState extends State<CustomVideoCallScreen> {
//   LiveClassController videoCallCtrl = Get.put(LiveClassController());
//   ProfileController profileController = Get.put(ProfileController());
//   Widget? localView;
//   int? localViewID;
//   var uuid = const Uuid();
//   String uniqId = '';
//   Widget? remoteView;
//   int? remoteViewID;
//   @override
//   void initState() {
//     uniqId = uuid.v1();
//     if (widget.isIndividualAudioCall) {
//       // videoCallCtrl.individualVideoCall.value = widget.isIndividualVideoCall;
//       log('   individualCall');

//       videoCallCtrl.saveIndividualStudentCall(SaveStudentCallModel(
//           id: 0,
//           teacherId: 0,
//           studentId: widget.studentId,
//           callStart: DateTime.now(),
//           callEnd: '',
//           callDuration: null,
//           // callType: widget.isIndividualVideoCall ? 'Video' : 'Audio',
//           callType: 'Audio',
//           isStudentCalled: 0,
//           liveLink: uniqId));
//     } else {
//       videoCallCtrl.saveLiveClass(SaveLiveClassTeacher(
//           liveClassId: 0,
//           courseId: int.parse(
//             widget.courseId,
//           ),
//           teacherId: 1,
//           batchId: int.parse(
//             widget.batchId,
//           ),
//           scheduledDateTime: DateTime.now(),
//           duration: 1,
//           startTime: DateTime.now(),
//           liveLink: uniqId));
//     }
//     log('   studentId ${widget.studentId}');
//     log('   UniqueID $uniqId');
//     startListenEvent();
//     videoCallCtrl.startTimer();
//     loginRoom();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor:
//           widget.isIndividualAudioCall ? Colors.white : Colors.grey.shade700,
//       body: GetBuilder(
//         init: LiveClassController(),
//         builder: (value) {
//           return Stack(
//             children: [
//               //---Local User
//               Obx(() {
//                 if (videoCallCtrl.isVideoEnabled.value == true) {
//                   return localView ?? const SizedBox.shrink();
//                 } else {
//                   return SizedBox(
//                     width: size.width,
//                     height: size.height,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 163,
//                           height: 163,
//                           decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Colors.black26, blurRadius: 10),
//                               ],
//                               border: Border.all(color: Colors.white, width: 3),
//                               image: DecorationImage(
//                                 fit: BoxFit.contain,
//                                 image: widget.isIndividualAudioCall &&
//                                         widget.profileUrl != null
//                                     ? NetworkImage(widget.profileUrl!)
//                                     : const AssetImage(
//                                         "assets/images/Ellipse 32.png"),
//                               ),
//                               shape: BoxShape.circle,
//                               color: Colors.white),
//                         ),
//                         if (widget.isIndividualAudioCall)
//                           const SizedBox(
//                             height: 50,
//                           ),
//                         if (widget.isIndividualAudioCall)
//                           Text(
//                             widget.studentName ?? 'User Name',
//                             style: GoogleFonts.plusJakartaSans(
//                               color: ColorResources.colorBlack,
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         const SizedBox(
//                           height: 4,
//                         ),
//                         if (widget.isIndividualAudioCall)
//                           Obx(
//                             () => Text(
//                               "${videoCallCtrl.formattedTime}",
//                               style: GoogleFonts.plusJakartaSans(
//                                   color: ColorResources.colorgrey600,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           )
//                       ],
//                     ),
//                   );
//                 }
//               }),

//               //---Top Bar
//               if (widget.isIndividualAudioCall)
//                 Positioned(
//                   top: 50,
//                   left: 20,
//                   child: Container(
//                     height: 28.h,
//                     width: 28.w,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         color: ColorResources.colorBlue100),
//                     child: InkWell(
//                       onTap: () async {
//                         Get.back();
//                         videoCallCtrl.stopListenEvent();
//                         logoutRoom();
//                       },
//                       child: const Icon(
//                         CupertinoIcons.back,
//                         color: ColorResources.colorgrey500,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 )
//               else
//                 TopBarWidget(size: size, videoCallCtrl: videoCallCtrl),

//               //Videocall Live Data
//               widget.isIndividualAudioCall
//                   ? const SizedBox()
//                   : VideoCallLiveDataWidget(videoCallCtrl: videoCallCtrl),

//               //Popup Menu Container
//               Obx(() {
//                 return videoCallCtrl.onButtonPop.value == true
//                     ? PopUpMenuContainer(videoCallCtrl: videoCallCtrl)
//                     : const SizedBox();
//               }),

//               //--Call Role Widget
//               //!-- CallRoleWidget(),

//               //---Remote User
//               if (widget.isIndividualAudioCall)
//                 RemoteUserWidget(
//                     size: size,
//                     videoCallCtrl: videoCallCtrl,
//                     remoteView: remoteView)
//               else
//                 RemoteBatchUsersWidget(
//                     size: size,
//                     videoCallCtrl: videoCallCtrl,
//                     remoteView: remoteView),
//               //---Bottom Button Bar
//               BottomBarWidget(
//                 logout: logoutRoom,
//                 videoCallCtrl: videoCallCtrl,
//                 callID: uniqId,
//                 localView: localView,
//                 localViewID: localViewID,
//                 isIndividual: widget.isIndividualAudioCall,
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Future<ZegoRoomLoginResult?> loginRoom() async {
//     try {
//       // The value of `userID` is generated locally and must be globally unique.
//       final user = ZegoUser('${profileController.getTeacher[0].userId}',
//           profileController.getTeacher[0].firstName);

//       // The value of `roomID` is generated locally and must be globally unique.
//       final roomID = uniqId;

//       // onRoomUserUpdate callback can be received when "isUserStatusNotify" parameter value is "true".
//       log('$roomID');
//       ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()
//         ..isUserStatusNotify = true;

//       if (kIsWeb) {
//         // ! ** Warning: ZegoTokenUtils is only for use during testing. When your application goes live,
//         // ! ** tokens must be generated by the server side. Please do not generate tokens on the client side!
//         roomConfig.token = ZegoTokenUtils.generateToken(
//             ZegoUtils.appID,
//             ZegoUtils.serverSecret,
//             '${profileController.getTeacher[0].userId}');
//       }

//       // log in to a room
//       // Users must log in to the same room to call each other.
//       return ZegoExpressEngine.instance
//           .loginRoom(widget.liveLink ?? roomID, user, config: roomConfig)
//           .then((ZegoRoomLoginResult loginRoomResult) {
//         debugPrint(
//             'loginRoom: errorCode:${loginRoomResult.errorCode}, extendedData:${loginRoomResult.extendedData}');
//         updateActiveRooms(widget.liveLink ?? roomID, true);

//         if (loginRoomResult.errorCode == 0) {
//           startPreview();
//           log('dfsgrtg');
//           startPublish();
//         } else {
//           log('dfsgrtg434334');
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text('loginRoom failed: ${loginRoomResult.errorCode}')));
//         }
//         return loginRoomResult;
//       });
//     } catch (e) {
//       log('<<<<<<<<${e.toString()}>>>>>>>>');
//       return null;
//     }
//   }

//   List<String> activeRoomIDs = [];

//   void updateActiveRooms(String roomID, bool isLoggingIn) {
//     if (isLoggingIn) {
//       if (!activeRoomIDs.contains(roomID)) {
//         activeRoomIDs.add(roomID);
//         log('Logged into room: $roomID');
//       }
//     } else {
//       activeRoomIDs.remove(roomID);
//       log('Logged out of room: $roomID');
//     }
//   }

//   Future<ZegoRoomLogoutResult> logoutRoom() async {
//     await videoCallCtrl.disconnectUser();
//     await stopPreview();
//     await stopPublish();
//     return await ZegoExpressEngine.instance.logoutRoom(uniqId);
//   }

//   void startListenEvent() {
//     // Callback for updates on the status of other users in the room.
//     // Users can only receive callbacks when the isUserStatusNotify property of ZegoRoomConfig is set to `true` when logging in to the room (loginRoom).
//     log('   sTartListening ');

//     ZegoExpressEngine.onRoomUserUpdate =
//         (roomID, updateType, List<ZegoUser> userList) {
//       log('   Zego engine userList $userList');
//       log('   Zego rromId $roomID');
//       log('   Zego WDGlIVELIK  ${widget.liveLink}');
//       log('   Zego livelink ${widget.liveLink ?? roomID}');
//       log('   Zego UpdateType  $updateType');
//       debugPrint(
//           'onRoomUserUpdate: roomID: ${widget.liveLink ?? roomID}, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}, userList:$userList');

//       for (int i = 0; i < userList.length; i++) {
//         log('   Zego rromId $roomID');
//         if (updateType.name == "Add") {
//           videoCallCtrl.getUserList(true, userList, i, context);
//         } else {
//           videoCallCtrl.getUserList(false, userList, i, context);
//         }
//       }
//     };

//     ZegoExpressEngine.onRoomOnlineUserCountUpdate = (roomID, count) {
//       videoCallCtrl.getUserCount(count);

//       debugPrint(
//           'onRoomUserUpdate: roomID: $roomID, UserCount: ${videoCallCtrl.userCount.value}');
//     };

//     ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
//       debugPrint(
//           'onRemoteMicStateUpdate: streamID: $streamID, updateType: $state');
//     };

//     // Callback for updates on the status of the streams in the room.
//     ZegoExpressEngine.onRoomStreamUpdate =
//         (roomID, updateType, List<ZegoStream> streamList, extendedData) {
//       debugPrint(
//           'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
//       if (updateType == ZegoUpdateType.Add) {
//         for (final stream in streamList) {
//           startPlayStream(stream.streamID);
//         }
//       } else {
//         for (final stream in streamList) {
//           stopPlayStream(stream.streamID);
//         }
//       }
//     };

//     // Callback for updates on the current user's room connection status.
//     ZegoExpressEngine.onRoomStateUpdate =
//         (roomID, state, errorCode, extendedData) {
//       debugPrint(
//           'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };

//     // Callback for updates on the current user's stream publishing changes.
//     ZegoExpressEngine.onPublisherStateUpdate =
//         (streamID, state, errorCode, extendedData) {
//       debugPrint(
//           'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };

//     ZegoExpressEngine.onRoomExtraInfoUpdate = (roomID, roomExtraInfoList) {
//       // videoCallCtrl.getRoomExtraInfo(roomExtraInfoList);
//       debugPrint(
//           'onRoomExtraInfoUpdate: streamID: $roomID, roomExtraInfoList:  $roomExtraInfoList');
//     };

//     ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) {
//       debugPrint(
//           'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}');
//     };

//     ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
//       debugPrint(
//           'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}');
//     };
//   }

//   Future<void> startPreview() async {
//     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//       log('<<<<<<<<   view ID $viewID>>>>>>>>');
//       localViewID = viewID;
//       ZegoCanvas previewCanvas =
//           ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
//       ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
//     }).then((canvasViewWidget) {
//       setState(() => localView = canvasViewWidget);
//     });
//   }

//   Future<void> stopPreview() async {
//     ZegoExpressEngine.instance.stopPreview();
//     log('<<<<<<<<<<<<<<<<1>>>>>>>>>>>>>>>>');
//     if (localViewID != null) {
//       log('<<<<<<<<<<<<<<<<2>>>>>>>>>>>>>>>>');
//       await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
//       if (mounted) {
//         log('<<<<<<<<<<<<<<<<3>>>>>>>>>>>>>>>>');
//         setState(() {
//           localViewID = null;
//           localView = null;
//         });
//       }
//     }
//   }

//   Future<void> startPublish() async {
//     // After calling the `loginRoom` method, call this method to publish streams.
//     // The StreamID must be unique in the room.

//     String streamID = '${uniqId}_${DateTime.now().millisecondsSinceEpoch}';
//     return ZegoExpressEngine.instance.startPublishingStream(streamID);
//   }

//   Future<void> stopPublish() async {
//     return ZegoExpressEngine.instance.stopPublishingStream();
//   }

//   Future<void> startPlayStream(String streamID) async {
//     // Start to play streams. Set the view for rendering the remote streams.
//     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//       remoteViewID = viewID;
//       ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
//       ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
//     }).then((canvasViewWidget) {
//       setState(() => remoteView = canvasViewWidget);
//     });
//   }

//   Future<void> stopPlayStream(String streamID) async {
//     ZegoExpressEngine.instance.stopPlayingStream(streamID);
//     if (remoteViewID != null) {
//       ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
//       if (mounted) {
//         setState(() {
//           remoteViewID = null;
//           remoteView = null;
//         });
//       }
//     }
//   }
// }

// class RemoteUserWidget extends StatelessWidget {
//   const RemoteUserWidget({
//     super.key,
//     required this.size,
//     required this.videoCallCtrl,
//     required this.remoteView,
//   });

//   final Size size;
//   final LiveClassController videoCallCtrl;
//   final Widget? remoteView;

//   @override
//   Widget build(BuildContext context) {
//     log('User ${videoCallCtrl.userInfoList}');
//     return Positioned(
//         right: 3,
//         top: 60,
//         child: Obx(
//           () => SizedBox(
//             width: size.width / 2.7,
//             height: size.height * 0.23,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: videoCallCtrl.userInfoList.length,
//                 itemBuilder: (context, int index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 02),
//                     child: Stack(
//                       children: [
//                         if (videoCallCtrl.userInfoList[index]["videoStatus"] ==
//                             true)
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.white,
//                             ),
//                             width: MediaQuery.of(context).size.width / 3,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: remoteView ?? const SizedBox(),
//                             ),
//                           )
//                         else
//                           Container(
//                             width: MediaQuery.of(context).size.width / 3,
//                             padding: const EdgeInsets.all(06),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.black,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 videoCallCtrl.userInfoList[index]
//                                             ["audioStatus"] ==
//                                         false
//                                     ? const Row(
//                                         children: [
//                                           Icon(
//                                             Icons.mic_off,
//                                             color: Colors.white,
//                                           )
//                                         ],
//                                       )
//                                     : const SizedBox(),
//                                 InkWell(
//                                   onTap: () {
//                                     log('<<<<<<<<<<<<${videoCallCtrl.userInfoList[index]}>>>>>>>>>>>>');
//                                   },
//                                   child: Text(
//                                     getNameFirtLetter(videoCallCtrl
//                                         .userInfoList[index]['userName']
//                                         .toString()),
//                                     style: GoogleFonts.plusJakartaSans(
//                                         color: ColorResources.colorwhite,
//                                         fontSize: 32,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "",
//                                       style: GoogleFonts.plusJakartaSans(
//                                           color: ColorResources.colorwhite,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         Positioned(
//                           top: 08,
//                           left: 08,
//                           child: SvgPicture.asset(
//                             videoCallCtrl.userInfoList[index]["audioStatus"] ==
//                                     false
//                                 ? "assets/images/MicrophoneSlash.svg"
//                                 : 'assets/images/Microphone.svg',
//                             height: 100,
//                             width: 100,
//                             color: Colors.amber,
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 08,
//                           left: 08,
//                           child: Text(
//                             videoCallCtrl.userInfoList[index]['userName'],
//                             style: GoogleFonts.plusJakartaSans(
//                                 color: ColorResources.colorwhite,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         Positioned(
//                           top: 08,
//                           left: 08,
//                           child: SvgPicture.asset(
//                             videoCallCtrl.userInfoList[index]["audioStatus"] ==
//                                     false
//                                 ? "assets/images/MicrophoneSlash.svg"
//                                 : 'assets/images/Microphone.svg',
//                             color: Colors.white60,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//           ),
//         ));
//   }

//   String getNameFirtLetter(String string) {
//     String letter = "";

//     // Check each character to see if it's 'A' and add to the letterA variable
//     for (int i = 0; i < string.length; i++) {
//       if (string[i].toUpperCase() == 'A') {
//         letter = string[i].toUpperCase(); // Ensure it's uppercase
//         break; // Stop after finding the first 'A'
//       }
//     }
//     return letter;
//   }
// }
