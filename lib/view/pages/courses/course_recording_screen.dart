import 'dart:async';
import 'package:breffini_staff/controller/course_module_controler.dart';
import 'package:breffini_staff/controller/home_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/core/theme/custom_text_style.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/view/pages/chats/widgets/custom_appbar_widget.dart';
import 'package:breffini_staff/view/pages/courses/widgets/size_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class CourseRecordingsScreen extends StatefulWidget {
  const CourseRecordingsScreen({
    Key? key,
    required this.courseId,
  }) : super(
          key: key,
        );
  final String? courseId;

  @override
  State<CourseRecordingsScreen> createState() => _CourseRecordingsScreenState();
}

class _CourseRecordingsScreenState extends State<CourseRecordingsScreen>
    with SingleTickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());
  CourseModuleController courseContentController =
      Get.put(CourseModuleController());

  late FlickManager flickManager;
  final ScrollController _scrollController = ScrollController();
  late Future<void> _initializeVideoPlayerFuture;
  int? bufferDelay;
  bool _showControls = false;

  String? _videoUrl;
  int? selectedIndex = 0;

  Timer? _hideControlsTimer;
  String selectedPdfUrl = '';
  int currPlayIndex = 0;
  late Animation<double> animation;
  late AnimationController controller;
  bool _isAnimating = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    // getData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
    super.initState();
  }

  getData() async {
    await courseContentController
        .getRecordings(courseId: widget.courseId.toString())
        .then((v) {
      flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(_videoUrl ?? '')),
      );
      _initializeVideoPlayerFuture = Future.value();

      initializePlayer();
    });
  }

  void showVideo(String url) {
    setState(() {
      _videoUrl = url;
      flickManager.flickControlManager?.pause();
      flickManager.dispose();

      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
            Uri.parse('${HttpUrls.imgBaseUrl}$url')),
      );
      flickManager.flickControlManager?.play();
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    setState(() {});
  }

  Future<void> toggleVideo() async {
    await initializePlayer();
  }

  double _playbackSpeed = 1.0;
  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      flickManager.flickControlManager?.setPlaybackSpeed(speed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
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
                  'Course details',
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
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(() {
                      return courseContentController.recordings.isNotEmpty
                          ? Column(
                              children: [
                                Container(
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      FlickVideoPlayer(
                                          flickManager: flickManager =
                                              FlickManager(
                                        videoPlayerController:
                                            VideoPlayerController.networkUrl(
                                                Uri.parse(
                                                    '${HttpUrls.imgBaseUrl}${courseContentController.recordings.isNotEmpty ? courseContentController.recordings[0].recordClassLink : ''}' ??
                                                        '')),
                                      )),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: PopupMenuButton(
                                          color: Colors.white,
                                          iconColor: Colors.grey.shade600,
                                          itemBuilder: (c) => [
                                            PopupMenuItem(
                                              onTap: () =>
                                                  _changePlaybackSpeed(0.5),
                                              child: const Text(
                                                '0.5x',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () =>
                                                  _changePlaybackSpeed(1.0),
                                              child: const Text(
                                                '1x',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () =>
                                                  _changePlaybackSpeed(1.5),
                                              child: const Text(
                                                '1.5x',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () =>
                                                  _changePlaybackSpeed(2),
                                              child: const Text(
                                                '2x',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: 322,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    homeController.title.value,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles.titleMedium18_1
                                        .copyWith(
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Videos',
                                      style: GoogleFonts.plusJakartaSans(
                                          color: ColorResources.colorgrey700,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  itemCount:
                                      courseContentController.recordings.length,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final recording = courseContentController
                                        .recordings[index];
                                    final isSelected = selectedIndex == index;

                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0),
                                          child: Material(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: BorderSide(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                            child: ListTile(
                                              onTap: () {
                                                isSelected
                                                    ? () {}
                                                    : setState(() {
                                                        selectedIndex = index;
                                                        _scrollController
                                                            .animateTo(
                                                          0.0,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve: Curves.easeOut,
                                                        );
                                                        showVideo(recording
                                                            .recordClassLink);
                                                      });
                                              },
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 0),
                                              dense: true,
                                              minVerticalPadding: 2,
                                              visualDensity:
                                                  VisualDensity.comfortable,
                                              title: Text(
                                                recording.recordClassLink,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14),
                                              ),
                                              leading: Container(
                                                  height: 44,
                                                  width: 48,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        '${HttpUrls.imgBaseUrl}${recording.thumbMailPath}',
                                                    fit: BoxFit.contain,
                                                    placeholder:
                                                        (BuildContext context,
                                                            String url) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                          color:
                                                              Colors.blueAccent,
                                                        ),
                                                      );
                                                    },
                                                    errorWidget:
                                                        (BuildContext context,
                                                            String url,
                                                            dynamic error) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported_outlined,
                                                          color: ColorResources
                                                              .colorBlue100,
                                                          size: 40,
                                                        ),
                                                      );
                                                    },
                                                  )),
                                              subtitle: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      recording.courseName,
                                                      style: GoogleFonts
                                                          .plusJakartaSans(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              ],
                            )
                          : SizedBox(
                              height: Get.height / 1.5,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: Text('No Recordings')),
                                ],
                              ),
                            );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

onTapArrowleftone() {
  Get.back();
}
