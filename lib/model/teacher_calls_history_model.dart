class CallAndChatHistoryModel {
  int id;
  int teacherId;
  int studentId;
  DateTime callStart;
  DateTime callEnd;
  String callDuration;
  String callType;
  int isStudentCalled;
  String liveLink;
  bool isRinged;
  bool isConnected;
  bool isFinished;
  bool isRejected;
  String profilePhotoPath;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;

  int deleteStatus;

  CallAndChatHistoryModel({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.callStart,
    required this.callEnd,
    required this.callDuration,
    required this.callType,
    required this.isStudentCalled,
    required this.liveLink,
    required this.isRinged,
    required this.isConnected,
    required this.isFinished,
    required this.isRejected,
    required this.profilePhotoPath,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.deleteStatus,
  });

  factory CallAndChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      CallAndChatHistoryModel(
          id: json["id"],
          teacherId: json["teacher_id"],
          studentId: json["student_id"],
          callStart: DateTime.parse(json["call_start"]),
          callEnd: DateTime.parse(json["call_end"]),
          callDuration: json["call_duration"] ?? '0.0',
          callType: json["call_type"],
          isStudentCalled: json["Is_Student_Called"],
          liveLink: json["Live_Link"],
          isRinged: json["Call_Ringed"] == 1 ? true : false,
          isConnected: json["Call_Connected"] == 1 ? true : false,
          isFinished: json["Is_Finished"] == 1 ? true : false,
          isRejected: json["Call_Rejected"] == 1 ? true : false,
          profilePhotoPath: json["Profile_Photo_Path"] ?? '',
          firstName: json["First_Name"] ?? '',
          lastName: json["Last_Name"] ?? '',
          deleteStatus: json["Delete_Status"],
          email: json["Email"] ?? '',
          phoneNumber: json["Phone_Number"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
        "student_id": studentId,
        "call_start": callStart.toIso8601String(),
        "call_end": callEnd.toIso8601String(),
        "call_duration": callDuration,
        "call_type": callType,
        "Is_Student_Called": isStudentCalled,
        "Live_Link": liveLink,
        "Call_Ringed": isRinged,
        "Call_Connected": isConnected,
        "Is_Finished": isFinished,
        "Call_Rejected": isRejected,
        "Profile_Photo_Path": profilePhotoPath,
        "First_Name": firstName,
        "Delete_Status": deleteStatus,
        "Email": email,
        "Phone_Number": phoneNumber,
        "Last_Name": lastName
      };
}
