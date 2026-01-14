class ExploreCoursesModel {
  int? courseId;
  String? courseName;
  int? categoryID;
  int? validity;
  String? price;
  int? deleteStatus;
  int? disableStatus;
  int? liveClassEnabled;
  String? thumbnailPath;
  String? thumbnailName;

  ExploreCoursesModel({
    required this.courseId,
    required this.courseName,
    required this.categoryID,
    required this.validity,
    required this.price,
    required this.deleteStatus,
    required this.disableStatus,
    required this.liveClassEnabled,
    required this.thumbnailPath,
    required this.thumbnailName,
  });

  factory ExploreCoursesModel.fromJson(Map<String, dynamic> json) =>
      ExploreCoursesModel(
        courseId: json["Course_ID"],
        courseName: json["Course_Name"],
        categoryID: json["Category_ID"],
        validity: json["Validity"],
        price: json["Price"],
        deleteStatus: json["Delete_Status"],
        disableStatus: json["Disable_Status"],
        liveClassEnabled: json["Live_Class_Enabled"],
        thumbnailPath: json["Thumbnail_Path"],
        thumbnailName: json["Thumbnail_Name"],
      );

  Map<String, dynamic> toJson() => {
        "Course_ID": courseId,
        "Course_Name": courseName,
        "Category_ID": categoryID,
        "Validity": validity,
        "Price": price,
        "Delete_Status": deleteStatus,
        "Disable_Status": disableStatus,
        "Live_Class_Enabled": liveClassEnabled,
        "Thumbnail_Path": thumbnailPath,
        "Thumbnail_Name": thumbnailName,
      };
}
