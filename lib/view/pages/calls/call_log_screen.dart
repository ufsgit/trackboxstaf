// import 'package:breffini_staff/controller/calls_page_controller.dart';
// import 'package:breffini_staff/controller/individual_call_controller.dart';
// import 'package:breffini_staff/controller/live_controller.dart';
// import 'package:breffini_staff/controller/ongoing_call_controller.dart';
// import 'package:breffini_staff/controller/profile_controller.dart';
// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:breffini_staff/core/utils/common_utils.dart';
// import 'package:breffini_staff/core/utils/date_time_utils.dart';
// import 'package:breffini_staff/core/utils/extentions.dart';
// import 'package:breffini_staff/core/utils/firebase_utils.dart';
// import 'package:breffini_staff/core/utils/key_center.dart';
// import 'package:breffini_staff/core/utils/pref_utils.dart';
// import 'package:breffini_staff/core/widgets/common_widgets.dart';
// import 'package:breffini_staff/http/http_urls.dart';
// import 'package:breffini_staff/model/current_call_model.dart';
// import 'package:breffini_staff/model/save_call_model.dart';
// import 'package:breffini_staff/model/teacher_calls_history_model.dart';
// import 'package:breffini_staff/view/pages/calls/audio_call_screen.dart';

// import 'package:breffini_staff/view/pages/calls/widgets/google_meet.dart';
// import 'package:breffini_staff/view/pages/calls/widgets/handle_new_call.dart';
// import 'package:breffini_staff/view/pages/home_screen.dart';
// import 'package:breffini_staff/view/pages/profile/profile_view_page.dart';
// import 'package:breffini_staff/view/widgets/home_screen_widgets.dart';
// import 'package:breffini_staff/view/widgets/profile_widgets.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// import 'package:google_fonts/google_fonts.dart';

// class CallLogScreen extends StatefulWidget {
//   const CallLogScreen({super.key});

//   @override
//   State<CallLogScreen> createState() => _CallLogScreenState();
// }

// class _CallLogScreenState extends State<CallLogScreen> {
//   final CallOngoingController ongoingController =
//       Get.put(CallOngoingController());
//   final ProfileController profileController = Get.put(ProfileController());
//   final LiveClassController liveClassController =
//       Get.put(LiveClassController());
//   final TextEditingController searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;
//   final CallandChatController callandChatController =
//       Get.put<CallandChatController>(CallandChatController());
//   final IndividualCallController controller =
//       Get.put(IndividualCallController());
//   bool isLoadingCallBtn = false;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ongoingController.getOngoingCalls();
//       // callandChatController.getChatAndCallHistory('call', 'teacher');
//     });
//   }

