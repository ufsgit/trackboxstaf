import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:breffini_staff/controller/calls_page_controller.dart';

import 'package:breffini_staff/controller/ongoing_call_controller.dart';
import 'package:breffini_staff/controller/profile_controller.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/core/utils/file_utils.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/firebase_options.dart';

import 'package:breffini_staff/model/ongoing_call_model.dart';

import 'package:breffini_staff/view/pages/chats/chat_firebase_screen.dart';
import 'package:breffini_staff/view/pages/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming_yoer/entities/android_params.dart';

import 'package:flutter_callkit_incoming_yoer/entities/call_kit_params.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_callkit_incoming_yoer/entities/ios_params.dart';
import 'package:flutter_callkit_incoming_yoer/entities/notification_params.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:breffini_staff/core/utils/image_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ==============================================================================
// 1. BACKGROUND HANDLER (Pure Top-Level function)
// ==============================================================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // A. Initialize Firebase (Critical for background isolation)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await PrefUtils().init();
      print("DEBUG: Background Handler: Firebase initialized successfully");
    }

    // B. Handle CallKit Specifics
    // NOTE: We keep GetX dependency here only because the existing CallKit logic relies on it.
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(), permanent: true);
    }
    if (!Get.isRegistered<CallandChatController>()) {
      Get.put(CallandChatController(), permanent: true);
    }

    var payload = message.data;
    print("DEBUG: BACKGROUND MESSAGE PAYLOAD: $payload");

    String type = payload.containsKey("type") ? payload['type'] : "";

    if (type == "new_call" || type == "new_live") {
      // Original CallKit logic from user's code
      await FirebaseUtils.listenCalls();
      if (message.data.containsKey('timestamp')) {
        DateTime sendTime = DateTime.parse(message.data['timestamp']).toUtc();
        DateTime arrivalTime = DateTime.now().toUtc();
        int delayInSeconds = arrivalTime.difference(sendTime).inSeconds;

        if (delayInSeconds <= 50) {
          Get.put(CallandChatController()).listenIncomingCallNotification();
        }
      }
    } else if (type == "new_message" || type == "chat") {
      print("DEBUG: Chat message received in background payload: $payload");

      print("DEBUG: Forcing Local Notification for background message");
      NotificationService().showForegroundMessage(
        message.data['senderName'] ?? "New Message",
        message.data['message'] ?? "You have a new message",
        message.data,
      );
    } else {
      print("DEBUG: Background Message: ${message.messageId}");
    }
  } catch (e, stackTrace) {
    print("DEBUG: Error in background message handler: $e");
    print("DEBUG: Stack trace: $stackTrace");
  }
}

// ==============================================================================
// 2. CALLKIT HANDLERS
// ==============================================================================

