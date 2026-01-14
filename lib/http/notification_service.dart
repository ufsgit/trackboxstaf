// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:developer';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// // //-- Intialize Push Notification & Local Notification Services
// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   print("Handling a background message: ${message.messageId}");
// //   await NotificationService().initializePushNotification(message);
// //   await NotificationService().initializeLocalNotifications();
// // }
//
// // class NotificationService {
// //   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
//
// //   //--Background Notification Services
//
// //   Future<void> initializePushNotification(RemoteMessage message) async {
// //     handleMessage(message);
//
// //     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage(message));
// //   }
//
// //   static Future<void> onBackgroundMsg() async {
// //     FirebaseMessaging.onBackgroundMessage(backgroundHandler);
// //   }
//
// //   static Future<void> backgroundHandler(RemoteMessage message) async {
// //     log(message.toString());
// //   }
//
// //   handleMessage(RemoteMessage message) async {
// //     log("Handle the Background message functionalities here");
//
// //     await flutterLocalNotificationsPlugin.show(
// //       message.hashCode,
// //       message.notification?.title,
// //       message.notification?.body,
// //       NotificationDetails(
// //         android: AndroidNotificationDetails(
// //           '',
// //           '',
// //           channelDescription: '',
// //           icon: "@mipmap/ic_launcher",
// //           importance: Importance.max,
// //           priority: Priority.max,
// //           playSound: true,
// //         ),
// //       ),
// //     );
// //     // if (message.data['type'] == 'chat') {
// //     //   print("This is a Chat Notification");
// //     // }
// //   }
//
// //   //--Local Notifications Services
//
// //   onSelectNotification(NotificationResponse notificationResponse) async {
// //     var payloadData = jsonDecode(notificationResponse.payload ?? "");
// //     print("payload $payloadData");
// //   }
//
// //   Future<void> initializeLocalNotifications() async {
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
// //       const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //         'high_importance_channel',
// //         'High Importance Notifications',
// //         description: 'This channel is used for important notifications.',
// //         importance: Importance.max,
// //       );
//
// //       const AndroidInitializationSettings initializationSettingsAndroid =
// //           AndroidInitializationSettings('@mipmap/ic_launcher');
//
// //       final InitializationSettings initializationSettings =
// //           InitializationSettings(
// //         android: initializationSettingsAndroid,
// //       );
//
// //       await flutterLocalNotificationsPlugin.initialize(
// //         initializationSettings,
// //         onDidReceiveNotificationResponse: onSelectNotification,
// //         onDidReceiveBackgroundNotificationResponse: onSelectNotification,
// //       );
//
// //       print('Got a message whilst in the foreground!');
// //       if (message.notification != null) {
// //         print('Notification Title: ${message.notification?.title}');
// //         print('Notification Body: ${message.notification?.body}');
// //         await flutterLocalNotificationsPlugin.show(
// //           message.hashCode,
// //           message.notification?.title,
// //           message.notification?.body,
// //           NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               channel.id,
// //               channel.name,
// //               channelDescription: channel.description,
// //               icon: "@mipmap/ic_launcher",
// //               importance: Importance.max,
// //               priority: Priority.max,
// //               playSound: true,
// //             ),
// //           ),
// //         );
// //       }
// //     });
// //   }
// // }
//
// import 'dart:async';
// import 'dart:developer';
// // import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:convert';
import 'dart:io';

import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/controller/chat_firebase_controller.dart';
import 'package:breffini_staff/controller/individual_call_controller.dart';
import 'package:breffini_staff/controller/live_controller.dart';
import 'package:breffini_staff/controller/notification_controller.dart';
import 'package:breffini_staff/controller/ongoing_call_controller.dart';
import 'package:breffini_staff/controller/profile_controller.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/firebase_options.dart';
import 'package:breffini_staff/http/chat_socket.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/ongoing_call_model.dart';
import 'package:breffini_staff/view/pages/calls/incoming_call_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming_yoer/entities/android_params.dart';
import 'package:flutter_callkit_incoming_yoer/entities/call_event.dart';
import 'package:flutter_callkit_incoming_yoer/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming_yoer/entities/ios_params.dart';
import 'package:flutter_callkit_incoming_yoer/entities/notification_params.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:breffini_staff/core/utils/image_constants.dart';
//
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // Initialize Firebase if not already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await PrefUtils().init();
      print("Firebase initialized successfully");
    } else {
      print("Firebase is already initialized");
    }

    // Initialize all required controllers
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(), permanent: true);
    }

    if (!Get.isRegistered<CallandChatController>()) {
      Get.put(CallandChatController(), permanent: true);
    }

    var payload = message.data;
    String type = payload.containsKey("type") ? payload['type'] : "";

    if (type == "new_call" || type == "new_live") {
      String callId = message.data.containsKey("id") ? message.data['id'] : "";

      // Ensure FirebaseUtils has access to initialized controllers
      await FirebaseUtils.listenCalls();

      if (message.data.containsKey('timestamp')) {
        // Parse the send time from the notification payload as UTC
        DateTime sendTime = DateTime.parse(message.data['timestamp']).toUtc();
        DateTime arrivalTime = DateTime.now().toUtc();
        int delayInSeconds = arrivalTime.difference(sendTime).inSeconds;

        if (delayInSeconds <= 50) {
          Get.put(CallandChatController()).listenIncomingCallNotification();
        }
      }
    }
  } catch (e, stackTrace) {
    print("Error in background message handler: $e");
    print("Stack trace: $stackTrace");
  }
}

