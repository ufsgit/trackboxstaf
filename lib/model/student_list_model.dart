class StudentListModel {
  final int studentCourseId;
  final int studentId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String socialProvider;
  final String socialId;
  final int occupationId;
  final String profilePhotoPath;
  final String profilePhotoName;
  final String avatar;
  final DateTime? lastOnline; // Nullable field
  final int courseId;
  final int isStudentModuleLocked;

  StudentListModel({
    required this.studentCourseId,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.socialProvider,
    required this.socialId,
    required this.occupationId,
    required this.profilePhotoPath,
    required this.profilePhotoName,
    required this.avatar,
    this.lastOnline,
    required this.courseId,
    required this.isStudentModuleLocked,
  });

  factory StudentListModel.fromJson(Map<String, dynamic> json) {
    return StudentListModel(
      studentCourseId: json['StudentCourse_ID'] as int? ?? 0,
      studentId: json['Student_ID'] as int? ?? 0,
      firstName: json['First_Name'] as String? ?? '',
      lastName: json['Last_Name'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      phoneNumber: json['Phone_Number'] as String? ?? '',
      socialProvider: json['Social_Provider'] as String? ?? '',
      socialId: json['Social_ID'] as String? ?? '',
      occupationId: json['Occupation_Id'] as int? ?? 0,
      profilePhotoPath: json['Profile_Photo_Path'] ?? '',
      profilePhotoName: json['Profile_Photo_Name'] as String? ?? '',
      avatar: json['Avatar'] as String? ?? '',
      lastOnline: json['Last_Online'] != null
          ? DateTime.parse(json['Last_Online'])
          : null,
      courseId: json['Course_ID'] as int? ?? 0,
      isStudentModuleLocked: json['IsStudentModuleLocked'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudentCourse_ID': studentCourseId,
      'Student_ID': studentId,
      'First_Name': firstName,
      'Last_Name': lastName,
      'Email': email,
      'Phone_Number': phoneNumber,
      'Social_Provider': socialProvider,
      'Social_ID': socialId,
      'Occupation_Id': occupationId,
      'Profile_Photo_Path': profilePhotoPath,
      'Profile_Photo_Name': profilePhotoName,
      'Avatar': avatar,
      'Last_Online': lastOnline?.toIso8601String(),
      'Course_ID': courseId,
      'IsStudentModuleLocked': isStudentModuleLocked,
    };
  }
}
