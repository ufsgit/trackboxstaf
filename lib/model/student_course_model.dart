class StudentListCourseModel {
  int studentCourseId;
  int studentId;
  int courseId;
  String firstName;
  int selectedTeacher;
  String enrollmentDate;
  String expiryDate;
  int price;
  DateTime paymentDate;
  String paymentStatus;
  String lastAccessedContentId;
  String transactionId;
  int deleteStatus;
  String paymentMethod;
  int batchId;
  dynamic batchName;
  int requestedSlotId;
  int slotId;
  String startTime;
  String profilePhotoPath;
  String endTime;
  String lastName;
  String allocatedStartTime;
  String allocatedEndTime;
  String teacherNameOneOnOne;
  dynamic teacherNameBatch;

  StudentListCourseModel({
    required this.studentCourseId,
    required this.studentId,
    required this.courseId,
    required this.firstName,
    required this.selectedTeacher,
    required this.enrollmentDate,
    required this.expiryDate,
    required this.price,
    required this.paymentDate,
    required this.paymentStatus,
    required this.lastAccessedContentId,
    required this.profilePhotoPath,
    required this.transactionId,
    required this.deleteStatus,
    required this.paymentMethod,
    required this.batchId,
    required this.batchName,
    required this.requestedSlotId,
    required this.lastName,
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.allocatedStartTime,
    required this.allocatedEndTime,
    required this.teacherNameOneOnOne,
    required this.teacherNameBatch,
  });

  factory StudentListCourseModel.fromJson(Map<String, dynamic> json) =>
      StudentListCourseModel(
        studentCourseId: json["StudentCourse_ID"] ?? 0,
        studentId: json["Student_ID"] ?? 0,
        courseId: json["Course_ID"] ?? 0,
        firstName: json["First_Name"] ?? "",
        lastName: json["Last_Name"] ?? '',
        profilePhotoPath: json["Profile_Photo_Path"] ?? '',
        selectedTeacher: json["selectedTeacher"] ?? 0,
        enrollmentDate: json["Enrollment_Date"] ?? '',
        expiryDate: json["Expiry_Date"] ?? '',
        price: json["Price"] ?? 0,
        paymentDate: DateTime.parse(json["Payment_Date"]),
        paymentStatus: json["Payment_Status"] ?? '',
        lastAccessedContentId: json["LastAccessed_Content_ID"] ?? 0,
        transactionId: json["Transaction_Id"] ?? 0,
        deleteStatus: json["Delete_Status"] ?? 0,
        paymentMethod: json["Payment_Method"] ?? '',
        batchId: json["Batch_ID"] ?? 0,
        batchName: json["Batch_Name"] ?? '',
        requestedSlotId: json["Requested_Slot_Id"] ?? 0,
        slotId: json["Slot_Id"] ?? 0,
        startTime: json["start_time"] ?? '',
        endTime: json["end_time"] ?? '',
        allocatedStartTime: json["allocatedStartTime"] ?? '',
        allocatedEndTime: json["allocatedEndTime"] ?? '',
        teacherNameOneOnOne: json["Teacher_Name_One_On_One"] ?? '',
        teacherNameBatch: json["Teacher_Name_Batch"],
      );

  Map<String, dynamic> toJson() => {
        "StudentCourse_ID": studentCourseId,
        "Student_ID": studentId,
        "Course_ID": courseId,
        "First_Name": firstName,
        "selectedTeacher": selectedTeacher,
        "Enrollment_Date": enrollmentDate,
        "Expiry_Date": expiryDate,
        "Price": price,
        "Payment_Date": paymentDate.toIso8601String(),
        "Payment_Status": paymentStatus,
        "LastAccessed_Content_ID": lastAccessedContentId,
        "Transaction_Id": transactionId,
        "Delete_Status": deleteStatus,
        "Payment_Method": paymentMethod,
        "Batch_ID": batchId,
        "Batch_Name": batchName,
        "Requested_Slot_Id": requestedSlotId,
        "Slot_Id": slotId,
        "start_time": startTime,
        "end_time": endTime,
        "allocatedStartTime": allocatedStartTime,
        "allocatedEndTime": allocatedEndTime,
        "Teacher_Name_One_On_One": teacherNameOneOnOne,
        "Teacher_Name_Batch": teacherNameBatch,
      };
}
