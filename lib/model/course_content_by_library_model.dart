class CourseContentLibraryModelElement {
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
  List<CourseModule>? courseModules;

  CourseContentLibraryModelElement({
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
    this.courseModules,
  });

  factory CourseContentLibraryModelElement.fromJson(
          Map<String, dynamic> json) =>
      CourseContentLibraryModelElement(
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
        courseModules: json["courseModules"] == null
            ? []
            : List<CourseModule>.from(
                json["courseModules"]!.map((x) => CourseModule.fromJson(x))),
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
        "courseModules": courseModules == null
            ? []
            : List<dynamic>.from(courseModules!.map((x) => x.toJson())),
      };
}

class CourseModule {
  int moduleId;
  String moduleName;
  List<SectionDetail> sectionDetails;

  CourseModule({
    required this.moduleId,
    required this.moduleName,
    required this.sectionDetails,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) => CourseModule(
        moduleId: json["Module_ID"],
        moduleName: json["Module_Name"],
        sectionDetails: List<SectionDetail>.from(
            json["sectionDetails"].map((x) => SectionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Module_ID": moduleId,
        "Module_Name": moduleName,
        "sectionDetails":
            List<dynamic>.from(sectionDetails.map((x) => x.toJson())),
      };
}

class SectionDetail {
  List<Content>? contents;
  int sectionId;
  String sectionName;

  SectionDetail({
    required this.contents,
    required this.sectionId,
    required this.sectionName,
  });

  factory SectionDetail.fromJson(Map<String, dynamic> json) => SectionDetail(
        contents: json["contents"] == null
            ? []
            : List<Content>.from(
                json["contents"]!.map((x) => Content.fromJson(x))),
        sectionId: json["sectionId"],
        sectionName: json["section_name"],
      );

  Map<String, dynamic> toJson() => {
        "contents": contents == null
            ? []
            : List<dynamic>.from(contents!.map((x) => x.toJson())),
        "sectionId": sectionId,
        "section_name": sectionName,
      };
}

class Content {
  String file;
  dynamic exams;
  String fileName;
  String fileType;
  int contentId;
  String contentName;
  String contentThumbnailPath;
  String contentThumbnailName;

  Content({
    required this.file,
    required this.exams,
    required this.fileName,
    required this.fileType,
    required this.contentId,
    required this.contentName,
    required this.contentThumbnailPath,
    required this.contentThumbnailName,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        file: json["file"],
        exams: json["exams"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        contentId: json["Content_ID"],
        contentName: json["contentName"],
        contentThumbnailPath: json["contentThumbnail_Path"],
        contentThumbnailName: json["contentThumbnail_name"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "exams": exams,
        "file_name": fileName,
        "file_type": fileType,
        "Content_ID": contentId,
        "contentName": contentName,
        "contentThumbnail_Path": contentThumbnailPath,
        "contentThumbnail_name": contentThumbnailName,
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

class PurpleCourseContentLibraryModel {
  int fieldCount;
  int affectedRows;
  int insertId;
  String info;
  int serverStatus;
  int warningStatus;
  int changedRows;

  PurpleCourseContentLibraryModel({
    required this.fieldCount,
    required this.affectedRows,
    required this.insertId,
    required this.info,
    required this.serverStatus,
    required this.warningStatus,
    required this.changedRows,
  });

  factory PurpleCourseContentLibraryModel.fromJson(Map<String, dynamic> json) =>
      PurpleCourseContentLibraryModel(
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
