class MyCourseDetailsModel {
  int studentCourseId;
  int studentId;
  int courseId;
  String courseName;
  DateTime enrollmentDate;
  String expiryDate;
  int price;
  DateTime paymentDate;
  String paymentStatus;
  String lastAccessedContentId;
  String transactionId;
  String imagePath;
  String batchStart;
  String batchEnd;
  String batchTeacher;
  String oneToOneTeacher;
  String batchName;

  int deleteStatus;
  int batchID;
  String paymentMethod;
  int isStudentModuleLocked;
  String courseCompletionPercentage;

  MyCourseDetailsModel({
    required this.studentCourseId,
    required this.studentId,
    required this.courseId,
    required this.courseName,
    required this.enrollmentDate,
    required this.expiryDate,
    required this.price,
    required this.paymentDate,
    required this.paymentStatus,
    required this.lastAccessedContentId,
    required this.transactionId,
    required this.deleteStatus,
    required this.paymentMethod,
    required this.imagePath,
    required this.batchID,
    required this.batchTeacher,
    required this.batchEnd,
    required this.batchStart,
    required this.batchName,
    required this.oneToOneTeacher,
    required this.isStudentModuleLocked,
    required this.courseCompletionPercentage,
  });

  factory MyCourseDetailsModel.fromJson(Map<String, dynamic> json) =>
      MyCourseDetailsModel(
          studentCourseId: json["StudentCourse_ID"],
          isStudentModuleLocked: json["IsStudentModuleLocked"],
          studentId: json["Student_ID"],
          courseId: json["Course_ID"],
          courseName: json["Course_Name"],
          enrollmentDate: DateTime.parse(json["Enrollment_Date"]),
          expiryDate: json["Expiry_Date"] ?? '',
          price: json["Price"],
          paymentDate: DateTime.parse(json["Payment_Date"]),
          paymentStatus: json["Payment_Status"],
          lastAccessedContentId: json["LastAccessed_Content_ID"] ?? '',
          transactionId: json["Transaction_Id"],
          deleteStatus: json["Delete_Status"],
          batchID: json["Batch_ID"] ?? 0,
          paymentMethod: json["Payment_Method"],
          imagePath: json['Thumbnail_Path'],
          batchEnd: json["Batch_End_Date"] ?? '',
          batchStart: json["Batch_start_Date"] ?? '',
          batchTeacher: json["Teacher_Name_Batch"] ?? '',
          oneToOneTeacher: json["Teacher_Name_One_On_One"] ?? '',
          batchName: json["Batch_Name"] ?? '',
          courseCompletionPercentage: json["course_completion_percentage"]);

  Map<String, dynamic> toJson() => {
        "StudentCourse_ID": studentCourseId,
        "Student_ID": studentId,
        "Course_ID": courseId,
        "IsStudentModuleLocked": isStudentModuleLocked,
        "Course_Name": courseName,
        "Enrollment_Date": enrollmentDate.toIso8601String(),
        "Expiry_Date": expiryDate,
        "Price": price,
        "Payment_Date": paymentDate.toIso8601String(),
        "Payment_Status": paymentStatus,
        "LastAccessed_Content_ID": lastAccessedContentId,
        "Transaction_Id": transactionId,
        "Delete_Status": deleteStatus,
        "Batch_ID": batchID,
        "Payment_Method": paymentMethod,
        "Thumbnail_Path": imagePath,
        "Batch_Name": batchName
      };
}
