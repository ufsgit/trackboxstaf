import 'dart:async';
import 'dart:convert';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:breffini_staff/controller/individual_call_controller.dart';
import 'package:breffini_staff/controller/live_controller.dart';
import 'package:breffini_staff/core/utils/FirebaseCallModel.dart';
import 'package:breffini_staff/core/utils/common_utils.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/core/utils/key_center.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/http/notification_service.dart';
import 'package:breffini_staff/main.dart';
import 'package:breffini_staff/model/current_call_model.dart';
import 'package:breffini_staff/model/get_student_timeslot_model.dart';
import 'package:breffini_staff/model/student_course_model.dart';
import 'package:breffini_staff/model/student_list_model.dart';
import 'package:breffini_staff/model/teacher_calls_history_model.dart';
import 'package:breffini_staff/view/pages/calls/incoming_call_screen.dart';
import 'package:breffini_staff/view/pages/calls/widgets/google_meet.dart';
import 'package:breffini_staff/view/pages/calls/widgets/handle_new_call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_callkit_incoming_yoer/entities/call_event.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/scheduler.dart' as scheduler;

CallandChatController getCallChatController() {
  try {
    return Get.find<CallandChatController>();
  } catch (e) {
    return Get.put(CallandChatController());
  }
}

class CallandChatController extends GetxController {
  var callandChatList = <CallAndChatHistoryModel>[].obs;
  var getStudentTimeSlotsList = <GetStudentTimeSlotsModel>[].obs;
  var getStudentList = <StudentListModel>[].obs;
  var getStudentCourseList = <StudentListCourseModel>[].obs;
  final IndividualCallController controller =
      Get.put(IndividualCallController());

  RxString audioCallFormatedTime = "00:00".obs;
  RxBool isOneToOneLoading = false.obs;
  RxBool isStudentListLoading = false.obs;

  // RxInt currentCallId=0.obs;
  // RxString currentCallerName="".obs;
  // RxString currentCallerId="".obs;
  Rx<CurrentCallModel> currentCallModel = CurrentCallModel().obs;

  RxList<String> enteredUserList = <String>[].obs;

  //call timer
  Timer? _timer;
  RxInt _start = 0.obs;
  var isLoading = false.obs;

  // void getChatAndCallHistory(String type, String sender) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
  //   await HttpRequest.httpGetRequest(
  //     endPoint:
  //         '${HttpUrls.getCallsAndChatList}?type=$type&sender=$sender&teacherId=$teacherId',
  //   ).then((response) {
  //     if (response!.statusCode == 200) {
  //       final responseData = response.data;
  //       if (responseData is List<dynamic>) {
  //         final callandChatListDetails = responseData;
  //         callandChatList.value = callandChatListDetails
  //             .map((result) => CallAndChatHistoryModel.fromJson(result))
  //             .toList();
  //       } else if (responseData is Map<String, dynamic>) {
  //         final callandChatListDetails = [responseData];
  //         callandChatList.value = callandChatListDetails
  //             .map((result) => CallAndChatHistoryModel.fromJson(result))
  //             .toList();
  //       } else {
  //         throw Exception('Unexpected response data format');
  //       }
  //     } else {
  //       throw Exception('Failed to load profile data: ${response.statusCode}');
  //     }
  //   }).catchError((error) {
  //     print('Error fetching data: $error');
  //   });
  //
  //   update();
  // }

