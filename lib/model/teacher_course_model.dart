// To parse this JSON data, do
//
//     final teacherCourseModel = teacherCourseModelFromJson(jsonString);

import 'dart:convert';

List<TeacherCourseModel> teacherCourseModelFromJson(String str) =>
    List<TeacherCourseModel>.from(
        json.decode(str).map((x) => TeacherCourseModel.fromJson(x)));

String teacherCourseModelToJson(List<TeacherCourseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TeacherCourseModel {
  int courseTeacherId;
  int courseId;
  String courseName;
  int batchId;
  String batchName;

  TeacherCourseModel({
    required this.courseTeacherId,
    required this.courseId,
    required this.courseName,
    required this.batchId,
    required this.batchName,
  });

  factory TeacherCourseModel.fromJson(Map<String, dynamic> json) =>
      TeacherCourseModel(
        courseTeacherId: json["CourseTeacher_ID"],
        courseId: json["Course_ID"],
        courseName: json["Course_Name"],
        batchId: json["Batch_ID"],
        batchName: json["Batch_Name"],
      );

  Map<String, dynamic> toJson() => {
        "CourseTeacher_ID": courseTeacherId,
        "Course_ID": courseId,
        "Course_Name": courseName,
        "Batch_ID": batchId,
        "Batch_Name": batchName,
      };
}
