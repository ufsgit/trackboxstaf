// import 'dart:developer';
// import 'dart:io';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import '../firebase_options.dart';
// import 'package:breffini_staff/view/pages/profile/profile_screen.dart';
//
// // class PushNotificationHelper {
// //   static String fcmToken = "";
//
// //   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
//
// //   static Future<void> initialized() async {
// //     await Firebase.initializeApp(
// //         options: DefaultFirebaseOptions.currentPlatform);
//
// //     if (Platform.isAndroid) {
// //       // Setup Android specific notification configurations
// //     } else if (Platform.isIOS) {
// //       FirebaseMessaging.instance.requestPermission();
// //     }
//
// //     FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//
// //     // Handle notifications when the app is opened from a terminated state
// //     FirebaseMessaging.instance.getInitialMessage().then((message) {
// //       if (message != null) {
// //         _handleNotificationClick(message);
// //       }
// //     });
//
// //     // Handle notifications when the app is in the foreground
// //     FirebaseMessaging.onMessage.listen((message) async {
// //       if (message.notification != null) {
// //         await flutterLocalNotificationsPlugin.show(
// //           message.hashCode,
// //           message.notification?.title,
// //           message.notification?.body,
// //           NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               'default_channel',
// //               'Default Notifications',
// //               channelDescription: 'Default channel for notifications',
// //               icon: "@mipmap/ic_launcher",
// //               importance: Importance.max,
// //               priority: Priority.max,
// //               playSound: true,
// //             ),
// //           ),
// //           payload: message.data.toString(), // Send payload for navigation
// //         );
// //       }
// //     });
//
// //     // Handle notifications when the app is opened from a background state
// //     FirebaseMessaging.onMessageOpenedApp.listen((message) {
// //       _handleNotificationClick(message);
// //     });
// //   }
//
// //   static Future<void> getDeviceTokenToSendNotifications() async {
// //     fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
// //     print('Device token: $fcmToken');
// //   }
//
// //   static void _handleNotificationClick(RemoteMessage message) {
// //     final Map<String, dynamic> data = message.data;
//
// //     // Handle navigation based on the payload data
// //     if (data['type'] == 'profile') {
// //       Get.to(() => ProfileScreen()); // Example: Navigate to ProfileScreen
// //     } else if (data['type'] == 'another_type') {
// //       // Navigate to another screen based on different type
// //     } else {
// //      Get.to(()=>ProfileScreen());
// //     }
// //   }
// // }
//
// // Future<void> backgroundHandler(RemoteMessage message) async {
// //   log("Handling background message: ${message.toString()}");
// //   // Optionally, you can include logic here to process data or notify the user
// //   PushNotificationHelper._handleNotificationClick(message);
// // }
//
// class PushNotificationHelper {
//   static String fcmToken = "";
//
//   static Future<void> initialized() async {
//     await Firebase.initializeApp();
//
//     AwesomeNotifications().initialize(
//       'resource://drawable/res_app_icon',
//       [
//         NotificationChannel(
//             channelKey: 'default_channel',
//             channelName: 'Default notifications',
//             channelDescription: 'Notification channel for basic notifications',
//             defaultColor: const Color(0xFF9D50DD),
//             ledColor: Colors.white,
//             soundSource: 'resource://raw/notification_sound')
//       ],
//     );
//
//     if (Platform.isIOS) {
//       FirebaseMessaging.instance.requestPermission();
//     }
//
//     FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//
//     getDeviceTokenToSendNotifications();
//
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         _handleNotificationClick(message);
//       }
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final notificationType = message.data['type'];
//       String soundSource;
//
//       if (notificationType == 'new_message') {
//         soundSource = 'resource://raw/notification_sound';
//       } else if (notificationType == 'new_call') {
//         soundSource = 'resource://raw/notification_call';
//       } else {
//         soundSource = 'resource://raw/default_sound';
//       }
//       final Map<String, String?> payload =
//           message.data.map((key, value) => MapEntry(key, value.toString()));
//
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: message.hashCode,
//             channelKey: 'default_channel',
//             title: message.notification?.title,
//             body: message.notification?.body,
//             payload: payload,
//             customSound: soundSource),
//       );
//
//       log('Notification data: ${message.data}');
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleNotificationClick(message);
//     });
//   }
//
//   static getDeviceTokenToSendNotifications() async {
//     fcmToken = FirebaseMessaging.instance.getAPNSToken().toString();
//     print('devicetoken: $fcmToken');
//   }
//
//   static void _handleNotificationClick(RemoteMessage message) {
//     if (message.data['type'] == 'new_message') {
//       Get.to(() => const ProfileScreen());
//     } else if (message.data['type'] == 'new_call') {
//       Get.to(() => const ProfileScreen());
//     }
//   }
// }
//
// class NotificationHelper {
//   static void displayNotification(RemoteMessage message) async {
//     try {
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: DateTime.now().millisecondsSinceEpoch ~/ 100,
//           channelKey: 'default_channel',
//           title: message.notification?.title,
//           body: message.notification?.body,
//           payload: message.data['type'],
//         ),
//       );
//       log('Firebase notification data: ${message.data}');
//     } catch (e) {
//       print(e);
//     }
//   }
// }
//
// Future<void> backgroundHandler(RemoteMessage message) async {
//   print('Background message data: ${message.data}');
//   print('Background message title: ${message.notification?.title}');
// }
