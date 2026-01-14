class Onetoonebatchmodel {
  int courseId;
  String courseName;
  String courseTeacherIDs;
  String batchStart;
  String batchEnd;
  int hasBatch;
  int hasOneOnOne;
  int? batchIDs;
  String? batchNames;
  List<int> slotIds;
  List<String> timeSlots;

  Onetoonebatchmodel(
      {required this.courseId,
      required this.courseName,
      required this.courseTeacherIDs,
      required this.batchIDs,
      required this.batchNames,
      required this.slotIds,
      required this.timeSlots,
      required this.batchEnd,
      required this.batchStart,
      required this.hasBatch,
      required this.hasOneOnOne});

  factory Onetoonebatchmodel.fromJson(Map<String, dynamic> json) {
    return Onetoonebatchmodel(
      courseId: json["Course_ID"] ?? 0,
      courseName: json["Course_Name"] ?? '',
      courseTeacherIDs: json["CourseTeacher_IDs"] ?? '',
      batchEnd: json["Batch_End_Date"] ?? '',
      batchStart: json["Batch_start_Date"] ?? '',
      hasBatch: json["has_batch_wise"],
      hasOneOnOne: json["has_slot_wise"],
      batchIDs: json["Batch_IDs"] == null
          ? null
          : int.tryParse(json["Batch_IDs"].toString()),
      batchNames: json["Batch_Names"],
      slotIds: json["Slot_Ids"] != null
          ? (json["Slot_Ids"] as String)
              .split(',')
              .map((x) => int.tryParse(x.trim()) ?? 0)
              .toList()
          : [],
      timeSlots: json["time_slots"] != null
          ? (json["time_slots"] as String)
              .split(',')
              .map((x) => x.trim())
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "Course_ID": courseId,
        "Course_Name": courseName,
        "CourseTeacher_IDs": courseTeacherIDs,
        "Batch_IDs": batchIDs,
        "Batch_Names": batchNames,
        "Slot_Ids": List<dynamic>.from(slotIds.map((x) => x)),
        "time_slots": List<dynamic>.from(timeSlots.map((x) => x)),
      };
}
