class CourseInfoModel {
  int courseId;
  String courseName;
  int categoryId;
  int validity;
  String price;
  int deleteStatus;
  int disableStatus;
  int liveClassEnabled;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  String thingsToLearn;
  String thumbnailPath;
  String thumbnailName;
  String thumbnailVideoPath;
  String thumbnailVideoName;

  CourseInfoModel({
    required this.courseId,
    required this.courseName,
    required this.categoryId,
    required this.validity,
    required this.price,
    required this.deleteStatus,
    required this.disableStatus,
    required this.liveClassEnabled,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.thingsToLearn,
    required this.thumbnailPath,
    required this.thumbnailName,
    required this.thumbnailVideoPath,
    required this.thumbnailVideoName,
  });

  factory CourseInfoModel.fromJson(Map<String, dynamic> json) =>
      CourseInfoModel(
        courseId: json["Course_ID"],
        courseName: json["Course_Name"],
        categoryId: json["Category_ID"],
        validity: json["Validity"],
        price: json["Price"],
        deleteStatus: json["Delete_Status"],
        disableStatus: json["Disable_Status"],
        liveClassEnabled: json["Live_Class_Enabled"],
        description: json["Description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        thingsToLearn: json["Things_To_Learn"],
        thumbnailPath: json["Thumbnail_Path"],
        thumbnailName: json["Thumbnail_Name"],
        thumbnailVideoPath: json["ThumbnailVideo_Path"],
        thumbnailVideoName: json["ThumbnailVideo_Name"],
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "Things_To_Learn": thingsToLearn,
        "Thumbnail_Path": thumbnailPath,
        "Thumbnail_Name": thumbnailName,
        "ThumbnailVideo_Path": thumbnailVideoPath,
        "ThumbnailVideo_Name": thumbnailVideoName,
      };
}