//   Future<bool> _onWillPop() async {
//     Navigator.of(context).pushReplacement(MaterialPageRoute(
//       builder: (context) => const HomePage(initialIndex: 0),
//     ));
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//           onWillPop: _onWillPop,
//           child: Scaffold(
//               backgroundColor: ColorResources.colorgrey200,
//               appBar: AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: ColorResources.colorwhite,
//                 title: Text(
//                   " Calls",
//                   style: GoogleFonts.plusJakartaSans(
//                     color: ColorResources.colorgrey700,
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               body: GestureDetector(
//                   onTap: () {
//                     FocusScope.of(context).unfocus();
//                   },
//                   child: Column(
//                     children: [
//                       Obx(() => callandChatController.callandChatList.isEmpty
//                           ? Expanded(
//                               child: Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(
//                                         'assets/images/ic_no_calls_logo.svg',
//                                         width: 70,
//                                         height: 60),
//                                     const SizedBox(height: 16),
//                                     const Text(
//                                       'No calls',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                         color: ColorResources.colorgrey500,
//                                         fontFamily: 'Plus Jakarta Sans',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : Expanded(
//                               child: ListView.builder(
//                                 itemCount: callandChatController
//                                     .callandChatList.length,
//                                 shrinkWrap: true,
//                                 physics: const ClampingScrollPhysics(),
//                                 padding: const EdgeInsets.all(16),
//                                 itemBuilder: (context, index) {
//                                   var filteredModel = callandChatController
//                                       .callandChatList[index];

//                                   return Column(
//                                     children: [
//                                       (!filteredModel.isFinished &&
//                                               !filteredModel.liveLink
//                                                   .isNullOrEmpty() &&
//                                               filteredModel.isStudentCalled ==
//                                                   1)
//                                           ? InkWell(
//                                               // onTap: isLoadingCallBtn
//                                               //     ? null
//                                               //     : () async {
//                                               //   if(!await isCallExist(context,callandChatController)) {

//                                               //         setState(() =>
//                                               //               isLoadingCallBtn =
//                                               //                   true);

//                                               //           Future.delayed(
//                                               //                   const Duration(
//                                               //                       seconds: 2))
//                                               //               .then((value) {
//                                               //             setState(() =>
//                                               //                 isLoadingCallBtn =
//                                               //                     false);
//                                               //             // if(!callandChatController.currentCallModel.value.callId.isNullOrEmpty()) {
//                                               //             //   showBusySnackBar(context);
//                                               //             // }else{
//                                               //             Get.to(
//                                               //               () =>
//                                               //                   IncomingCallPage(
//                                               //                 liveLink:
//                                               //                     filteredModel
//                                               //                         .liveLink,
//                                               //                 callId:
//                                               //                     filteredModel
//                                               //                         .id
//                                               //                         .toString(),
//                                               //                 studentId:
//                                               //                     filteredModel
//                                               //                         .studentId
//                                               //                         .toString(),
//                                               //                 video: filteredModel
//                                               //                         .callType ==
//                                               //                     'Video',
//                                               //                 profileImageUrl:
//                                               //                     filteredModel
//                                               //                         .profilePhotoPath,
//                                               //                 studentName:
//                                               //                     filteredModel
//                                               //                         .firstName,
//                                               //               ),
//                                               //             )?.then((value) {
//                                               //               setState(() {});
//                                               //             });
//                                               //           });
//                                               //         }
//                                               //       },
//                                               onTap: () async {
//                                                 String callId =
//                                                     filteredModel.id.toString();

//                                                 String studentId = filteredModel
//                                                     .studentId
//                                                     .toString();
//                                                 String studentName =
//                                                     filteredModel.firstName
//                                                         .toString();
//                                                 String profileImage =
//                                                     filteredModel
//                                                         .profilePhotoPath
//                                                         .toString();

//                                                 await handleCall(
//                                                   studentId:
//                                                       studentId.toString(),
//                                                   studentName: studentName,
//                                                   callId: callId,
//                                                   isVideo: true,
//                                                   profileImageUrl: profileImage,
//                                                   liveLink: filteredModel
//                                                       .liveLink
//                                                       .toString(),
//                                                   controller: controller,
//                                                   callandChatController:
//                                                       callandChatController,
//                                                   safeBack: safeBack,
//                                                 );
//                                                 setState(() {});

//                                                 MeetCallTracker(
//                                                   onCallEnded: () {},
//                                                 ).startMeetCall(
//                                                     meetCode: filteredModel
//                                                         .liveLink
//                                                         .toString());
//                                               },
//                                               child: incomingCallWidget(
//                                                 callIcon: isLoadingCallBtn
//                                                     ? const SizedBox(
//                                                         width: 20,
//                                                         height: 20,
//                                                         child:
//                                                             CircularProgressIndicator(
//                                                           color: Colors.white,
//                                                           strokeWidth: 2,
//                                                         ),
//                                                       )
//                                                     : filteredModel.callType ==
//                                                             'Video'
//                                                         ? const Icon(
//                                                             Icons.videocam,
//                                                             color:
//                                                                 ColorResources
//                                                                     .colorwhite,
//                                                             size: 20,
//                                                           )
//                                                         : const Icon(
//                                                             Icons.call,
//                                                             color:
//                                                                 ColorResources
//                                                                     .colorwhite,
//                                                             size: 20,
//                                                           ),
//                                                 name: filteredModel.firstName,
//                                                 subTitle:
//                                                     'Incoming ${filteredModel.callType} call',
//                                                 count: '0',
//                                                 date: 'Today',
//                                                 image: !filteredModel
//                                                         .profilePhotoPath
//                                                         .isNullOrEmpty()
//                                                     ? (HttpUrls.imgBaseUrl +
//                                                         filteredModel
//                                                             .profilePhotoPath)
//                                                     : "assets/images/default_profile.jpg",
//                                                 isOngoingCall:
//                                                     callandChatController
//                                                             .currentCallModel
//                                                             .value
//                                                             .callId ==
//                                                         filteredModel.id
//                                                             .toString(),
//                                               ),
//                                             )
//                                           : InkWell(
//                                               onTap: PrefUtils()
//                                                       .getMeetLink()
//                                                       .isNotEmpty
//                                                   ? () async {
//                                                       await handleCall(
//                                                         studentId:
//                                                             callandChatController
//                                                                 .callandChatList[
//                                                                     index]
//                                                                 .studentId
//                                                                 .toString(),
//                                                         studentName:
//                                                             callandChatController
//                                                                 .callandChatList[
//                                                                     index]
//                                                                 .firstName,
//                                                         callId: '',
//                                                         isVideo: true,
//                                                         profileImageUrl:
//                                                             callandChatController
//                                                                 .callandChatList[
//                                                                     index]
//                                                                 .profilePhotoPath,
//                                                         liveLink: PrefUtils()
//                                                             .getMeetLink(),
//                                                         controller: controller,
//                                                         callandChatController:
//                                                             callandChatController,
//                                                         safeBack: safeBack,
//                                                       );
//                                                       setState(() {});
//                                                       MeetCallTracker(
//                                                         onCallEnded: () {},
//                                                       ).startMeetCall(
//                                                           meetCode: PrefUtils()
//                                                               .getMeetLink());
//                                                     }
//                                                   : () {
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(
//                                                               const SnackBar(
//                                                                   content: Text(
//                                                                       'Create a google meet link to initiate call')));
//                                                     },

//                                               // onTap: () async {
//                                               // //   if (!await isCallExist(context,
//                                               // //       callandChatController)) {
//                                               // //     Get.to(() => IncomingCallPage(
//                                               // //           liveLink: "",
//                                               // //           callId: "",
//                                               // //           studentId:
//                                               // //               callandChatController
//                                               // //                   .callandChatList[
//                                               // //                       index]
//                                               // //                   .studentId
//                                               // //                   .toString(),
//                                               // //           video: callandChatController
//                                               // //                   .callandChatList[
//                                               // //                       index]
//                                               // //                   .callType ==
//                                               // //               "Video",
//                                               // //           profileImageUrl:
//                                               // //               callandChatController
//                                               // //                   .callandChatList[
//                                               // //                       index]
//                                               // //                   .profilePhotoPath,
//                                               // //           studentName:
//                                               // //               callandChatController
//                                               // //                   .callandChatList[
//                                               // //                       index]
//                                               // //                   .firstName,
//                                               // //         ));
//                                               // //   }
//                                               // // },
//                                               child: callHistoryWidget(
//                                                 eyeIcon: IconButton(
//                                                     onPressed: () {
//                                                       Get.to(() => ProfileViewPage(
//                                                           courseId: '',
//                                                           profileUrl:
//                                                               '${HttpUrls.imgBaseUrl}${callandChatController.callandChatList[index].profilePhotoPath}',
//                                                           studentName:
//                                                               '${callandChatController.callandChatList[index].firstName} ${callandChatController.callandChatList[index].lastName}',
//                                                           contactDetails: callandChatController
//                                                                   .callandChatList[
//                                                                       index]
//                                                                   .email
//                                                                   .isNotEmpty
//                                                               ? callandChatController
//                                                                   .callandChatList[
//                                                                       index]
//                                                                   .email
//                                                               : callandChatController
//                                                                   .callandChatList[
//                                                                       index]
//                                                                   .phoneNumber,
//                                                           studentId:
//                                                               callandChatController
//                                                                   .callandChatList[
//                                                                       index]
//                                                                   .studentId
//                                                                   .toString()));
//                                                     },
//                                                     color: ColorResources
//                                                         .colorgrey500,
//                                                     icon: const Icon(Icons
//                                                         .remove_red_eye_outlined)),
//                                                 color: callandChatController
//                                                             .callandChatList[
//                                                                 index]
//                                                             .isStudentCalled ==
//                                                         0
//                                                     ? const Color.fromARGB(
//                                                         255, 0, 122, 20)
//                                                     : const Color.fromARGB(
//                                                         255, 255, 0, 0),
//                                                 date: formatDateinDdMmYy(
//                                                     callandChatController
//                                                         .callandChatList[index]
//                                                         .callEnd
//                                                         .toString()),
//                                                 time: formatTimeinAmPm(
//                                                     callandChatController
//                                                         .callandChatList[index]
//                                                         .callEnd
//                                                         .toString()),
//                                                 callIcon: callandChatController
//                                                             .callandChatList[
//                                                                 index]
//                                                             .isStudentCalled ==
//                                                         0
//                                                     ? Material(
//                                                         elevation: 0,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         50)),
//                                                         color: Colors.white,
//                                                         child: const Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   4.0),
//                                                           child: Icon(
//                                                             Icons
//                                                                 .call_made_rounded,
//                                                             color: Colors.green,
//                                                             size: 14,
//                                                           ),
//                                                         ))
//                                                     : Material(
//                                                         elevation: 0,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         50)),
//                                                         color: Colors.white,
//                                                         child: const Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   4.0),
//                                                           child: Icon(
//                                                             Icons
//                                                                 .call_received_rounded,
//                                                             color: Colors.red,
//                                                             size: 14,
//                                                           ),
//                                                         )),
//                                                 name:
//                                                     '${callandChatController.callandChatList[index].firstName.toString()} ${callandChatController.callandChatList[index].lastName}',
//                                                 callType: callandChatController
//                                                     .callandChatList[index]
//                                                     .callType,
//                                                 subTitle: (callandChatController
//                                                             .callandChatList[
//                                                                 index]
//                                                             .isRejected &&
//                                                         callandChatController
//                                                             .callandChatList[
//                                                                 index]
//                                                             .isRinged &&
//                                                         callandChatController
//                                                                 .callandChatList[
//                                                                     index]
//                                                                 .isStudentCalled ==
//                                                             1)
//                                                     ? "Rejected"
//                                                     : (!callandChatController.callandChatList[index].isConnected &&
//                                                             callandChatController
//                                                                 .callandChatList[
//                                                                     index]
//                                                                 .isRinged &&
//                                                             callandChatController.callandChatList[index].isStudentCalled ==
//                                                                 0)
//                                                         ? "Not Answered"
//                                                         : (callandChatController.callandChatList[index].isRinged &&
//                                                                 !callandChatController
//                                                                     .callandChatList[
//                                                                         index]
//                                                                     .isConnected &&
//                                                                 !callandChatController
//                                                                     .callandChatList[
//                                                                         index]
//                                                                     .isRejected &&
//                                                                 callandChatController
//                                                                         .callandChatList[
//                                                                             index]
//                                                                         .isStudentCalled ==
//                                                                     1)
//                                                             ? "Missed Call"
//                                                             : formatDuration(double.parse(
//                                                                 callandChatController
//                                                                         .callandChatList[
//                                                                             index]
//                                                                         .callDuration ??
//                                                                     "0.0")),
//                                                 image: !callandChatController
//                                                         .callandChatList[index]
//                                                         .profilePhotoPath
//                                                         .isNullOrEmpty()
//                                                     ? (HttpUrls.imgBaseUrl +
//                                                         callandChatController
//                                                             .callandChatList[
//                                                                 index]
//                                                             .profilePhotoPath)
//                                                     : "assets/images/default_profile.jpg",
//                                               ),
//                                             ),
//                                       const SizedBox(height: 15),
//                                       Divider(
//                                         height: 8.h,
//                                         color: ColorResources.colorgrey300,
//                                       ),
//                                       SizedBox(height: 4.h),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             )),
//                     ],
//                   )))),
//     );
//   }

//   Widget incomingCallWidget(
//       {required String name,
//       required String subTitle,
//       required String count,
//       required String image,
//       Widget? callIcon,
//       required bool isOngoingCall,
//       void Function()? onTap,
//       required String date}) {
//     return SizedBox(
//       height: 60.h,
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(0),
//         // tileColor: ColorResources.colorBlack,
//         leading: CircleAvatar(
//           backgroundImage: CachedNetworkImageProvider(image),
//           radius: 23,
//         ),
//         title: Text(
//           name,
//           style: GoogleFonts.plusJakartaSans(
//             color: ColorResources.colorBlack,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w700,
//           ),
//         ),

//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 4),
//           child: Text(
//             subTitle,
//             overflow: TextOverflow.ellipsis,
//             style: GoogleFonts.plusJakartaSans(
//               color: ColorResources.colorgrey600,
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Text(
//             //   date,
//             //   style: GoogleFonts.plusJakartaSans(
//             //     color: ColorResources.colorgrey600,
//             //     fontSize: 12.sp,
//             //     fontWeight: FontWeight.w500,
//             //   ),
//             // ),
//             SizedBox(
//               height: 6.h,
//             ),
//             isOngoingCall
//                 ? Obx(() {
//                     return Container(
//                       height: 35,
//                       // width: 35,
//                       decoration: BoxDecoration(
//                           // color: Colors.red,
//                           borderRadius: BorderRadius.circular(100)),
//                       child: Text(
//                         callandChatController.audioCallFormatedTime.value,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.plusJakartaSans(
//                           color: Colors.green,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   })
//                 : Container(
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(100)),
//                     child: IconButton(onPressed: onTap, icon: callIcon!),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