  Future<void> getStudentTimeSlots() async {
    isOneToOneLoading.value = true;

    try {
      final response = await HttpRequest.httpGetRequest(
        endPoint: HttpUrls.getStudentsTimeSlot,
        showLoader: false,
      );

      if (response?.statusCode == 200) {
        final responseData = response!.data;
        if (responseData is List<dynamic>) {
          final getTimeSlotsList = responseData;
          getStudentTimeSlotsList.value = getTimeSlotsList
              .map((result) => GetStudentTimeSlotsModel.fromJson(result))
              .toList();
        }
      } else {
        throw Exception('Failed to load profile data: ${response?.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      isOneToOneLoading.value = false;
    }
  }

  Future<void> getStudentLists(String batchId) async {
    try {
      isStudentListLoading.value = true;

      final response = await HttpRequest.httpGetRequest(
        endPoint: "${HttpUrls.getStudentsLists}/$batchId",
      );

      if (response == null) {
        throw Exception('Response is null');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is List<dynamic>) {
          getStudentList.value = responseData
              .map((result) => StudentListModel.fromJson(result))
              .toList();
        } else {
          throw Exception(
              'Unexpected response data type: ${responseData.runtimeType}');
        }
      } else {
        throw Exception('Failed to load profile data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      isStudentListLoading.value = false;
      update();
    }
  }

  getStudentListCourse(String courseId) async {
    await HttpRequest.httpGetRequest(
      endPoint: "${HttpUrls.getStudentCourseList}/$courseId",
    ).then((response) {
      if (response!.statusCode == 200) {
        final responseData = response.data;
        if (responseData is List<dynamic>) {
          final studentList = responseData;
          getStudentCourseList.value = studentList
              .map((result) => StudentListCourseModel.fromJson(result))
              .toList();
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }

  //call timer
  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer

    _start.value = 0; // Reset start time
    _updateTime(); // Update time immediately

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _start.value++;
      _updateTime();
    });
  }

  void stopTimer() {
    if (null != _timer) {
      _timer?.cancel();
    }
    _start.value = 0;
  }

  void _updateTime() {
    int minutes = (_start.value ~/ 60);
    int seconds = (_start.value % 60);
    audioCallFormatedTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    showCallNotification(
        audioCallFormatedTime.value, currentCallModel.value.isVideo ?? false);
  }

  Future<void> disconnectCall(bool clearNotification, bool isRejectCall,
      String studentId, String callId,
      {String newCallerId = ""}) async {
    int totalDuration = _start.value;

    enteredUserList.clear();
    if (!newCallerId.isNullOrEmpty() &&
        newCallerId == currentCallModel.value.callerId) {
      safeBack();
    } else {
      FirebaseUtils.deleteCall(studentId, "incoming screen");
    }

    //added clearing currentcallmodel befor api call to ensure call localy disconnected successfully
    currentCallModel.value = CurrentCallModel();

    // ZegoUIKit.instance.uninit();

    // if (ZegoUIKitPrebuiltCallController().minimize.isMinimizing) {
    //   ZegoUIKitPrebuiltCallController().minimize.hide();
    // }
    if (!callId.isNullOrEmpty()) {
      await Get.put(IndividualCallController()).stopCall(totalDuration,
          studentId: studentId, callId: callId, isRejectCall: isRejectCall);
    }

    // currentCallId.value = 0;
    audioCallFormatedTime.value = "00:00";
    // currentCallerName.value = "";
    // currentCallerId.value = "";
    stopTimer();

    if (clearNotification) {
      cancelNotification();
      // AwesomeNotifications().cancel(0);
    }
  }

  void showCallNotification(String timer, bool isVideoCall) async {
    // Show a notification to the user
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'audio_call_channel', isVideoCall ? "Video Call" : 'Audio Call',
            channelDescription:
                'Ongoing ' + (isVideoCall ? "video" : "voice") + ' call ',
            // importance: Importance.max,
            // priority: Priority.high,
            autoCancel: false,
            ongoing: true,
            silent: true,
            showWhen: false,
            category: AndroidNotificationCategory.call,
            enableVibration: timer == "",
            chronometerCountDown: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Ongoing ' + (isVideoCall ? "video call " : 'voice call ') + timer,
        'Tap to return to the call',
        platformChannelSpecifics,
        payload: jsonEncode(currentCallModel.value.toMap()));
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin
        .cancel(0); // Cancel notification with ID 0
  }

  // initNotification(String liveLink, String studentId, String callId,
  //     bool isVideo, String profileImageUrl, String studentName) async {
  //   var androidInitializationSettings =
  //       const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iosInitializationSettings = const DarwinInitializationSettings();
  //
  //   var initializationSetting = InitializationSettings(
  //       android: androidInitializationSettings, iOS: iosInitializationSettings);
  //
  //   await flutterLocalNotificationsPlugin.initialize(initializationSetting,
  //       onDidReceiveNotificationResponse: (response) {
  //     Map<String, dynamic> payLoad = {};
  //     // if (!response.payload.isNullOrEmpty()) {
  //     //   payLoad = jsonDecode(response.payload!);
  //     // }
  //     // handleNotificationClick(payLoad);
  //     print("onBackgroundMessage: ");
  //     // handle interaction when app is active for android
  //     // handleMessage(message,context);
  //     if (!Get.currentRoute.isNullOrEmpty() &&
  //         Get.currentRoute != "/IncomingCallPage") {
  //       Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(
  //             builder: (context) => IncomingCallPage(
  //                   liveLink: liveLink,
  //                   studentId: studentId.toString(),
  //                   callId: callId,
  //                   video: isVideo,
  //                   // isIncomingCall: true,
  //                   profileImageUrl: profileImageUrl,
  //                   studentName: studentName,
  //                 )),
  //       );
  //     }
  //   });
  // }

  listenIncomingCallNotification() {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      var payload = event?.body["extra"];
      switch (event!.event) {
        case Event.actionCallIncoming:
          break;
        case Event.actionCallStart:
          break;
        case Event.actionCallAccept:
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            String liveLink = payload!['Live_Link'] ?? '';
            if (!liveLink.isNullOrEmpty()) {
              // String callId = payload!['id'] ?? '';
              // String callType = payload!['call_type'] ?? '';
              // String callerId = (payload!['sender_id'] ?? "0");
              // String profileImgUrl = payload!.containsKey("Profile_Photo_Img")
              //     ? payload!['Profile_Photo_Img'] ?? ""
              //     : "";
              // String callerName = payload!.containsKey("Caller_Name")
              //     ? payload!['Caller_Name'] ?? ""
              //     : "";

              int studentId = int.parse(payload!['student_id'] ?? "0");
              String callId = payload!['id'] ?? '';
              String callType = payload!['call_type'] ?? '';
              String profileImgUrl = payload!.containsKey("profile_url")
                  ? payload!['profile_url'] ?? ""
                  : "";
              String callerName = payload!.containsKey("student_name")
                  ? payload!['student_name'] ?? ""
                  : "";

              CallandChatController callChatController = Get.find();
              final LiveClassController liveClassController =
                  Get.put(LiveClassController());

              if (null != callChatController.currentCallModel.value.type &&
                  callChatController.currentCallModel.value.type ==
                      "new_live") {
                await liveClassController.stopBatchLive(
                    callChatController.currentCallModel.value.callId ?? "",
                    batchId:
                        callChatController.currentCallModel.value.batchId ?? "",
                    courseId:
                        callChatController.currentCallModel.value.courseId ??
                            "");

                callChatController.currentCallModel.value = CurrentCallModel();
                safeBack();
              } else {
                if (!callChatController.currentCallModel.value.callId
                    .isNullOrEmpty()) {
                  await callChatController.disconnectCall(
                      true,
                      false,
                      callChatController.currentCallModel.value.callerId
                          .toString(),
                      callChatController.currentCallModel.value.callId ?? "",
                      newCallerId: studentId.toString());
                }
              }

              await handleCall(
                studentId: studentId.toString(),
                studentName: callerName,
                callId: callId,
                isVideo: true,
                profileImageUrl: profileImgUrl,
                liveLink: liveLink,
                controller: controller,
                callandChatController: callChatController,
                safeBack: safeBack,
              );

              await Future.delayed(const Duration(seconds: 1), () {
                MeetCallTracker(
                  onCallEnded: () {},
                ).startMeetCall(meetCode: liveLink);
              });

              // Get.to(() => IncomingCallPage(
              //       liveLink: liveLink,
              //       callId: callId,
              //       video: callType == 'Video',
              //       studentId: callerId,
              //       // isIncomingCall: true,
              //       profileImageUrl: profileImgUrl,
              //       studentName: callerName,
              //     ));
            }
          });
          break;
        case Event.actionCallDecline:
          String liveLink = payload!['Live_Link'] ?? '';
          if (!liveLink.isNullOrEmpty()) {
            String callId = payload!['id'] ?? '';
            // String callType=receivedAction.payload!['call_type']??'';
            // String callerId = (payload!['sender_id'] ?? "0");
            // int studentId = int.parse(payload!['student_id'] ?? "0");
            int studentId = int.parse(payload!['student_id'] ?? "0");

            FirebaseUtils.deleteCall(studentId.toString(), "reject");

            await Get.put(IndividualCallController()).stopCall(0,
                studentId: studentId.toString(),
                callId: callId,
                isRejectCall: true);
          }
          break;
        case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
          break;
        case Event.actionCallTimeout:
          // TODO: missed an incoming call
          break;
        case Event.actionCallCallback:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.actionCallToggleHold:
          // TODO: only iOS
          break;
        case Event.actionCallToggleMute:
          // TODO: only iOS
          break;
        case Event.actionCallToggleDmtf:
          // TODO: only iOS
          break;
        case Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
          // TODO: only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: only iOS
          break;
        case Event.actionCallCustom:
          // TODO: for custom action
          break;
      }
    });
  }
}
