import 'dart:async';

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
import 'package:breffini_staff/core/utils/file_utils.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/firebase_options.dart';
import 'package:breffini_staff/http/chat_socket.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/ongoing_call_model.dart';
import 'package:breffini_staff/view/pages/calls/incoming_call_screen.dart';
import 'package:breffini_staff/view/pages/chats/chat_firebase_screen.dart';
import 'package:breffini_staff/view/pages/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
    // In a pure clean architecture, we would avoid GetX in background isolates.
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(), permanent: true);
    }
    if (!Get.isRegistered<CallandChatController>()) {
      Get.put(CallandChatController(), permanent: true);
    }

    var payload = message.data;
    print("DEBUG: BACKGROUND MESSAGE PAYLOAD: $payload");
    if (message.notification != null) {
      print(
          "DEBUG: BACKGROUND NOTIFICATION: Title=${message.notification!.title}, Body=${message.notification!.body}");
    }
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
      // Chat Message Handling
      // OS automatically shows the notification from 'notification' payload
      // We just log it here for debugging
      print("DEBUG: Chat message received in background");
      print(
          "DEBUG: Sender: ${payload['senderName'] ?? payload['Caller_Name'] ?? 'Unknown'}");
      print("DEBUG: Message ID: ${message.messageId}");
      // Optional: Update local database, increment badge count, etc.
    } else {
      // C. Other Notification Types
      // Android automatically shows the notification if "notification" payload exists.
      print("DEBUG: Background Message: ${message.messageId}");
      print("DEBUG: Type: $type");
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
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('DEBUG: notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print(
        'DEBUG: notification action tapped with input: ${notificationResponse.input}');
  }
}

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
        // ... (Original logic to check ongoing calls) ...
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

