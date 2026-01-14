class RecordingsModel {
  int liveClassId;
  DateTime scheduledDateTime;
  String recordClassLink;
  String thumbMailPath;
  String courseName;

  RecordingsModel({
    required this.liveClassId,
    required this.scheduledDateTime,
    required this.recordClassLink,
    required this.courseName,
    required this.thumbMailPath,
  });

  factory RecordingsModel.fromJson(Map<String, dynamic> json) =>
      RecordingsModel(
        liveClassId: json["LiveClass_ID"],
        scheduledDateTime: DateTime.parse(json["Scheduled_DateTime"]),
        recordClassLink: json["Record_Class_Link"],
        courseName: json["Course_Name"],
        thumbMailPath: json["Thumbnail_Path"],
      );

  Map<String, dynamic> toJson() => {
        "LiveClass_ID": liveClassId,
        "Scheduled_DateTime": scheduledDateTime.toIso8601String(),
        "Record_Class_Link": recordClassLink,
      };
}
