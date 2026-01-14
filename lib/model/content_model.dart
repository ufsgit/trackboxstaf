class CourseContentByModuleModel {
  List<Content>? contents;

  CourseContentByModuleModel({
    this.contents,
  });

  factory CourseContentByModuleModel.fromJson(Map<String, dynamic> json) =>
      CourseContentByModuleModel(
        contents: List<Content>.from(
            json["contents"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents!.map((x) => x.toJson())),
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
        exams: json["exams"] == null
            ? []
            : List<Exam>.from(json["exams"]!.map((x) => Exam.fromJson(x))),
        fileName: json["file_name"],
        fileType: json["file_type"],
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
        "file_name": fileName,
        "file_type": fileType,
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
  List<Question>? questions;
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
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"]!.map((x) => Question.fromJson(x))),
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
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
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

class Question {
  int questionId;
  String questionText;
  List<dynamic> answerOptions;
  String correctAnswer;
  String answerMediaName;

  Question({
    required this.questionId,
    required this.questionText,
    required this.answerOptions,
    required this.correctAnswer,
    required this.answerMediaName,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["Question_ID"],
        questionText: json["questionText"],
        answerOptions: List<dynamic>.from(json["answerOptions"].map((x) => x)),
        correctAnswer: json["correctAnswer"],
        answerMediaName: json["Answer_Media_Name"],
      );

  Map<String, dynamic> toJson() => {
        "Question_ID": questionId,
        "questionText": questionText,
        "answerOptions": List<dynamic>.from(answerOptions.map((x) => x)),
        "correctAnswer": correctAnswer,
        "Answer_Media_Name": answerMediaName,
      };
}
