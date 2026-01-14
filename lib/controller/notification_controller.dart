// import 'package:breffini_staff/controller/individual_call_controller.dart';
// import 'package:breffini_staff/controller/live_controller.dart';
// import 'package:breffini_staff/core/utils/extentions.dart';
// import 'package:breffini_staff/view/pages/calls/incoming_call_screen.dart';
// import 'package:get/get.dart';
// // import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:breffini_staff/view/pages/home_screen.dart';
//
// class NotificationController {
//   /// Use this method to detect when a new notification or a schedule is created
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect every time that a new notification is displayed
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect if the user dismissed a notification
//   @pragma("vm:entry-point")
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect when the user taps on a notification or action button
//   @pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     String? payloadType = receivedAction.payload?['type'];
//     print('Notification Received: $payloadType');
//
//     // Explicitly check for null before using Get.isDialogOpen
//     bool isDialogOpen = Get.isDialogOpen ?? false;
//     bool isSnackbarOpen = Get.isSnackbarOpen ?? false;
//
//     // Handle open dialogs or snackbars
//     if (isDialogOpen || isSnackbarOpen) {
//       Get.back(); // Close dialogs or snackbars if open
//     }
//
//     // Navigate based on payload type
//     switch (payloadType) {
//       case 'new_call':
//         if (Get.currentRoute != "/Widget") {
//           //danger may be chance for app close
//           Get.back();
//         }
//         if (receivedAction.buttonKeyPressed == 'reject_btn') {
//           String liveLink=receivedAction.payload!['Live_Link']??'';
//           if(!liveLink.isNullOrEmpty()) {
//             String callId=receivedAction.payload!['id']??'';
//             // String callType=receivedAction.payload!['call_type']??'';
//             int callerId=int.parse(receivedAction.payload!['sender_id']??"0");
//
//               Get.put(IndividualCallController().stopCall(studentId:callerId.toString(),callId: callId,isRejectCall: true));
//
//           }
//         } else if (receivedAction.buttonKeyPressed == 'accept_btn') {
//
//           String liveLink=receivedAction.payload!['Live_Link']??'';
//           if(!liveLink.isNullOrEmpty()) {
//             String callId=receivedAction.payload!['id']??'';
//             String callType=receivedAction.payload!['call_type']??'';
//             int callerId=int.parse(receivedAction.payload!['sender_id']??"0");
//             String profileImgUrl=receivedAction.payload!.containsKey("Profile_Photo_Img")?receivedAction.payload!['Profile_Photo_Img']??"":"";
//             String callerName=receivedAction.payload!.containsKey("Caller_Name")?receivedAction.payload!['Caller_Name']??"":"";
//
//             Get.to(() =>
//                 IncomingCallPage(
//                   liveLink: liveLink,
//                   callId: callId,
//                   video: callType == 'Video',
//                   studentId: callerId.toString(),
//                   // isIncomingCall: true,
//                   profileImageUrl: profileImgUrl,
//                   studentName: callerName,
//                 ));
//           }
//         }else {
//           Get.offAll(() => const HomePage(initialIndex: 1));
//
//         }
//         break;
//       case 'new_message':
//         Get.offAll(() => const HomePage(initialIndex: 0));
//         break;
//       default:
//         Get.offAll(() => const HomePage(initialIndex: 0)); // Default case
//         break;
//     }
//   }
// }
