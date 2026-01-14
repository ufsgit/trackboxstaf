class StudentCallModel {
  DateTime messageDate;
  int teacherId;
  int studentId;
  DateTime messageTimestamp;
  int callId;
  DateTime callStart;
  DateTime callEnd;
  String callDuration;
  String callType;
  int isStudent;
  String teacherName;
  String studentName;
  String teacherProfile;
  String studentProfile;

  StudentCallModel({
    required this.messageDate,
    required this.teacherId,
    required this.studentId,
    required this.messageTimestamp,
    required this.callId,
    required this.callStart,
    required this.callEnd,
    required this.callDuration,
    required this.callType,
    required this.isStudent,
    required this.teacherName,
    required this.studentName,
    required this.teacherProfile,
    required this.studentProfile,
  });

  factory StudentCallModel.fromJson(Map<String, dynamic> json) =>
      StudentCallModel(
        messageDate: DateTime.parse(json["message_date"]),
        teacherId: json["teacher_id"],
        studentId: json["student_id"],
        messageTimestamp: DateTime.parse(json["message_timestamp"]),
        callId: json["call_id"],
        callStart: DateTime.parse(json["call_start"]),
        callEnd: DateTime.parse(json["call_end"]),
        callDuration: json["call_duration"],
        callType: json["call_type"],
        isStudent: json["is_student"],
        teacherName: json["Teacher_Name"],
        studentName: json["Student_Name"],
        teacherProfile: json["Teacher_Profile"],
        studentProfile: json["Student_Profile"],
      );

  Map<String, dynamic> toJson() => {
        "message_date":
            "${messageDate.year.toString().padLeft(4, '0')}-${messageDate.month.toString().padLeft(2, '0')}-${messageDate.day.toString().padLeft(2, '0')}",
        "teacher_id": teacherId,
        "student_id": studentId,
        "message_timestamp": messageTimestamp.toIso8601String(),
        "call_id": callId,
        "call_start": callStart.toIso8601String(),
        "call_end": callEnd.toIso8601String(),
        "call_duration": callDuration,
        "call_type": callType,
        "is_student": isStudent,
        "Teacher_Name": teacherName,
        "Student_Name": studentName,
        "Teacher_Profile": teacherProfile,
        "Student_Profile": studentProfile,
      };
}
