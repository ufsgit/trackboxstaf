class CourseModulesModel {
  int moduleId;
  String moduleName;
  int isStudentModuleLocked;

  CourseModulesModel({
    required this.moduleId,
    required this.moduleName,
    required this.isStudentModuleLocked,
  });

  factory CourseModulesModel.fromJson(Map<String, dynamic> json) =>
      CourseModulesModel(
        moduleId: json["Module_ID"],
        moduleName: json["Module_Name"],
        isStudentModuleLocked: json["IsStudentModuleLocked"],
      );

  Map<String, dynamic> toJson() => {
        "Module_ID": moduleId,
        "Module_Name": moduleName,
        "IsStudentModuleLocked": isStudentModuleLocked,
      };
}
