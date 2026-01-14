class GetStudentTimeSlotsModel {
  String firstName;
  String lastName;
  int courseId;
  String courseName;
  String startTime;
  String endTime;
  int studentId;
  String imageUrl;

  GetStudentTimeSlotsModel(
      {required this.firstName,
      required this.lastName,
      required this.courseId,
      required this.courseName,
      required this.startTime,
      required this.endTime,
      required this.studentId,
      required this.imageUrl});

  factory GetStudentTimeSlotsModel.fromJson(Map<String, dynamic> json) =>
      GetStudentTimeSlotsModel(
        firstName: json["First_Name"] ?? '',
        lastName: json["Last_Name"] ?? '',
        courseId: json["Course_ID"],
        courseName: json["Course_Name"],
        imageUrl: json["Profile_Photo_Path"] ?? '',
        startTime: json["start_time"] ?? '',
        endTime: json["end_time"] ?? '',
        studentId: json["Student_ID"],
      );

  Map<String, dynamic> toJson() => {
        "First_Name": firstName,
        "Last_Name": lastName,
        "Course_ID": courseId,
        "Profile_Photo_Path": imageUrl,
        "Course_Name": courseName,
        "start_time": startTime,
        "end_time": endTime,
        "Student_ID": studentId,
      };
}
