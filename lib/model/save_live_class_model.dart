class SaveLiveClassTeacher {
  int liveClassId;
  int courseId;
  int teacherId;
  int batchId;
  DateTime scheduledDateTime;
  int duration;
  DateTime startTime;
  String liveLink;
  int slotId;

  SaveLiveClassTeacher({
    required this.liveClassId,
    required this.courseId,
    required this.teacherId,
    required this.batchId,
    required this.scheduledDateTime,
    required this.duration,
    required this.startTime,
    required this.liveLink,
    required this.slotId,
  });

  factory SaveLiveClassTeacher.fromJson(Map<String, dynamic> json) =>
      SaveLiveClassTeacher(
          liveClassId: json["LiveClass_ID"],
          courseId: json["Course_ID"],
          teacherId: json["Teacher_ID"],
          batchId: json["Batch_Id"],
          scheduledDateTime: DateTime.parse(json["Scheduled_DateTime"]),
          duration: json["Duration"],
          startTime: DateTime.parse(json["Start_Time"]),
          liveLink: json["Live_Link"],
          slotId: json["Slot_Id"]);

  Map<String, dynamic> toJson() => {
        "LiveClass_ID": liveClassId,
        "Course_ID": courseId,
        "Teacher_ID": teacherId,
        "Batch_Id": batchId,
        "Scheduled_DateTime": scheduledDateTime.toIso8601String(),
        "Duration": duration,
        "Start_Time": startTime.toIso8601String(),
        "Live_Link": liveLink,
        "Slot_Id": slotId
      };
}