// ==============================================================================
// 3. MAIN SERVICE CLASS
// ==============================================================================
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Channel details - Versioned to force update on Android
  static const String defaultChannelId = 'high_importance_channel_v1';
  static const String messageChannelId = 'message_channel_v2';
  static const String callChannelId = 'call_channel_v2';

  // Action IDs
  static const String replyActionId = 'REPLY_ACTION';

  Future<void> initialize() async {
    await _requestPermission();
    await _initializeLocalNotifications();
    await _createNotificationChannels(); // Critical: Create channels before use
    _configureForegroundOptions();
    _listenToForegroundMessages();
    _setupInteractedMessage();
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

  Future<void> _initializeLocalNotifications() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('DEBUG: Notification clicked with payload: ${response.payload}');

        // Handle Direct Reply Input
        if (response.actionId == replyActionId && response.input != null) {
          _handleReply(response.payload, response.input!);
        }

        _handleNotificationTap(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> _createNotificationChannels() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) return;

    // 1. Default Channel (High Importance, Default Sound)
    const AndroidNotificationChannel defaultChannel =
        AndroidNotificationChannel(
      defaultChannelId,
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
      playSound: true,
    );

    // 2. Message Channel (Custom Sound if available, else default)
    const AndroidNotificationChannel messageChannel =
        AndroidNotificationChannel(
      messageChannelId,
      'Message Notifications',
      description: 'Notifications for new chat messages',
      importance: Importance.max,
      playSound: true,
    );

    // 3. Call Channel (Custom Sound)
    const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
      callChannelId,
      'Call Notifications',
      description: 'Incoming call notifications',
      importance: Importance.max,
      playSound: true,
    );

    await androidImplementation.createNotificationChannel(defaultChannel);
    await androidImplementation.createNotificationChannel(messageChannel);
    await androidImplementation.createNotificationChannel(callChannel);
  }

  void _configureForegroundOptions() async {
    // This controls how FCM handles the "notification" payload while app is in foreground.
    // For Android: We set to false and manually show via flutter_local_notifications for better control
    // For iOS: We enable alert/badge/sound for better user experience
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // iOS will show banner in foreground
      badge: true, // iOS will update badge count
      sound: true, // iOS will play sound
    );
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("DEBUG: FOREGROUND MESSAGE RECEIVED: ${message.messageId}");
      print("DEBUG: FOREGROUND PAYLOAD: ${message.data}");
      if (message.notification != null) {
        print(
            "DEBUG: FOREGROUND NOTIFICATION: Title=${message.notification!.title}, Body=${message.notification!.body}");
      }

      String? type = message.data['type'];

      if (type == 'new_call' || type == 'new_live') {
        // Special handling for Calls (CallKit)
        handleNotification(message);
      } else {
        // For Chat or General Messages
        RemoteNotification? notification = message.notification;

        // If the payload has a 'notification' object, show a local heads-up notification.
        // Or if it's a data-only payload that we want to turn into a notification.
        if (notification != null) {
          showLocalNotification(message);
        } else if (message.data.containsKey('title') ||
            message.data.containsKey('body')) {
          // Data-only fallback
          showLocalNotification(message);
        }
      }
    });
  }

  void _handleReply(String? payload, String input) async {
    print("DEBUG: Direct Reply Input: $input");
    if (payload != null) {
      try {
        Map<String, dynamic> data = jsonDecode(payload);
        print("DEBUG: Sending reply for payload: $data");

        final prefs = await SharedPreferences.getInstance();

        // 1. Identifier logic for STAFF App
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

  Future<String?> _downloadAndSaveFile(String url, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final http.Response response = await http.get(Uri.parse(url));
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      print("DEBUG: Error downloading file: $e");
      return null;
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    String title = notification?.title ??
        message.data['title'] ??
        message.data['Caller_Name'] ??
        'New Message';
    String body = notification?.body ??
        message.data['body'] ??
        message.data['message'] ??
        'You have a new message';

    // Use a hashcode or unique ID
    int id = message.messageId.hashCode;
    if (message.data.containsKey('id')) {
      try {
        id = int.parse(message.data['id'].toString());
      } catch (e) {}
    }

    String type = message.data['type'] ?? '';
    if (message.data.containsKey('teacherId')) type = 'new_message';

    String channelIdToUse = defaultChannelId;
    String channelNameToUse = 'High Importance Notifications';
    AndroidNotificationSound? soundToUse;
    StyleInformation? styleInformation;

    // Actions List
    List<AndroidNotificationAction>? actions;

    if (type == 'new_message' || type == 'chat') {
      channelIdToUse = messageChannelId;
      channelNameToUse = 'Message Notifications';

      // Use MessagingStyle for chat
      Person? sender;
      String? profileUrl = message.data['Profile_Photo_Img'] ??
          message.data['sender_avatar'] ??
          message.data['thumbUrl'];

      if (profileUrl != null && profileUrl.isNotEmpty) {
        final String? largeIconPath = await _downloadAndSaveFile(
            HttpUrls.imgBaseUrl + profileUrl, 'largeIcon');
        if (largeIconPath != null) {
          sender = Person(
            name: title,
            key: message.data['senderId']?.toString() ?? "0",
            icon: BitmapFilePathAndroidIcon(largeIconPath),
          );
        }
      }

      sender ??= Person(
        name: title,
        key: message.data['senderId']?.toString() ?? "0",
      );

      final Message chatMessage = Message(
        body,
        DateTime.now(),
        sender,
      );

      styleInformation = MessagingStyleInformation(
        sender,
        groupConversation: false,
        messages: [chatMessage],
      );

      actions = [
        const AndroidNotificationAction(
          replyActionId,
          'Reply',
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              label: 'Type a message...',
            ),
          ],
        ),
      ];
    } else if (type == 'new_call') {
      channelIdToUse = callChannelId;
      channelNameToUse = 'Call Notifications';
    }

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelIdToUse,
          channelNameToUse,
          channelDescription: 'Notification',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          sound: soundToUse,
          actions: actions,
          styleInformation: styleInformation,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
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

            // Get userTypeId from SharedPreferences (same as home_screen.dart)
            final prefs = await SharedPreferences.getInstance();
            String userTypeId = prefs.getString('user_type_id') ?? '2';

            // Validate profileUrl using FileUtils (same as home_screen.dart)
            String validatedProfileUrl =
                FileUtils.getFileExtension(profileUrl).isNullOrEmpty()
                    ? ""
                    : profileUrl;

            // Navigate using the same pattern as home_screen.dart handleNotificationClick
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
          // Navigate to calls page
          print("DEBUG: Call notification tapped");
          Get.to(() => HomePage());
        } else {
          // Default navigation
          Get.to(() => HomePage());
        }
      } catch (e) {
        print("DEBUG: Error parsing payload: $e");
        // Fallback navigation
        Get.to(() => HomePage());
      }
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      messageChannelId,
      'Message Notifications',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      actions: [
        AndroidNotificationAction(
          replyActionId,
          'Reply',
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              label: 'Type a message...',
            ),
          ],
        ),
      ],
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
