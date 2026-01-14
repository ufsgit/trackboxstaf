import 'dart:async';

import 'dart:developer';

import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/controller/ongoing_call_controller.dart';

import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/save_call_model.dart';
import 'package:breffini_staff/model/save_live_class_model.dart';
import 'package:breffini_staff/model/upcoming_live_model.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LiveClassController extends GetxController {
  var upComingLiveList = <UpcomingLiveModel>[].obs;
  CallOngoingController callOngoingController = Get.find();
  CallandChatController callChatController = Get.find();
  // Rx<bool> individualVideoCall = false.obs;
  RxBool isMicOn = true.obs;
  RxBool isVoiceMessage = false.obs;
  RxBool frontCamEnabled = true.obs;
  var userInfoList = <Map<String, dynamic>>[].obs;
  RxBool onButtonPop = false.obs;

  void popUpMenuButton(bool value) {
    onButtonPop.value = value;
  }

  void switchCamera(bool enable) {
    frontCamEnabled.value = enable;
    log('Camera switched to ${enable ? "front" : "back"}');
  }

  void viewLiveDetails() {
    log('View Live Details clicked');
    // Implement live details view logic here
  }

  Future<String> saveLiveClass(
      SaveLiveClassTeacher saveLiveClassTeacher) async {
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String();
    Map<String, dynamic> jsonData = {
      "LiveClass_ID": saveLiveClassTeacher.liveClassId,
      "Course_ID": saveLiveClassTeacher.courseId,
      "Teacher_ID": teacherId,
      "Batch_Id": saveLiveClassTeacher.batchId,
      "Scheduled_DateTime": formattedDate,
      "Duration": saveLiveClassTeacher.duration,
      "Start_Time": formattedDate,
      "Live_Link": saveLiveClassTeacher.liveLink,
      "Slot_Id": saveLiveClassTeacher.slotId,
      "Is_Finished": 0,
    };
    var response = await HttpRequest.httpPostBodyRequest(
        bodyData: jsonData,
        endPoint: HttpUrls.saveLiveClass,
        showLoader: true,
        dismissible: false);
    // update();
    if (response != null) {
      // print(response);
      // prefs.setString(
      //     'LiveClass_ID', response.data[0]['LiveClass_ID'].toString());
      // prefs.setString(
      //     'isLiveFinish', response.data[0]['Is_Finished'].toString());
      // print("course details datafs ${response.data[0]['LiveClass_ID']}");
      // print("course details datafs ${response.data[0]['LiveClass_ID']}");
      return response.data[0]['LiveClass_ID'].toString();
    } else {
      return "";
    }
  }

  saveIndividualStudentCall(SaveStudentCallModel saveStudentCallModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    log('<<<<<<<<<   SAVING INDIVIDUAL call>>>>>>>>>');
    String teacherId = preferences.getString('breffini_teacher_Id') ?? '';
    await HttpRequest.httpPostBodyRequest(
      endPoint: HttpUrls.saveStudentCall,
      bodyData: {
        "id": 0,
        "teacher_id": teacherId,
        "student_id": saveStudentCallModel.studentId,
        "call_start": DateTime.now().toString(),
        "call_end": saveStudentCallModel.callEnd,
        "call_duration": null,
        "call_type": saveStudentCallModel.callType,
        "Is_Student_Called": 0,
        "Live_Link": saveStudentCallModel.liveLink,
        "is_call_rejected": false,
      },
    ).then((value) {
      log('<<<<<<<<<   then saving value ${value?.data}>>>>>>>>>');
      if (value != null) {
        preferences.setString('id', value.data[0]['id'].toString());
        print('success');
        log('course details data ${value.data.toString()}');

        // Get.toNamed(AppRoutes.homePageContainerScreen);
      } else {
        print('not success');
        // Get.back();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text('Already enrolled')));
        // print(value!.statusCode);
      }
    });
  }

  // stopLive() async {
  //   log('<<<<<<<<<   stopping Live>>>>>>>>>');
  //   final prefs = await SharedPreferences.getInstance();
  //   final String liveId = prefs.getString('LiveClass_ID') ?? "0";
  //   log('<<<<<<<<<   liveID $liveId>>>>>>>>>');
  //
  //   // DateTime now = DateTime.now();
  //
  //   Map<String, dynamic> jsonData = {
  //     "id": liveId,
  //     "teacher_id": null,
  //     "student_id": null,
  //     "call_start": null,
  //     "call_end": DateTime.now().toString(),
  //     "call_duration": 0,
  //     "call_type": null,
  //     "Is_Student_Called": null,
  //     "Live_Link": null,
  //     "is_call_rejected": false,
  //
  //   };
  //   await HttpRequest.httpPostBodyRequest(
  //     bodyData: jsonData,
  //     endPoint: HttpUrls.saveStudentCall,
  //   ).then((response) {
  //     log('<<<<<<<<<   stopping Live Response ${response?.data}>>>>>>>>>');
  //     if (response != null) {
  //       print(response);
  //       log("Successful");
  //     } else {
  //       print("///////////////$response");
  //       log("Not Successful");
  //     }
  //   });
  //
  //   update();
  // }

  stopBatchLive(String callId,
      {required String courseId, required String batchId}) async {
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    // final String liveId = prefs.getString('LiveClass_ID') ?? "0";

    DateTime now = DateTime.now();

    Map<String, dynamic> jsonData = {
      "LiveClass_ID": callId,
      "End_Time": DateTime.now().toString(),
      "Course_ID": courseId,
      "Batch_Id": batchId,
      "Teacher_ID": teacherId,
      "Is_Finished": 1,
    };

    await HttpRequest.httpPostBodyRequest(
      bodyData: jsonData,
      endPoint: HttpUrls.saveLiveClass,
    ).then((response) async {
      if (response != null) {
        print(response);
        // prefs.setString(
        //     'isLiveFinish', response.data[0]['Is_Finished'].toString());

        print("Successful");

        callOngoingController.getCompletedClass();
      } else {
        print(response);
        print("Not Successful");
      }
    });
    update();
  }

  // stopCall(String callerId, String callId, {bool isRejectCall = false}) async {
  //   Map<String, dynamic> jsonData = {
  //     "id": callId,
  //     "teacher_id": PrefUtils().getTeacherId(),
  //     "student_id": callerId,
  //     "call_start": null,
  //     "call_end": DateTime.now().toString(),
  //     "call_duration": 0,
  //     "call_type": null,
  //     "Is_Student_Called": 0,
  //     "Live_Link": null,
  //     "is_call_rejected": isRejectCall,
  //   };
  //   await HttpRequest.httpPostBodyRequest(
  //     bodyData: jsonData,
  //     endPoint: HttpUrls.saveStudentCall,
  //   ).then((response) {
  //     if (response != null) {
  //       print(response);
  //
  //       print("Successful");
  //       // callOngoingController.getOngoingCalls();
  //     } else {
  //       print(response);
  //       print("Not Successful");
  //     }
  //   });
  //
  //   update();
  // }

  getUpcomingLive() async {
    await HttpRequest.httpGetRequest(
            endPoint: HttpUrls.upcomingLive, showLoader: false)
        .then((response) {
      if (response!.statusCode == 200) {
        upComingLiveList.clear();
        final responseData = response.data as List<dynamic>;
        final upcomingLive = responseData;

        upComingLiveList.value = upcomingLive
            .map((result) => UpcomingLiveModel.fromJson(result))
            .toList();
        print(upComingLiveList);
        print('Teacher course details loaded successfully');
      } else {
        throw Exception(
            'Failed to load teacher course data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
