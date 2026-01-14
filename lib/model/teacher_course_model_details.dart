class TeacherCourseModelDetails {
  int courseTeacherId;
  int courseId;
  String courseName;
  String batchIDs;
  String batchNames;
  String slotIds;
  String startTimes;
  String endTimes;
  String thumbnailPath;

  TeacherCourseModelDetails({
    required this.courseTeacherId,
    required this.courseId,
    required this.courseName,
    required this.batchIDs,
    required this.batchNames,
    required this.slotIds,
    required this.startTimes,
    required this.endTimes,
    required this.thumbnailPath,
  });

  factory TeacherCourseModelDetails.fromJson(Map<String, dynamic> json) =>
      TeacherCourseModelDetails(
        courseTeacherId: json["CourseTeacher_ID"] ?? 0,
        courseId: json["Course_ID"] ?? 0,
        courseName: json["Course_Name"] ?? '',
        batchIDs: json["Batch_IDs"] ?? '',
        batchNames: json["Batch_Names"] ?? '',
        slotIds: json["Slot_Ids"] ?? '',
        startTimes: json["start_times"] ?? '',
        endTimes: json["end_times"] ?? '',
        thumbnailPath: json["Thumbnail_Path"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "CourseTeacher_ID": courseTeacherId,
        "Course_ID": courseId,
        "Course_Name": courseName,
        "Batch_IDs": batchIDs,
        "Batch_Names": batchNames,
        "Slot_Ids": slotIds,
        "start_times": startTimes,
        "end_times": endTimes,
        "Thumbnail_Path": thumbnailPath
      };
}
