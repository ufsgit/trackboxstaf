import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/controller/course_content_controller.dart';
import 'package:breffini_staff/controller/course_module_controler.dart';
import 'package:breffini_staff/core/theme/app_decoration.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/core/theme/theme_helper.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/hod_course_model.dart';
import 'package:breffini_staff/view/pages/chats/widgets/custom_appbar_widget.dart';
import 'package:breffini_staff/view/pages/courses/course_category_screen.dart';
import 'package:breffini_staff/view/pages/courses/students_with_course_screen.dart';
import 'package:breffini_staff/view/widgets/login_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CourseListPage extends StatefulWidget {
  final bool isFromProfile;
  const CourseListPage({super.key, required this.isFromProfile});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final CourseContentController courseContentController =
      Get.find<CourseContentController>();

  final CourseModuleController controller = Get.find<CourseModuleController>();
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final callandChatController = Get.put(CallandChatController());

  @override
  void initState() {
    if (!widget.isFromProfile) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        courseContentController.getHodCourse();
      });
      super.initState();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<HodCourseModel> get filteredCourses {
    if (searchQuery.value.isEmpty) {
      return courseContentController.hodCourseList;
    }
    return courseContentController.hodCourseList.where((course) {
      final courseName = course.courseName?.toLowerCase() ?? '';
      return courseName.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorResources.colorgrey200,
          appBar: widget.isFromProfile
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    color: ColorResources.colorwhite,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color:
                                      ColorResources.colorBlack.withOpacity(.4),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Assigned Courses',
                            style: GoogleFonts.plusJakartaSans(
                              color: ColorResources.colorBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : CustomAppBar(
                  labelText: 'Search Course',
                  isStudentList: false,
                  onChanged: (value) {
                    searchQuery.value = value;
                  },
                  title: "Courses",
                  controller: searchController,
                ),
          body: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: _buildViewhierarchy(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewhierarchy() {
    final courses = filteredCourses;

    if (courses.isEmpty && searchQuery.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 48,
              color: ColorResources.colorBlue100,
            ),
            const SizedBox(height: 16),
            Text(
              'No courses found for "${searchQuery.value}"',
              style: GoogleFonts.plusJakartaSans(
                color: ColorResources.colorgrey600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: courses.length,
      itemBuilder: (context, index) {
        HodCourseModel model = courses[index];
        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: AppDecoration.outlineIndigo5001.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${HttpUrls.imgBaseUrl}${model.thumbnailPath}',
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: ColorResources.colorBlue600,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: ColorResources.colorBlue100,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Text(
                                  model.courseName ?? 'No name',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall!
                                      .copyWith(height: 1.43),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  model.price != null
                                      ? model.price == '0.00'
                                          ? 'Free'
                                          : '₹ ${model.price}'
                                      : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall!
                                      .copyWith(height: 1.43),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonWidget(
                        fontSize: 12,
                        width: Get.width / 2.5,
                        height: 35,
                        context: context,
                        backgroundColor: ColorResources.colorBlue600,
                        txtColor: ColorResources.colorwhite,
                        text: 'View Students',
                        onPressed: () async {
                          await callandChatController
                              .getStudentListCourse(model.courseId.toString());
                          callandChatController.getStudentCourseList.isNotEmpty
                              ? Get.to(() => const StudentsWithCourseScreen())
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('No students to show')));
                        },
                      ),
                      buttonWidget(
                        fontSize: 12,
                        width: Get.width / 2.5,
                        height: 35,
                        context: context,
                        backgroundColor: ColorResources.colorBlue600,
                        txtColor: ColorResources.colorwhite,
                        text: 'Course Details',
                        onPressed: () {
                          // await controller.getCourseInfo(
                          //     courseId: model.courseId ?? 0);
                          // await controller.getCoursesModules(
                          //     courseId: model.courseId.toString());

                          Get.to(() => CourseCategoryDetailsScreen(
                                courseId: model.courseId ?? 0,
                                isFromBatch: false,
                              ));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
