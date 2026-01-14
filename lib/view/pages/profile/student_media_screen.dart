import 'package:breffini_staff/controller/student_course_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/student_media_model.dart';
import 'package:breffini_staff/view/pages/chats/image_viewer_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentMediaScreen extends StatefulWidget {
  final String studentId;
  const StudentMediaScreen({super.key, required this.studentId});

  @override
  State<StudentMediaScreen> createState() => _StudentMediaScreenState();
}

class _StudentMediaScreenState extends State<StudentMediaScreen> {
  final StudentCourseController studentCourseController =
      Get.find<StudentCourseController>();

  Map<String, List<StudentMediaModel>> _groupMediaByDate() {
    final mediaMap = <String, List<StudentMediaModel>>{};
    final dateFormat = DateFormat('dd/MM/yyyy');

    for (var mediaItem in studentCourseController.studentMediaList) {
      final dateString = dateFormat.format(mediaItem.timestamp);
      if (!mediaMap.containsKey(dateString)) {
        mediaMap[dateString] = [];
      }
      mediaMap[dateString]!.add(mediaItem);
    }

    return mediaMap;
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().scheduleFrameCallback(
      (timeStamp) {
        studentCourseController.getMediaofStudent(widget.studentId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.colorgrey200,
      body: Obx(() {
        final mediaByDate = _groupMediaByDate();
        final dates = mediaByDate.keys.toList()..sort((a, b) => b.compareTo(a));

        return dates.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final mediaItems = mediaByDate[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: GoogleFonts.plusJakartaSans(
                          color: ColorResources.colorgrey700,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 70.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mediaItems.length,
                          itemBuilder: (context, index) {
                            final mediaItem = mediaItems[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 4.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => ImageViewerScreen(
                                        imageUrl: HttpUrls.imgBaseUrl +
                                            mediaItem.filePath,
                                      ));
                                },
                                child: SizedBox(
                                    width: 70.h,
                                    height: 70.h,
                                    child: CachedNetworkImage(
                                      imageUrl: HttpUrls.imgBaseUrl +
                                          mediaItem.filePath,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: ColorResources.colorBlue100,
                                          size: 40,
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: ColorResources.colorBlue500,
                                          value: downloadProgress.progress,
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  );
                },
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No media',
                    style: GoogleFonts.plusJakartaSans(
                      color: ColorResources.colorgrey700,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ));
      }),
    );
  }
}
