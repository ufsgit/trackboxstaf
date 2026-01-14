class TeacherLoginModel {
  String email;
  String password;

  TeacherLoginModel({
    required this.email,
    required this.password,
  });

  factory TeacherLoginModel.fromJson(Map<String, dynamic> json) =>
      TeacherLoginModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
