// import 'package:breffini_staff/controller/calls_page_controller.dart';
// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:breffini_staff/view/pages/chats/widgets/custom_appbar_widget.dart';
// import 'package:breffini_staff/view/widgets/home_screen_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class CallHistoryScreen extends StatefulWidget {
//   const CallHistoryScreen({super.key});
//
//   @override
//   State<CallHistoryScreen> createState() => _CallHistoryScreenState();
// }
//
// class _CallHistoryScreenState extends State<CallHistoryScreen> {
//   final CallandChatController callandChatController =
//       Get.put(CallandChatController());
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       callandChatController.getChatAndCallHistory('call', 'teacher');
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorResources.colorgrey200,
//         appBar: CustomAppBar(
//           onChanged: (p0) {},
//           title: "Call Log",
//           controller: TextEditingController(),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Obx(() => ListView.builder(
//                     itemCount: callandChatController.callandChatList.length,
//                     shrinkWrap: true,
//                     reverse: true,
//                     physics: const ClampingScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return Column(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               // Get.to(() => ChatContentScreen());
//                             },
//                             child: chatWidget(
//                               callIcon:
//                                   'assets/images/ic_icon_missed_video.svg',
//                               isOngoingCall: true,
//                               name: callandChatController
//                                   .callandChatList[index].firstName,
//                               subTitle: callandChatController
//                                   .callandChatList[index].callDuration
//                                   .toString(),
//                               count: '0',
//                               date: 'Today',
//                               image:
//                                   'https://images.vexels.com/media/users/3/145908/raw/52eabf633ca6414e60a7677b0b917d92-male-avatar-maker.jpg',
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4.h,
//                           ),
//                           Divider(
//                             height: 8.h,
//                             color: ColorResources.colorgrey300,
//                           ),
//                           SizedBox(
//                             height: 4.h,
//                           ),
//                         ],
//                       );
//                     },
//                   ))
//               // : Center(
//               //     child: Column(
//               //       children: [
//               //         SizedBox(
//               //           height: Get.height / 3,
//               //         ),
//               //         Text(
//               //           'No Calls Found',
//               //           style: GoogleFonts.plusJakartaSans(
//               //             color: ColorResources.colorgrey800,
//               //             fontSize: 12.sp,
//               //             fontWeight: FontWeight.w500,
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
