class CourseContentByModuleModel {
  List<Content>? contents;

  CourseContentByModuleModel({
    this.contents,
  });

  factory CourseContentByModuleModel.fromJson(Map<String, dynamic> json) {
    var contentsList = json['contents'] as List<dynamic>? ?? [];
    return CourseContentByModuleModel(
      contents: contentsList.map((x) => Content.fromJson(x)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "contents": contents?.map((x) => x.toJson()).toList() ?? [],
      };
}

class Content {
  String? file;
  List<Exam>? exams;
  String? fileName;
  String? fileType;
  int contentId;
  String contentName;
  String contentThumbnailPath;
  String contentThumbnailName,externalLink;
  int isExamTest;

  Content({
    required this.file,
    required this.exams,
    required this.fileName,
    required this.fileType,
    required this.contentId,
    required this.contentName,
    required this.contentThumbnailPath,
    required this.contentThumbnailName,
    required this.externalLink,
    required this.isExamTest,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    var examsList = json['exams'] as List<dynamic>? ?? [];
    return Content(
      file: json['file'],
      exams: examsList.map((x) => Exam.fromJson(x)).toList(),
      fileName: json['file_name'],
      fileType: json['file_type'],
      contentId: json['Content_ID'],
      contentName: json['contentName'],
      contentThumbnailPath: json['contentThumbnail_Path'],
      contentThumbnailName: json['contentThumbnail_name'],
      externalLink: json['External_Link'],
      isExamTest: json['Is_Exam_Test'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "file": file,
        "exams": exams?.map((x) => x.toJson()).toList(),
        "file_name": fileName,
        "file_type": fileType,
        "Content_ID": contentId,
        "contentName": contentName,
        "contentThumbnail_Path": contentThumbnailPath,
        "contentThumbnail_name": contentThumbnailName,
        "External_Link": externalLink,
        "Is_Exam_Test": isExamTest,
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
  int isExamUnlocked;
  int Is_Question_Unlocked;
  int Is_Question_Media_Unlocked;
  int isAnswerUnlocked;
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
    required this.isExamUnlocked,
    required this.Is_Question_Unlocked,
    required this.Is_Question_Media_Unlocked,
    required this.supportingDocumentName,
    required this.supportingDocumentPath,
    required this.isAnswerUnlocked,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
      examId: json["Exam_ID"] ?? 0,
      examName: json["examName"],
      fileName: json["file_name"],
      fileType: json["file_type"],
      questions: json["questions"],
      timeLimit: json["timeLimit"] ?? 0,
      passingScore: json["passingScore"] ?? 0,
      mainQuestion: json["Main_Question"],
      totalQuestions: json["totalQuestions"] ?? 0,
      answerKeyName: json["Answer_Key_Name"],
      answerKeyPath: json["Answer_Key_Path"],
      isExamUnlocked: json["is_Exam_Unlocked"] ?? 0,
      Is_Question_Unlocked: json["Is_Question_Unlocked"] ?? 0,
      Is_Question_Media_Unlocked: json["Is_Question_Media_Unlocked"] ?? 0,
      supportingDocumentName: json["Supporting_Document_Name"],
      supportingDocumentPath: json["Supporting_Document_Path"],
      isAnswerUnlocked: json["Is_Answer_Unlocked"]);

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
        "is_Exam_Unlocked": isExamUnlocked,
        "Is_Question_Unlocked": Is_Question_Unlocked,
        "Is_Question_Media_Unlocked": Is_Question_Media_Unlocked,
        "Supporting_Document_Name": supportingDocumentName,
        "Supporting_Document_Path": supportingDocumentPath,
        "Is_Answer_Unlocked": isAnswerUnlocked
      };
}
