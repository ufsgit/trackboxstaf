import 'package:breffini_staff/model/student_chat_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  List<StudentChatHistoryModel> chatHistoryList = [];
  Map<String, List<StudentChatHistoryModel>> chatHistoryListMap = {};

  // void chatHistoryBackup(List<dynamic> chatHistory) {
  //   chatHistoryList = chatHistory
  //       .map((chat) => StudentChatHistoryModel.fromMap(chat))
  //       .toList();
  //   print('Chat history updated: $chatHistoryList');
  //   update();
  // }

  // void addMessage(StudentChatHistoryModel chatMessage) {
  //   chatHistoryList.add(chatMessage);
  //   print('Message added: $chatMessage');
  //   update();
  // }

  @override
  void onClose() {
    super.onClose();
    messageController.dispose();
  }
}
