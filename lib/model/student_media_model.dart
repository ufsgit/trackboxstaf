class StudentMediaModel {
  int isStudentSent;
  int teacherId;
  String teacherName;
  int studentId;
  String studentName;
  String message;
  String filePath;
  DateTime timestamp;

  StudentMediaModel({
    required this.isStudentSent,
    required this.teacherId,
    required this.teacherName,
    required this.studentId,
    required this.studentName,
    required this.message,
    required this.filePath,
    required this.timestamp,
  });

  factory StudentMediaModel.fromJson(Map<String, dynamic> json) =>
      StudentMediaModel(
        isStudentSent: json["Is_Student_Sent"],
        teacherId: json["Teacher_Id"],
        teacherName: json["Teacher_Name"],
        studentId: json["Student_Id"],
        studentName: json["Student_Name"],
        message: json["message"],
        filePath: json["File_Path"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "Is_Student_Sent": isStudentSent,
        "Teacher_Id": teacherId,
        "Teacher_Name": teacherName,
        "Student_Id": studentId,
        "Student_Name": studentName,
        "message": message,
        "File_Path": filePath,
        "timestamp": timestamp.toIso8601String(),
      };
}
