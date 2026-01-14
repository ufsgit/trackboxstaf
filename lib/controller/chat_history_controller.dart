import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/chat_history_model.dart';
import 'package:breffini_staff/model/student_chat_history_model.dart';
import 'package:breffini_staff/model/teacher_calls_history_model.dart';
import 'package:breffini_staff/model/teacher_chat_log_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryController extends GetxController {
  TextEditingController messageController = TextEditingController();

  var callandChatList = <CallAndChatHistoryModel>[].obs;
  var studentChatLogList = <StudentChatLogModel>[].obs;
  void getChatAndCallHistory(String type, String sender) async {
    // getStudentChatLog();
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    await HttpRequest.httpGetRequest(
      showLoader: false,
      endPoint:
          '${HttpUrls.getCallsAndChatList}?type=$type&sender=$sender&teacherId=$teacherId',
    ).then((response) {
      if (response!.statusCode == 200) {
        final responseData = response.data;
        if (responseData is List<dynamic>) {
          final callandChatListDetails = responseData;
          callandChatList.value = callandChatListDetails
              .map((result) => CallAndChatHistoryModel.fromJson(result))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          final callandChatListDetails = [responseData];
          callandChatList.value = callandChatListDetails
              .map((result) => CallAndChatHistoryModel.fromJson(result))
              .toList();
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        throw Exception('Failed to load profile data: ${response!.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }

  getStudentChatLog() async {
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    // studentChatLogList.clear();
    await HttpRequest.httpGetRequest(
      endPoint: '${HttpUrls.getTeacherChatLog}$teacherId',
    ).then((value) {
      List data = value!.data;
      print('student chat log details/////// $value');

      studentChatLogList.value =
          data.map((e) => StudentChatLogModel.fromJson(e)).toList();
    });

    update();
  }
}
