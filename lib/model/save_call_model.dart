class SaveStudentCallModel {
  int id;
  int teacherId;
  int studentId;
  DateTime callStart;
  String callEnd;
  dynamic callDuration;
  String callType;
  int isStudentCalled;
  String liveLink;
  String studentName;
  String profileUrl;

  SaveStudentCallModel({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.callStart,
    required this.callEnd,
    required this.callDuration,
    required this.callType,
    required this.isStudentCalled,
    required this.liveLink,
    required this.studentName,
    required this.profileUrl,
  });

  factory SaveStudentCallModel.fromJson(Map<String, dynamic> json) =>
      SaveStudentCallModel(
        id: json["id"],
        teacherId: json["teacher_id"],
        studentId: json["student_id"],
        studentName: json["student_name"],
        callStart: DateTime.parse(json["call_start"]),
        callEnd: json["call_end"],
        callDuration: json["call_duration"],
        callType: json["call_type"],
        isStudentCalled: json["Is_Student_Called"],
        liveLink: json["Live_Link"],
        profileUrl: json["profile_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
        "student_id": studentId,
        "call_start": callStart.toIso8601String(),
        "call_end": callEnd,
        "call_duration": callDuration,
        "call_type": callType,
        "Is_Student_Called": isStudentCalled,
        "Live_Link": liveLink,
        "profile_url": profileUrl,
      };
}
