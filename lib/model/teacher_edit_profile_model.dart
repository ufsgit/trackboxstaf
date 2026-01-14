class TeacherEditProfileModel {
  int userId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String password;
  int deleteStatus;
  int userTypeId;
  dynamic userRoleId;
  dynamic userStatus;

  TeacherEditProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.deleteStatus,
    required this.userTypeId,
    required this.userRoleId,
    required this.userStatus,
  });

  factory TeacherEditProfileModel.fromJson(Map<String, dynamic> json) =>
      TeacherEditProfileModel(
        userId: json["User_ID"],
        firstName: json["First_Name"],
        lastName: json["Last_Name"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        password: json["password"],
        deleteStatus: json["Delete_Status"],
        userTypeId: json["User_Type_Id"],
        userRoleId: json["User_Role_Id"],
        userStatus: json["User_Status"],
      );

  Map<String, dynamic> toJson() => {
        "User_ID": userId,
        "First_Name": firstName,
        "Last_Name": lastName,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "password": password,
        "Delete_Status": deleteStatus,
        "User_Type_Id": userTypeId,
        "User_Role_Id": userRoleId,
        "User_Status": userStatus,
      };
}
