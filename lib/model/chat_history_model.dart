class ChatHistoryModel {
  int studentId;
  String firstName;
  String lastName;
  String message;
  DateTime timestamp;
  String profilePath;
  int unreadCount;
  String filePath;

  ChatHistoryModel({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.message,
    required this.timestamp,
    required this.profilePath,
    required this.unreadCount,
    required this.filePath,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      ChatHistoryModel(
        studentId: json["student_id"],
        firstName: json["First_Name"],
        lastName: json['Last_Name'],
        message: json["message"],
        timestamp: DateTime.parse(json["timestamp"]),
        profilePath: json["Profile_Photo_Path"],
        unreadCount: json["unread_count"] ?? 0,
        filePath: json['File_Path'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "First_Name": firstName,
        "Last_Name": firstName,
        "message": message,
        "timestamp": timestamp.toIso8601String(),
        "Profile_Photo_Path": profilePath,
        "unread_count": unreadCount,
        "File_Path": filePath,
      };
}
