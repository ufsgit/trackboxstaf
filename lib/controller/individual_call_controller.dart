import 'dart:developer';

import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/get_completed_model.dart';
import 'package:breffini_staff/model/ongoing_call_model.dart';
import 'package:breffini_staff/model/save_call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndividualCallController extends GetxController {
  Future<String> saveStudentCall(
      SaveStudentCallModel saveStudentCallModel) async {
    final prefs = await SharedPreferences.getInstance();
    // final String liveId = prefs.getString('id') ?? "0";
    String teacherId = prefs.getString('breffini_teacher_Id') ?? '';

    var response = await HttpRequest.httpPostBodyRequest(
      endPoint: HttpUrls.saveStudentCall,
      showLoader: true,
      dismissible: false,
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
    );
    if (response != null) {
      // preferences.setString('id', response.data[0]['id'].toString());
      // print('success');
      // log('course details data $value');

      // Get.toNamed(AppRoutes.homePageContainerScreen);
      String id = response.data[0]['id'].toString();

      return id;
    } else {
      return "";
      // Get.back();
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Already enrolled')));
      // print(value!.statusCode);
    }
  }

  Future<void> updateCallStatusAccept(String callId) async {
    var response = await HttpRequest.httpGetRequest(
      endPoint: HttpUrls.Update_Call_Status_Accept + callId,
    );
    if (response != null) {
      // return response.data['id'].toString();
    } else {
      // return "";
    }
  }

  Future<void> updateCallStatusFailed(String callId) async {
    var response = await HttpRequest.httpGetRequest(
      endPoint: HttpUrls.Update_Call_Status_Failed + callId,
    );
    if (response != null) {
      // return response.data['id'].toString();
    } else {
      // return "";
    }
  }

  Future<String?> checkCallAvailability(String userId) async {
    var response = await HttpRequest.httpGetRequest(
      endPoint: HttpUrls.checkCallAvailability +
          "/?user_Id=" +
          userId +
          "&is_Student_Calling=0",
    );

    if (response!.statusCode == 200) {
      if (response.data is List<dynamic>) {
        bool isBusy = response.data[0]["is_busy"] == 1;
        return isBusy ? response.data[0]["message"] : "";
      }
    }
    return null;
  }

  stopCall(int totalDuration,
      {required String studentId,
      required String callId,
      bool isRejectCall = false}) async {
    final prefs = await SharedPreferences.getInstance();
    // final String liveId = prefs.getString('id') ?? "0";
    String teacherId = prefs.getString('breffini_teacher_Id') ?? '';

    // String teacherId = PrefUtils().getTeacherId();
    // DateTime now = DateTime.now();

    Map<String, dynamic> jsonData = {
      "id": callId,
      "teacher_id": teacherId,
      "student_id": studentId,
      "call_start": null,
      "call_end": DateTime.now().toString(),
      "call_duration": totalDuration,
      "call_type": null,
      "Is_Student_Called": 0,
      "Live_Link": null,
      "is_call_rejected": isRejectCall,
    };
    await HttpRequest.httpPostBodyRequest(
      bodyData: jsonData,
      endPoint: HttpUrls.saveStudentCall,
      showLoader: false,
    ).then((response) {
      if (response != null) {
        // print(response);
        // print("Successful");
        // Future.delayed(const Duration(seconds: 1), () {
        //   callandChatController.getChatAndCallHistory('call', 'teacher');
        // });
      } else {
        // print(response);
        // print("Not Successful");
      }
    });

    update();
  }
}
