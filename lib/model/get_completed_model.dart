class CompletedLiveModel {
  int liveClassId;
  int batchId;
  int courseId;
  String courseName;
  int duration;
  String startTime;
  String endTime;
  DateTime scheduledDateTime;
  String liveLink;
  String firstName;
  String batchName;

  CompletedLiveModel({
    required this.liveClassId,
    required this.batchId,
    required this.courseId,
    required this.courseName,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.scheduledDateTime,
    required this.liveLink,
    required this.firstName,
    required this.batchName,
  });

  factory CompletedLiveModel.fromJson(Map<String, dynamic> json) =>
      CompletedLiveModel(
        liveClassId: json["LiveClass_ID"],
        batchId: json["Batch_Id"],
        courseId: json["Course_ID"],
        courseName: json["Course_Name"],
        duration: json["Duration"] ?? 0,
        startTime: json["Start_Time"] ?? "",
        endTime: json["End_Time"] ?? "",
        scheduledDateTime: DateTime.parse(json["Scheduled_DateTime"]),
        liveLink: json["Live_Link"] ?? "",
        firstName: json["First_Name"],
        batchName: json["Batch_Name"],
      );

  Map<String, dynamic> toJson() => {
        "LiveClass_ID": liveClassId,
        "Batch_Id": batchId,
        "Course_ID": courseId,
        "Course_Name": courseName,
        "Duration": duration,
        "Start_Time": startTime,
        "End_Time": endTime,
        "Scheduled_DateTime": scheduledDateTime.toIso8601String(),
        "Live_Link": liveLink,
        "First_Name": firstName,
        "Batch_Name": batchName
      };
}
