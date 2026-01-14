class BatchWithDaysModel {
  int daysId;
  String dayName;
  int isDayUnlocked;
  int is_exam_day;
  int isToday;

  BatchWithDaysModel({
    required this.daysId,
    required this.dayName,
    required this.isDayUnlocked,
    required this.is_exam_day,
    required this.isToday,
  });

  factory BatchWithDaysModel.fromJson(Map<String, dynamic> json) =>
      BatchWithDaysModel(
        daysId: json["Days_Id"],
        dayName: json["Day_Name"],
        isDayUnlocked: json["is_day_unlocked"],
        is_exam_day: json["is_exam_day"],
        isToday: json["isToday"],
      );

  Map<String, dynamic> toJson() => {
        "Days_Id": daysId,
        "Day_Name": dayName,
        "is_day_unlocked": isDayUnlocked,
        "is_exam_day": is_exam_day,
        "isToday": isToday,
      };
}
