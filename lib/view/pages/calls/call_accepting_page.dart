// import 'package:breffini_staff/controller/ongoing_call_controller.dart';
// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:breffini_staff/view/pages/calls/audio_call_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class CallAcceptingPage extends StatefulWidget {
//   const CallAcceptingPage({super.key});
//
//   @override
//   State<CallAcceptingPage> createState() => _CallAcceptingPageState();
// }
//
// class _CallAcceptingPageState extends State<CallAcceptingPage> {
//   final CallOngoingController ongoingController =
//       Get.put(CallOngoingController());
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ongoingController.getOngoingCalls();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorResources.colorgrey200,
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Container(
//                       height: 30.h,
//                       width: 30.w,
//                       decoration: BoxDecoration(
//                           color: ColorResources.colorBlue100,
//                           borderRadius: BorderRadius.circular(100)),
//                       child: Icon(
//                         CupertinoIcons.back,
//                         size: 18.sp,
//                         color: ColorResources.colorgrey500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 68,
//               ),
//               ListView.builder(
//                 itemCount: 1,
//                 shrinkWrap: true,
//                 physics: const ClampingScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       const SizedBox(
//                         height: 16,
//                       ),
//                       Text(
//                         'Emily Wlliams',
//                         style: GoogleFonts.plusJakartaSans(
//                           color: ColorResources.colorgrey700,
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       Text(
//                         'incoming voice call',
//                         style: GoogleFonts.plusJakartaSans(
//                           color: ColorResources.colorgrey700.withOpacity(.5),
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 60,
//                       ),
//                       Container(
//                         width: 350,
//                         height: 330,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: ColorResources.colorgrey500.withOpacity(.2),
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(165),
//                         ),
//                         child: Center(
//                           child: Container(
//                             width: 280,
//                             height: 280,
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: ColorResources.colorgrey500
//                                       .withOpacity(.35),
//                                   width: 1,
//                                 ),
//                                 borderRadius: BorderRadius.circular(140)),
//                             child: Center(
//                               child: Container(
//                                 width: 230,
//                                 height: 230,
//                                 decoration: BoxDecoration(
//                                   // Example color
//                                   border: Border.all(
//                                     color: ColorResources.colorgrey500
//                                         .withOpacity(.45),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(115),
//                                 ),
//                                 child: Center(
//                                   child: Container(
//                                     width: 160,
//                                     height: 160,
//                                     decoration: BoxDecoration(
//                                       image: const DecorationImage(
//                                           image: CachedNetworkImageProvider(
//                                               'https://cdn.shopify.com/s/files/1/0016/3774/4687/files/Pierce_SOM_-_Edited_1024x1024.png?v=1672765243'),
//                                           fit: BoxFit.cover),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                             blurRadius: 35,
//                                             color: ColorResources.colorBlue400),
//                                       ],
//                                       borderRadius: BorderRadius.circular(100),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 65,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 65,
//                             width: 65,
//                             decoration: BoxDecoration(
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Color(0xFFF45F5F),
//                                     blurRadius: 6,
//                                   )
//                                 ],
//                                 borderRadius: BorderRadius.circular(100),
//                                 color: const Color(0xFFF45F5F)),
//                             child: const Icon(
//                               Icons.call_end_rounded,
//                               size: 28,
//                               color: ColorResources.colorwhite,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 100,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Get.to(() => AudioScreen(
//                                   liveLink: ongoingController
//                                       .onGoingCallsList[0].liveLink,
//                                   callId: ongoingController
//                                       .onGoingCallsList[0].id
//                                       .toString(),studentId: ongoingController
//                                   .onGoingCallsList[0].studentId.toString(),));
//                             },
//                             child: Container(
//                               height: 65,
//                               width: 65,
//                               decoration: BoxDecoration(
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Colors.green,
//                                       blurRadius: 6,
//                                     )
//                                   ],
//                                   borderRadius: BorderRadius.circular(100),
//                                   color: Colors.green),
//                               child: const Icon(
//                                 Icons.call,
//                                 size: 28,
//                                 color: ColorResources.colorwhite,
//                               ),
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