@pragma('vm:entry-point')
Future<void> showCallkitIncoming(
    String callId,
    String callerName,
    String profileUrl,
    String callType,
    Map<String, dynamic> data,
    bool isMissedCall) async {
  String avatarUrl = Platform.isAndroid
      // ? 'file:///android_asset/flutter_assets/assets/images/logo.jpg' // Might cause issues if missing
      ? ""
      : "";

  final params = CallKitParams(
    id: callId,
    nameCaller: callerName,
    appName: 'Breffni',
    avatar: avatarUrl,
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
      incomingCallNotificationChannelName: "high_importance_channel_call",
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: ImageConstant.breffniLogo,
      actionColor: '#4CAF50',
      textColor: '#ffffff',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
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

Future<void> handleNotification(RemoteMessage message) async {
  // Original handleNotification logic maintained for CallKit compat
  if (message.data.isNotEmpty) {
    String channelKey = "";
    if (message.data['type'] == 'new_call') {
      channelKey = 'call_channel';
    } else {
      channelKey = 'message_channel';
    }

    if (Get.currentRoute != "/IncomingCallPage") {
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
        List<OnGoingCallsModel> callList =
            await Get.put(CallOngoingController()).getOngoingCallsApi();
        if (callList.isNotEmpty && callList[0].id.toString() == callId) {
          if (!callId.isNullOrEmpty()) {
            var calls = await FlutterCallkitIncoming.activeCalls();
            if (calls is List && calls.isNotEmpty) {
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
          await FlutterCallkitIncoming.endAllCalls();
        }
      }
    }
  }
}

// ==============================================================================
// 3. MAIN SERVICE CLASS
// ==============================================================================
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  // Channel details
  static const String defaultChannelId = 'high_importance_channel_v1';
  // Bumping channel ID to v3 to force fresh High Importance settings on Android
  static const String messageChannelId = 'message_channel_v4';
  static const String callChannelId = 'call_channel_v3';

  // Action IDs
  static const String replyActionId = 'REPLY_ACTION';

  Future<void> initialize() async {
    await _requestPermission();
    await _initLocalNotifications(); // Initialize plugin to create channel
    _configureForegroundOptions();
    _listenToForegroundMessages();

    _setupInteractedMessage();

    // DEBUG: Get and Print FCM Token
    String? token = await FirebaseMessaging.instance.getToken();
    print("DEBUG: FCM DEVICE TOKEN: $token");

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("DEBUG: FCM TOKEN REFRESHED: $newToken");
      // TODO: Send new token to backend if needed
    });
  }

  // Plugin Instance
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationTap(response.payload);
        }
      },
    );

    // Create the High Importance Channel used by FCM
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      messageChannelId, // 'message_channel_v3'
      'Message Notifications',
      description: 'Notifications for new chat messages',
      importance: Importance.max, // USER REQUIREMENT: IMPORTANCE_MAX
      playSound: true,
      enableVibration: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('DEBUG: User granted permission: ${settings.authorizationStatus}');
  }

  void _configureForegroundOptions() async {
    // For iOS: We enable alert/badge/sound for better user experience
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("DEBUG: FOREGROUND MESSAGE RECEIVED: ${message.messageId}");
      print("DEBUG: Message Data: ${message.data}");
      print("DEBUG: Message Notification: ${message.notification}");

      if (message.notification != null) {
        print(
            "DEBUG: FOREGROUND NOTIFICATION: Title=${message.notification!.title}, Body=${message.notification!.body}");
      } else {
        print("DEBUG: Message has no notification payload (Data Only)");
      }

      String? type = message.data['type']?.toString().toLowerCase().trim();
      print("DEBUG: Extracted Type: '$type'");

      if (type == 'new_call' || type == 'new_live') {
        print("DEBUG: Handling as NEW CALL");
        handleNotification(message);
      } else if (type == 'new_message' || type == 'chat') {
        print(
            "DEBUG: Handling as NEW MESSAGE - Attempting to show local notification");

        String title = message.notification?.title ??
            message.data['senderName'] ??
            'New Message';
        String body = message.notification?.body ??
            message.data['message'] ??
            'You have a new message';

        print(
            "DEBUG: Showing notification with Title: '$title', Body: '$body'");

        showForegroundMessage(
          title,
          body,
          message.data,
        );
      } else {
        print("DEBUG: Unknown type '$type' - No local notification triggered.");
        // Fallback: If it has a notification payload, maybe show it anyway?
        // For now, adhere to logic, but log it.
      }
    });
  }

  /// Public method to show foreground notification mainly for Socket.IO events
  void showForegroundMessage(
      String title, String body, Map<String, dynamic> data) async {
    // Check if we are already on the chat screen with this user to avoid spam
    // For now, we just show it.
    print("DEBUG: showForegroundMessage CALLED with title: $title");
    print("DEBUG: Channel ID: $messageChannelId");
    print("DEBUG: Details: Importance.max, Priority.high");

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      messageChannelId,
      'Message Notifications',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _flutterLocalNotificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: jsonEncode(data),
      );
      print("DEBUG: Local Notification SHOWN successfully");
    } catch (e) {
      print("DEBUG: ERROR showing local notification: $e");
    }
  }

  void _setupInteractedMessage() async {
    // 1. Terminated State (App opens from notification)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationTap(jsonEncode(initialMessage.data));
    }

    // 2. Background State (App comes to foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(jsonEncode(message.data));
    });
  }

  void _handleNotificationTap(String? payload) async {
    if (payload != null) {
      try {
        Map<String, dynamic> data = jsonDecode(payload);
        String? type = data['type'];

        print("DEBUG: Notification tapped with type: $type");
        print("DEBUG: Payload: $data");

        if (type == 'new_message' || type == 'chat') {
          // Navigate to specific chat screen
          String senderId = data['sender_id']?.toString() ??
              data['studentId']?.toString() ??
              data['id']?.toString() ??
              '';
          String senderName = data['senderName']?.toString() ??
              data['Caller_Name']?.toString() ??
              'Unknown';
          String profileUrl = data['profileUrl']?.toString() ??
              data['Profile_Photo_Img']?.toString() ??
              data['thumbUrl']?.toString() ??
              '';
          String courseId = data['course_id']?.toString() ?? '0';

          if (senderId.isNotEmpty) {
            print("DEBUG: Navigating to chat with student: $senderId");

            // Get userTypeId from SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            String userTypeId = prefs.getString('user_type_id') ?? '2';

            // Validate profileUrl
            String validatedProfileUrl =
                FileUtils.getFileExtension(profileUrl).isNullOrEmpty()
                    ? ""
                    : profileUrl;

            // Navigate
            Get.to(() => ChatFireBaseScreen(
                  isDeletedUser: false,
                  studentId: senderId,
                  profileUrl: validatedProfileUrl,
                  studentName: senderName,
                  contactDetails: "",
                  courseId: userTypeId == '2' ? '0' : '${courseId}Hod',
                  userType: userTypeId,
                ));
          } else {
            print("DEBUG: Missing sender ID, navigating to home");
            Get.to(() => HomePage());
          }
        } else if (type == 'new_call') {
          print("DEBUG: Call notification tapped");
          Get.to(() => HomePage());
        } else {
          Get.to(() => HomePage());
        }
      } catch (e) {
        print("DEBUG: Error parsing payload: $e");
        Get.to(() => HomePage());
      }
    }
  }

  Future<void> _handleReply(String? payload, String input) async {
    print("DEBUG: Direct Reply Input: $input");
    if (payload != null) {
      try {
        Map<String, dynamic> data = jsonDecode(payload);
        print("DEBUG: Sending reply for payload: $data");

        final prefs = await SharedPreferences.getInstance();

        String? studentId = data['studentId']?.toString() ??
            data['senderId']?.toString() ??
            data['id']?.toString();

        String? teacherId = prefs.getString('breffini_teacher_Id');
        if (teacherId == null || teacherId == "0") {
          teacherId = data['teacherId']?.toString();
        }

        if (studentId == null || teacherId == null) {
          print(
              "DEBUG: Error: Missing IDs. Student: $studentId, Teacher: $teacherId");
          return;
        }

        String senderName = prefs.getString('First_Name') ?? "Teacher";

        final messageData = {
          "studentId": studentId,
          "teacherId": teacherId,
          "chatMessage": input,
          "sentTime": DateTime.now().toUtc().toIso8601String(),
          "isStudent": false,
          "filePath": "",
          "fileSize": 0.0,
          "thumbUrl": "",
          "senderName": senderName,
        };

        String path = 'chats/$teacherId/students/$studentId/messages';
        await FirebaseFirestore.instance.collection(path).add(messageData);
        print("DEBUG: Reply sent to Firestore at $path");
      } catch (e) {
        print("DEBUG: Error handling reply: $e");
      }
    }
  }
}
