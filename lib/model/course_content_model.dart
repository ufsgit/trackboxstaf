class GetCourseContentModelElement {
  int? courseId;
  String? courseName;
  int? categoryId;
  int? validity;
  String? price;
  int? deleteStatus;
  String? disableStatus;
  String? liveClassEnabled;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? thingsToLearn;
  String? thumbnailPath;
  String? thumbnailName;
  String? thumbnailVideoPath;
  String? thumbnailVideoName;
  List<ScheduledTeacher>? scheduledTeachers;
  List<int>? sections;
  dynamic scheduledBatch;
  List<SectionName>? sectionName;
  int? sectionId;
  String? getCourseContentModelSectionName;
  List<Content>? contents;

  GetCourseContentModelElement({
    this.courseId,
    this.courseName,
    this.categoryId,
    this.validity,
    this.price,
    this.deleteStatus,
    this.disableStatus,
    this.liveClassEnabled,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.thingsToLearn,
    this.thumbnailPath,
    this.thumbnailName,
    this.thumbnailVideoPath,
    this.thumbnailVideoName,
    this.scheduledTeachers,
    this.sections,
    this.scheduledBatch,
    this.sectionName,
    this.sectionId,
    this.getCourseContentModelSectionName,
    this.contents,
  });

  factory GetCourseContentModelElement.fromJson(Map<String, dynamic> json) =>
      GetCourseContentModelElement(
        courseId: json["Course_ID"],
        courseName: json["Course_Name"],
        categoryId: json["Category_ID"],
        validity: json["Validity"],
        price: json["Price"],
        deleteStatus: json["Delete_Status"],
        disableStatus: json["Disable_Status"],
        liveClassEnabled: json["Live_Class_Enabled"],
        description: json["Description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        thingsToLearn: json["Things_To_Learn"],
        thumbnailPath: json["Thumbnail_Path"],
        thumbnailName: json["Thumbnail_Name"],
        thumbnailVideoPath: json["ThumbnailVideo_Path"],
        thumbnailVideoName: json["ThumbnailVideo_Name"],
        scheduledTeachers: json["scheduledTeachers"] == null
            ? []
            : List<ScheduledTeacher>.from(json["scheduledTeachers"]!
                .map((x) => ScheduledTeacher.fromJson(x))),
        sections: json["Sections"] == null
            ? []
            : List<int>.from(json["Sections"]!.map((x) => x)),
        scheduledBatch: json["scheduledBatch"],
        sectionName: json["Section_Name"] == null
            ? []
            : List<SectionName>.from(
                json["Section_Name"]!.map((x) => SectionName.fromJson(x))),
        sectionId: json["sectionId"],
        getCourseContentModelSectionName: json["section_name"],
        contents: json["contents"] == null
            ? []
            : List<Content>.from(
                json["contents"]!.map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Course_ID": courseId,
        "Course_Name": courseName,
        "Category_ID": categoryId,
        "Validity": validity,
        "Price": price,
        "Delete_Status": deleteStatus,
        "Disable_Status": disableStatus,
        "Live_Class_Enabled": liveClassEnabled,
        "Description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "Things_To_Learn": thingsToLearn,
        "Thumbnail_Path": thumbnailPath,
        "Thumbnail_Name": thumbnailName,
        "ThumbnailVideo_Path": thumbnailVideoPath,
        "ThumbnailVideo_Name": thumbnailVideoName,
        "scheduledTeachers": scheduledTeachers == null
            ? []
            : List<dynamic>.from(scheduledTeachers!.map((x) => x.toJson())),
        "Sections":
            sections == null ? [] : List<dynamic>.from(sections!.map((x) => x)),
        "scheduledBatch": scheduledBatch,
        "Section_Name": sectionName == null
            ? []
            : List<dynamic>.from(sectionName!.map((x) => x.toJson())),
        "sectionId": sectionId,
        "section_name": getCourseContentModelSectionName,
        "contents": contents == null
            ? []
            : List<dynamic>.from(contents!.map((x) => x.toJson())),
      };
}

class Content {
  String? file;
  List<Exam>? exams;
  int moduleId;
  String? fileName;
  String? fileType;
  int sectionId;
  int contentId;
  String contentName;
  String contentThumbnailPath;
  String contentThumbnailName;

  Content({
    required this.file,
    required this.exams,
    required this.moduleId,
    required this.fileName,
    required this.fileType,
    required this.sectionId,
    required this.contentId,
    required this.contentName,
    required this.contentThumbnailPath,
    required this.contentThumbnailName,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        file: json["file"],
        exams: json["exams"] == null
            ? []
            : List<Exam>.from(json["exams"]!.map((x) => Exam.fromJson(x))),
        moduleId: json["Module_ID"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        sectionId: json["sectionId"],
        contentId: json["Content_ID"],
        contentName: json["contentName"],
        contentThumbnailPath: json["contentThumbnail_Path"],
        contentThumbnailName: json["contentThumbnail_name"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "exams": exams == null
            ? []
            : List<dynamic>.from(exams!.map((x) => x.toJson())),
        "Module_ID": moduleId,
        "file_name": fileName,
        "file_type": fileType,
        "sectionId": sectionId,
        "Content_ID": contentId,
        "contentName": contentName,
        "contentThumbnail_Path": contentThumbnailPath,
        "contentThumbnail_name": contentThumbnailName,
      };
}

class Exam {
  int examId;
  String examName;
  String fileName;
  String fileType;
  dynamic questions;
  int timeLimit;
  int passingScore;
  String mainQuestion;
  int totalQuestions;
  String answerKeyName;
  String answerKeyPath;
  String supportingDocumentName;
  String supportingDocumentPath;

  Exam({
    required this.examId,
    required this.examName,
    required this.fileName,
    required this.fileType,
    required this.questions,
    required this.timeLimit,
    required this.passingScore,
    required this.mainQuestion,
    required this.totalQuestions,
    required this.answerKeyName,
    required this.answerKeyPath,
    required this.supportingDocumentName,
    required this.supportingDocumentPath,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        examId: json["Exam_ID"],
        examName: json["examName"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        questions: json["questions"],
        timeLimit: json["timeLimit"],
        passingScore: json["passingScore"],
        mainQuestion: json["Main_Question"],
        totalQuestions: json["totalQuestions"],
        answerKeyName: json["Answer_Key_Name"],
        answerKeyPath: json["Answer_Key_Path"],
        supportingDocumentName: json["Supporting_Document_Name"],
        supportingDocumentPath: json["Supporting_Document_Path"],
      );

  Map<String, dynamic> toJson() => {
        "Exam_ID": examId,
        "examName": examName,
        "file_name": fileName,
        "file_type": fileType,
        "questions": questions,
        "timeLimit": timeLimit,
        "passingScore": passingScore,
        "Main_Question": mainQuestion,
        "totalQuestions": totalQuestions,
        "Answer_Key_Name": answerKeyName,
        "Answer_Key_Path": answerKeyPath,
        "Supporting_Document_Name": supportingDocumentName,
        "Supporting_Document_Path": supportingDocumentPath,
      };
}

class ScheduledTeacher {
  List<TimeSlot> timeSlots;
  int teacherId;
  int deleteStatus;
  int courseTeacherId;

  ScheduledTeacher({
    required this.timeSlots,
    required this.teacherId,
    required this.deleteStatus,
    required this.courseTeacherId,
  });

  factory ScheduledTeacher.fromJson(Map<String, dynamic> json) =>
      ScheduledTeacher(
        timeSlots: List<TimeSlot>.from(
            json["timeSlots"].map((x) => TimeSlot.fromJson(x))),
        teacherId: json["Teacher_ID"],
        deleteStatus: json["Delete_Status"],
        courseTeacherId: json["CourseTeacher_ID"],
      );

  Map<String, dynamic> toJson() => {
        "timeSlots": List<dynamic>.from(timeSlots.map((x) => x.toJson())),
        "Teacher_ID": teacherId,
        "Delete_Status": deleteStatus,
        "CourseTeacher_ID": courseTeacherId,
      };
}

class TimeSlot {
  int slotId;
  String endTime;
  String startTime;
  int deleteStatus;

  TimeSlot({
    required this.slotId,
    required this.endTime,
    required this.startTime,
    required this.deleteStatus,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        slotId: json["Slot_Id"],
        endTime: json["endTime"],
        startTime: json["startTime"],
        deleteStatus: json["Delete_Status"],
      );

  Map<String, dynamic> toJson() => {
        "Slot_Id": slotId,
        "endTime": endTime,
        "startTime": startTime,
        "Delete_Status": deleteStatus,
      };
}

class SectionName {
  int sectionId;
  String sectionName;

  SectionName({
    required this.sectionId,
    required this.sectionName,
  });

  factory SectionName.fromJson(Map<String, dynamic> json) => SectionName(
        sectionId: json["Section_Id"],
        sectionName: json["Section_Name"],
      );

  Map<String, dynamic> toJson() => {
        "Section_Id": sectionId,
        "Section_Name": sectionName,
      };
}

class PurpleGetCourseContentModel {
  int fieldCount;
  int affectedRows;
  int insertId;
  String info;
  int serverStatus;
  int warningStatus;
  int changedRows;

  PurpleGetCourseContentModel({
    required this.fieldCount,
    required this.affectedRows,
    required this.insertId,
    required this.info,
    required this.serverStatus,
    required this.warningStatus,
    required this.changedRows,
  });

  factory PurpleGetCourseContentModel.fromJson(Map<String, dynamic> json) =>
      PurpleGetCourseContentModel(
        fieldCount: json["fieldCount"],
        affectedRows: json["affectedRows"],
        insertId: json["insertId"],
        info: json["info"],
        serverStatus: json["serverStatus"],
        warningStatus: json["warningStatus"],
        changedRows: json["changedRows"],
      );

  Map<String, dynamic> toJson() => {
        "fieldCount": fieldCount,
        "affectedRows": affectedRows,
        "insertId": insertId,
        "info": info,
        "serverStatus": serverStatus,
        "warningStatus": warningStatus,
        "changedRows": changedRows,
      };
}