@pragma(
    'vm:entry-point') // The @pragma('vm:entry-point') annotation in Flutter/Dart is used to mark a function or class as an entry point, ensuring that it is not removed during tree shaking or code stripping
Future<void> showCallkitIncoming(
    String callId,
    String callerName,
    String profileUrl,
    String callType,
    Map<String, dynamic> data,
    bool isMissedCall) async {
  String avatarUrl = Platform.isAndroid
      ? 'file:///android_asset/flutter_assets/assets/images/logo.jpg'
      : "";

  final params = CallKitParams(
    id: callId,
    nameCaller: callerName,
    appName: 'Breffni',
    avatar: avatarUrl,
    // avatar: !profileUrl.isNullOrEmpty() && profileUrl.startsWith("http")?
    // profileUrl:HttpUrls.imgBaseUrl+profileUrl,// duplicate dialog when image size is big
    handle: '0123456789',
    type: callType == "Video" ? 1 : 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',

    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: false,
      subtitle: 'Missed call',
      callbackText: '',
    ),
    extra: data,
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: true,
      isCustomSmallExNotification: true,
      isShowFullLockedScreen: true,
      isShowLogo: false,
      incomingCallNotificationChannelName: "high_importance_channel",
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: ImageConstant.breffniLogo,
      actionColor: '#4CAF50',
      textColor: '#ffffff',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  if (isMissedCall) {
    await FlutterCallkitIncoming.showMissCallNotification(params);
  } else {
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}

handleNotification(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    // Convert message.data from Map<String, dynamic> to Map<String, String?>
    final Map<String, String?> payload =
        message.data.map((key, value) => MapEntry(key, value.toString()));

    // Determine the channel key based on the payload
    String channelKey = ""; // Default channel

    if (payload['type'] == 'new_call') {
      channelKey = 'call_channel'; // Use the call channel
    } else
    // if (payload['type'] == 'new_message')
    {
      channelKey = 'message_channel'; // Use the message channel
    }
    String liveLink =
        message.data.containsKey("Live_Link") ? message.data['Live_Link'] : "";
    int id = message.data.containsKey("id")
        ? int.parse(message.data['id'])
        : message.hashCode;
    String sss = Get.currentRoute;
    // if(Get.put(CallandChatController()).currentCallModel.value.callId!=id.toString()) {// hide already started cales
    if (Get.currentRoute != "/IncomingCallPage") {
      // hide already started cales

      String callId = message.data.containsKey("id") ? message.data['id'] : "";
      String callerName = message.data.containsKey("Caller_Name")
          ? message.data['Caller_Name']
          : "";
      String callType = message.data.containsKey("call_type")
          ? message.data['call_type']
          : "";
      String profileImgUrl = message.data.containsKey("Profile_Photo_Img")
          ? message.data['Profile_Photo_Img']
          : "";

      if (channelKey == "call_channel") {
        //checking notification call id is current call id in server.(to handle delayed notification showing call screen)
        List<OnGoingCallsModel> callList =
            await Get.put(CallOngoingController()).getOngoingCallsApi();
        if (callList.isNotEmpty && callList[0].id.toString() == callId) {
          if (!callId.isNullOrEmpty()) {
            // to handle duplicate notification
            var calls = await FlutterCallkitIncoming.activeCalls();
            if (calls is List && calls.isNotEmpty && calls.isNotEmpty) {
              if (!calls.any((value) => value["id"].toString() == callId)) {
                showCallkitIncoming(callId, callerName, profileImgUrl, callType,
                    message.data, false);
              }
            } else {
              showCallkitIncoming(callId, callerName, profileImgUrl, callType,
                  message.data, false);
            }
          }
        } else {
          // remove all calls when no current call at server
          await FlutterCallkitIncoming.endAllCalls();
        }
      } else {
        // // Create the notification with the determined channel key
        // await AwesomeNotifications().createNotification(
        //   actionButtons: channelKey == "call_channel" ? [
        //     NotificationActionButton(
        //         key: 'reject_btn', label: 'Reject', color: Colors.red),
        //     NotificationActionButton(
        //         key: 'accept_btn', label: 'Accept', color: Colors.green),
        //   ] : [],
        //   content: NotificationContent(roundedLargeIcon: true,
        //       wakeUpScreen: true,
        //       id: id,
        //       channelKey: channelKey,
        //       title: message.notification?.title,
        //       body: message.notification?.body,
        //       payload: payload,
        //       largeIcon: HttpUrls.imgBaseUrl + profileImgUrl
        //
        //   ),
        // );
        if (channelKey == "call_channel") {
          // AwesomeNotifications().cancel(id);
        }
      }
    }
  }
}
//
// class NotificationService {
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   //-- Initialize Awesome Notifications
//   Future<void> initializePushNotification(RemoteMessage message) async {
//     // Handle incoming messages
//     if (message.data.isNotEmpty) {
//       handleNotification(message);
//
//     }
//     // Setup background message handling
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (message.data.isNotEmpty) {
//         handleNotification(message);
//
//       }
//     });
//   }
//
//   // static Future<void> backgroundHandler(RemoteMessage message) async {
//   //   log("Handling a background message: ${message.toString()}");
//   //   // Handle background notification with Awesome Notifications
//   //   await AwesomeNotifications().createNotification(
//   //     content: NotificationContent(
//   //       id: message.hashCode,
//   //       channelKey: 'default_channel',
//   //       title: message.notification?.title,
//   //       body: message.notification?.body,
//   //       payload:
//   //           message.data.map((key, value) => MapEntry(key, value.toString())),
//   //     ),
//   //   );
//   // }
//
//
//
//   //-- Local Notifications Services
//
//   Future<void> initializeLocalNotifications() async {
//     // AwesomeNotifications().initialize(
//     //   'resource://drawable/res_app_icon',
//     //   [
//     //     NotificationChannel(
//     //       channelKey: 'default_channel',
//     //       channelName: 'Default notifications',
//     //       channelDescription: 'Notification channel for basic notifications',
//     //       defaultColor: const Color(0xFF9D50DD),
//     //       ledColor: Colors.white,
//     //     ),
//     //   ],
//     // );
//     AwesomeNotifications().initialize(
//       'resource://drawable/res_app_icon',
//       [
//         NotificationChannel(
//           channelKey: 'message_channel',
//           channelName: 'Message notifications',
//           channelDescription: 'Notification channel for new messages',
//           defaultColor: Colors.teal,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//         ),
//         NotificationChannel(
//           channelKey: 'call_channel',
//           channelName: 'Call notifications',
//           channelDescription: 'Notification channel for new calls',
//           defaultColor: Colors.red,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//           soundSource: 'resource://raw/call_sound',
//         ),
//       ],
//     );
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: (ReceivedAction receivedAction) {
//         return NotificationController.onActionReceivedMethod(receivedAction);
//       },
//       onNotificationCreatedMethod: (ReceivedNotification receivedNotification) {
//         return NotificationController.onNotificationCreatedMethod(
//             receivedNotification);
//       },
//       onNotificationDisplayedMethod:
//           (ReceivedNotification receivedNotification) {
//         return NotificationController.onNotificationDisplayedMethod(
//             receivedNotification);
//       },
//       onDismissActionReceivedMethod: (ReceivedAction receivedAction) {
//         return NotificationController.onDismissActionReceivedMethod(
//             receivedAction);
//       },
//     );
//
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       handleNotification(message);
//
//     });
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if(null!=message) {
//         handleNotification(message);
//       }
//
//     });
//
//   }
//
//   // void getAllScheduledNotifications() async {
//   //   final chatController=Get.put<CallOngoingController>(CallOngoingController());
//   //
//   //   List<NotificationModel> scheduledNotifications = await AwesomeNotifications().listScheduledNotifications();
//   //
//   //   for (var notification in scheduledNotifications) {
//   //     if((!chatController.onGoingCallsList.any((object)=> object.id==notification.content?.id) &&
//   //     notification.content?.payload!['type']=="new_call")){
//   //       AwesomeNotifications().cancel(notification.content!.id!);
//   //     }
//   //   }
//   // }
//
// }
