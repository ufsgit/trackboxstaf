import 'package:breffini_staff/controller/course_enrol_controller.dart';
import 'package:breffini_staff/controller/course_module_controler.dart';
import 'package:breffini_staff/view/pages/chats/widgets/loading_circle.dart';
import 'package:breffini_staff/view/pages/courses/day_by_module_screen.dart';
import 'package:breffini_staff/view/pages/courses/widgets/module_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseModulePage extends StatefulWidget {
  final List<String> badgeIcons;
  final int courseId;
  final bool isFromBatch;
  final String? batchId;
  final bool isLibrary;
  const CourseModulePage({
    super.key,
    required this.badgeIcons,
    required this.courseId,
    required this.isFromBatch,
    this.batchId,
    required this.isLibrary,
  });

  @override
  State<CourseModulePage> createState() => _CourseModulePageState();
}

class _CourseModulePageState extends State<CourseModulePage> {
  final CourseModuleController controller = Get.find();
  int? selectedIndex;
  final CourseEnrolController enrolController = Get.find();
  void _onModuleTap(BuildContext context, int index,
      {required String courseId,
      required String moduleId,
      required String title}) async {
    final module = controller.courseModulesList[index];
    final isLocked = module.isStudentModuleLocked == 1;

    if (isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please purchase the course to see full contents.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        selectedIndex = index;
      });
      Get.to(() => DayByModuleScreen(
            isLibrary: widget.isLibrary,
            courseId: courseId,
            moduleId: moduleId,
            isFromBatch: widget.isFromBatch,
            batchId: widget.batchId ?? '',
            appBarTitle: title,
          ));
    }
  }

  @override
  void initState() {
    controller.getCoursesModules(courseId: widget.courseId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return

            // controller.isModuleLoading.value
            //     ? const Center(
            //         child: Column(
            //           children: [
            //             SizedBox(
            //               height: 100,
            //             ),
            //             LoadingCircle(),
            //           ],
            //         ),
            //       )
            //     :

            controller.courseModulesList.isEmpty
                ? const Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text('No Modules'),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            mainAxisExtent: 121),
                    itemCount: controller.courseModulesList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final badgeIcon = index < widget.badgeIcons.length
                          ? widget.badgeIcons[index]
                          : 'assets/images/Bronze.png';

                      final module = controller.courseModulesList[index];
                      final isLocked = module.isStudentModuleLocked == 1;
                      final isSelected = selectedIndex == index;

                      return ModuleWidget(
                        isLocked: isLocked,
                        isSelected: isSelected,
                        onTap: !isLocked
                            ? () {
                                _onModuleTap(context, index,
                                    moduleId: module.moduleId.toString(),
                                    courseId: widget.courseId.toString(),
                                    title: module.moduleName);
                              }
                            : null,
                        badgeIcon: badgeIcon,
                        moduleName: module.moduleName,
                      );
                    },
                  );
      },
    );
  }
}
