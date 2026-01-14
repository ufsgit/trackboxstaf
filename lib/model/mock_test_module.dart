class MockTestModuleModel {
  int moduleId;
  String moduleName;

  MockTestModuleModel({
    required this.moduleId,
    required this.moduleName,
  });

  factory MockTestModuleModel.fromJson(Map<String, dynamic> json) =>
      MockTestModuleModel(
        moduleId: json["Module_ID"],
        moduleName: json["Module_Name"],
      );

  Map<String, dynamic> toJson() => {
        "Module_ID": moduleId,
        "Module_Name": moduleName,
      };
}
