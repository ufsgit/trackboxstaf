import 'dart:convert';

List<StudentChatModel> studentChatModelFromMap(String str) =>
    List<StudentChatModel>.from(
        json.decode(str).map((x) => StudentChatModel.fromMap(x)));

String studentChatModelToMap(List<StudentChatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class StudentChatModel {
  int studentId;
  int teacherId;
  String chatMessage;
  String sentTime;
  bool isStudent;
  String filePath;
  String chatType;
  int courseId;
  String? senderName,profileUrl;
  // List<String> filePaths;

  StudentChatModel(
      {required this.studentId,
      required this.teacherId,
      required this.chatMessage,
      required this.sentTime,
      required this.isStudent,
      required this.filePath,
      required this.chatType,
      required this.courseId,
      required this.senderName,
      required this.profileUrl,

      // required this.filePaths,
      });

  factory StudentChatModel.fromMap(Map<String, dynamic> json) =>
      StudentChatModel(
          studentId: json["studentId"],
          teacherId: json['teacherId'],
          chatMessage: json['message'],
          sentTime: json["sentTime"],
          isStudent: json['isStudent'],
          chatType: json['chatType'],
          // filePaths: List<String>.from(json["File_Paths"] ?? []),
          filePath: json['File_Path'],
          courseId: json["course_id"],
          senderName: json["senderName"],
        profileUrl: json["profileUrl"],
      );

  Map<String, dynamic> toMap() => {
        "studentId": studentId,
        "teacherId": teacherId,
        "message": chatMessage,
        "sentTime": sentTime,
        "isStudent": isStudent,
        'chatType': chatType,
        // "File_Paths": filePaths
        "File_Path": filePath,
        "course_id": courseId,
        "senderName": senderName,
        "profileUrl": profileUrl,
      };
}
