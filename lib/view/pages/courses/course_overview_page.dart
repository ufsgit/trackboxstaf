import 'package:breffini_staff/core/theme/custom_text_style.dart';
import 'package:breffini_staff/core/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseOverviewPage extends StatefulWidget {
  final String description;
  const CourseOverviewPage({super.key, required this.description});

  @override
  State<CourseOverviewPage> createState() => _CourseOverviewPageState();
}

class _CourseOverviewPageState extends State<CourseOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          widget.description != ''
              ? _buildLearningOutcomesColumn()
              : Column(
                  children: [
                    SizedBox(
                      height: Get.height / 4.5,
                    ),
                    Center(child: Text('No overview')),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildLearningOutcomesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "What you’ll learn".tr,
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(widget.description),
      ],
    );
  }

  /// Section Widget
  Widget _buildCourseOverviewRow() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 36),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "4".tr,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 1),
                Text(
                  "Weeks".tr,
                  style: CustomTextStyles.labelLargeBluegray500Medium,
                )
              ],
            ),
            const Spacer(
              flex: 53,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "56".tr,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 1),
                Text(
                  "Classes".tr,
                  style: CustomTextStyles.labelLargeBluegray500Medium,
                )
              ],
            ),
            const Spacer(
              flex: 46,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "56".tr,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 1),
                Text(
                  "Resourses".tr,
                  style: CustomTextStyles.labelLargeBluegray500Medium,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "14/32".tr,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "Tests".tr,
                    style: CustomTextStyles.labelLargeBluegray500Medium,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
