class StudentChatHistoryModel {
  int? messageId;
  int teacherId;
  int studentId;
  String message;
  DateTime messageTimestamp;
  int? callId;
  DateTime? callStart;
  DateTime? callEnd;
  // int callDuration;
  String callType;
  String filePath;
  bool isStudent;

  StudentChatHistoryModel({
    required this.messageId,
    required this.teacherId,
    required this.studentId,
    required this.message,
    required this.messageTimestamp,
    required this.callId,
    required this.callStart,
    required this.callEnd,
    // required this.callDuration,
    required this.callType,
    required this.filePath,
    required this.isStudent,
  });

  factory StudentChatHistoryModel.fromMap(Map<String, dynamic> json) =>
      StudentChatHistoryModel(
        messageId: json["message_id"] ?? 0,
        teacherId: json["teacher_id"] ?? 0,
        studentId: json['student_id'] ?? 0,
        message: json['message'] ?? '',
        messageTimestamp: DateTime.parse(json["message_timestamp"]),
        callId: json['call_id'] ?? 0,
        callStart: json["call_start"] != null
            ? DateTime.parse(json["call_start"])
            : null,
        callEnd:
            json["call_end"] != null ? DateTime.parse(json["call_end"]) : null,
        // callDuration: json['call_duration'] ?? 0,
        callType: json['call_type'] ?? '',
        filePath: json['File_Path'] ?? '',
        isStudent: json['is_student'] == 0 ? false : true,
      );

  Map<String, dynamic> toMap() => {
        "message_id": messageId,
        "student_id": studentId,
        "teacher_id": teacherId,
        "message": message,
        "message_timestamp": messageTimestamp.toIso8601String(),
        "call_id": callId,
        "call_start": callStart!.toIso8601String(),
        "call_end": callEnd!.toIso8601String(),
        // "call_duration": callDuration,
        "call_type": callType,
        "File_Path": filePath,
        "is_student": isStudent,
      };
}
