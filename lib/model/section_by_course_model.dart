class SectionByCourseModel {
  int sectionId;
  int examTypeId;
  String sectionName;
  int deleteStatus;
  String? lock;

  SectionByCourseModel(
      {required this.sectionId,
      required this.examTypeId,
      required this.sectionName,
      required this.deleteStatus,
      required this.lock});

  factory SectionByCourseModel.fromJson(Map<String, dynamic> json) =>
      SectionByCourseModel(
        sectionId: json["Section_ID"],
        examTypeId: json["ExamType_ID"],
        sectionName: json["Section_Name"],
        deleteStatus: json["Delete_Status"],
        lock: json["Lock"],
      );

  Map<String, dynamic> toJson() => {
        "Section_ID": sectionId,
        "ExamType_ID": examTypeId,
        "Section_Name": sectionName,
        "Delete_Status": deleteStatus,
        "Lock": lock,
      };
}
