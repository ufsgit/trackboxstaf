class UpcomingLiveModel {
  String startTime;
  String endTime;
  String courseName;
  String batchName;
  String liveLink;
  int batchId;
  int courseTeacherId;
  int courseId;
  int slotId;
  int onGoing_LiveClass_Id;

  UpcomingLiveModel(
      {required this.endTime,
      required this.liveLink,
      required this.startTime,
      required this.courseName,
      required this.batchName,
      required this.batchId,
      required this.courseTeacherId,
      required this.courseId,
      required this.slotId,
      required this.onGoing_LiveClass_Id});

  factory UpcomingLiveModel.fromJson(Map<String, dynamic> json) =>
      UpcomingLiveModel(
          startTime: json["start_time"],
          endTime: json["end_time"],
          liveLink: json["Live_Link"] ?? '',
          courseName: json["Course_Name"],
          batchName: json["Batch_Name"],
          batchId: json["batch_id"],
          courseTeacherId: json["CourseTeacher_ID"],
          courseId: json["Course_ID"],
          slotId: json["Slot_Id"],
          onGoing_LiveClass_Id: json["onGoing_LiveClass_Id"] ?? 0);

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "Course_Name": courseName,
        "Live_Link": liveLink,
        "end_time": endTime,
        "Batch_Name": batchName,
        "batch_id": batchId,
        "CourseTeacher_ID": courseTeacherId,
        "Course_ID": courseId,
        "Slot_Id": slotId,
        "onGoing_LiveClass_Id": onGoing_LiveClass_Id,
      };
}
