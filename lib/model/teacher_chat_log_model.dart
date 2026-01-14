class StudentChatLogModel {
  int studentId;
  String firstName;
  String lastName;
  String chatMessage;
  String profilePhotoPath;
  int unreadCount;
  DateTime sentTime;
  String filePath;
  int courseId;
  int deleteStatus;

  StudentChatLogModel({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.chatMessage,
    required this.profilePhotoPath,
    required this.unreadCount,
    required this.sentTime,
    required this.filePath,
    required this.courseId,
    required this.deleteStatus,
  });

  factory StudentChatLogModel.fromJson(Map<String, dynamic> json) =>
      StudentChatLogModel(
          studentId: json["student_id"] ?? 0,
          firstName: json['First_Name'] ?? '',
          lastName: json['Last_Name'] ?? '',
          chatMessage: json['message'],
          profilePhotoPath: json['Profile_Photo_Path'] ?? '',
          unreadCount: json['unread_count'] ?? 0,
          sentTime: DateTime.parse(json["timestamp"]),
          filePath: json['File_Path'] ?? '',
          deleteStatus: json["Delete_Status"] ?? 0,
          courseId: json["course_id"] ?? 0); //new

  Map<String, dynamic> toMap() => {
        "student_id": studentId,
        "First_Name": firstName,
        "Last_Name": firstName,
        "message": chatMessage,
        "Profile_Photo_Path": profilePhotoPath,
        "unread_count": unreadCount,
        "timestamp": sentTime.toIso8601String(),
        "File_Path": filePath,
        "course_id": courseId,
        "Delete_Status": deleteStatus,
      };
}
