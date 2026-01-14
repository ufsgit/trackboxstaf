import 'package:breffini_staff/controller/course_module_controler.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/pages/courses/widgets/module_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MockTestModuleScreen extends StatefulWidget {
  final List<String> badgeIcons;
  final int courseId;

  const MockTestModuleScreen({
    Key? key,
    required this.badgeIcons,
    required this.courseId,
  }) : super(key: key);

  @override
  State<MockTestModuleScreen> createState() => _MockTestModuleScreenState();
}

class _MockTestModuleScreenState extends State<MockTestModuleScreen> {
  final CourseModuleController controller = Get.find();
  int selectedIndex = -1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getModulesofMockTests(courseId: widget.courseId.toString());
    });
    super.initState();
  }

  void _onModuleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Get.to(() => DayByMockExamScreen(
    //       isEnrollCourse: 1,
    //       moduleId: controller.mockModules[index].moduleId.toString(),
    //       courseId: widget.courseId.toString(),
    //       appBarTitle: controller.mockModules[index].moduleName,
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorResources.colorBlue100,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorResources.colorBlack.withOpacity(.4),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Mock Tests',
                  style: GoogleFonts.plusJakartaSans(
                    color: ColorResources.colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(
          () => controller.mockModules.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      mainAxisExtent: 120,
                    ),
                    itemCount: controller.mockModules.length,
                    itemBuilder: (context, index) {
                      final badgeIcon = index < widget.badgeIcons.length
                          ? widget.badgeIcons[index]
                          : 'assets/images/Bronze.png';

                      return ModuleWidget(
                        isLocked: false,
                        isSelected: selectedIndex == index,
                        onTap: () => _onModuleTap(index),
                        badgeIcon: badgeIcon,
                        moduleName: controller.mockModules[index].moduleName,
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    'No Mock tests to show',
                    style: GoogleFonts.plusJakartaSans(
                      color: ColorResources.colorBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
