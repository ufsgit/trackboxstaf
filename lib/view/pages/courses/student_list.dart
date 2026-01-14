import 'dart:developer';
import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/controller/individual_call_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/core/utils/common_utils.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/key_center.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/http/chat_socket.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/view/pages/calls/incoming_call_screen.dart';
import 'package:breffini_staff/view/pages/calls/teacher_initiate_call_screen.dart';
import 'package:breffini_staff/view/pages/calls/widgets/google_meet.dart';
import 'package:breffini_staff/view/pages/calls/widgets/handle_new_call.dart';
import 'package:breffini_staff/view/pages/chats/chat_firebase_screen.dart';
import 'package:breffini_staff/view/pages/chats/widgets/custom_appbar_widget.dart';
import 'package:breffini_staff/view/pages/home_screen.dart';
import 'package:breffini_staff/view/pages/profile/profile_view_page.dart';
import 'package:breffini_staff/view/widgets/common_widgets.dart';
import 'package:breffini_staff/view/widgets/home_screen_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentList extends StatefulWidget {
  final String batchId;
  const StudentList({super.key, required this.batchId});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final CallandChatController callandChatController =
      Get.put(CallandChatController());
  final IndividualCallController controller =
      Get.put(IndividualCallController());
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  String formatTime(String time24Hour) {
    try {
      DateTime time = DateFormat("HH:mm").parse(time24Hour);
      return DateFormat("h:mm a").format(time);
    } catch (e) {
      log("Error formatting time: $e");
      return "Invalid time";
    }
  }

  bool isCurrentTimeInRange(String startTime, String endTime) {
    try {
      DateTime now = DateTime.now();
      DateTime start = DateFormat("HH:mm").parse(startTime);
      DateTime end = DateFormat("HH:mm").parse(endTime);
      start = DateTime(now.year, now.month, now.day, start.hour, start.minute);
      end = DateTime(now.year, now.month, now.day, end.hour, end.minute);

      DateTime current =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);

      log("Current Time: ${current.toString()}");
      log("Start Time: ${start.toString()}");
      log("End Time: ${end.toString()}");

      return current.isAtSameMomentAs(start) ||
          (current.isAfter(start) && current.isBefore(end));
    } catch (e) {
      log("Error parsing time: $e");
      return false;
    }
  }

  Future<bool> _onWillPop() async {
    // Navigate to HomePage and clear the navigation stack
    Get.back();
    return false; // Prevents default back action
  }

  void showAlertDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Can't Connect",
                style: TextStyle(
                    fontSize: 18.w,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff283B52)),
              ),
              // IconButton(
              //     onPressed: () {
              //       Get.back();
              //     },
              //     icon: Icon(Icons.close_sharp))
            ],
          ),
          content: Text(
            "Calls Allowed Only During Available Hours",
            style: GoogleFonts.plusJakartaSans(),
          ),
          actions: [
            TextButton(
              child: Text(
                'Back',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: ColorResources.colorgrey200,
            appBar: CustomAppBar(
              labelText: 'Search Student',
              isStudentList: true,
              onChanged: (value) {
                searchQuery.value = value;
              },
              title: 'Student list',
              controller: searchController,
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Obx(() {
                var filteredList = callandChatController.getStudentList
                    .where((slot) => slot.firstName
                        .toLowerCase()
                        .contains(searchQuery.value.toLowerCase()))
                    .toList();
                return Column(
                  children: [
                    Expanded(
                        child: searchQuery.value.isNotEmpty &&
                                filteredList.isEmpty
                            ? Center(
                                child: Text(
                                  'No students available',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorResources.colorgrey500,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredList.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final slot = filteredList[index];

                                  log("Slot ${index + 1}: ${slot.firstName}");

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                      InkWell(
                                          // onTap: () async {
                                          //   final prefs =
                                          //       await SharedPreferences
                                          //           .getInstance();
                                          //   String userTypeId = prefs.getString(
                                          //           'user_type_id') ??
                                          //       '2';
                                          //   final String teacherId =
                                          //       prefs.getString(
                                          //               'breffini_teacher_Id') ??
                                          //           "0";

                                          //   log('loader showing ?????????');
                                          //   await ChatSocket
                                          //       .joinConversationRoom(
                                          //           slot.studentId.toString(),
                                          //           int.parse(teacherId),
                                          //           userTypeId == '2'
                                          //               ? 'teacher_student'
                                          //               : 'hod_student');
                                          //   Get.to(() => ChatFireBaseScreen(
                                          //       isDeletedUser: false,
                                          //       studentId:
                                          //           slot.studentId.toString(),
                                          //       profileUrl:
                                          //           '${HttpUrls.imgBaseUrl}${slot.profilePhotoPath}',
                                          //       studentName: slot.firstName,
                                          //       contactDetails:
                                          //           slot.phoneNumber,
                                          //       courseId: userTypeId == '2'
                                          //           ? '0'
                                          //           : '${slot.courseId}Hod',
                                          //       userType: userTypeId));
                                          // },
                                          child: ListTile(
                                        leading: InkWell(
                                          onTap: () {
                                            Get.to(() => ProfileViewPage(
                                                profileUrl:
                                                    HttpUrls.imgBaseUrl +
                                                        slot.profilePhotoPath,
                                                studentName:
                                                    '${slot.firstName} ${slot.lastName}',
                                                contactDetails:
                                                    slot.email.isNotEmpty
                                                        ? slot.email
                                                        : slot.phoneNumber,
                                                studentId:
                                                    slot.studentId.toString(),
                                                courseId:
                                                    slot.courseId.toString()));
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: CircleAvatar(
                                              radius: 23.r,
                                              child: CachedNetworkImage(
                                                imageUrl: HttpUrls.imgBaseUrl +
                                                    slot.profilePhotoPath,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: Colors.blue,
                                                  strokeWidth: 2,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                  child: Icon(
                                                    Icons.person_rounded,
                                                    color: ColorResources
                                                        .colorBlack
                                                        .withOpacity(.7),
                                                    size: 25.w,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          '${slot.firstName} ${slot.lastName}',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: ColorResources.colorBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    String userTypeId =
                                                        prefs.getString(
                                                                'user_type_id') ??
                                                            '2';
                                                    final String teacherId =
                                                        prefs.getString(
                                                                'breffini_teacher_Id') ??
                                                            "0";

                                                    log('loader showing ?????????');
                                                    await ChatSocket
                                                        .joinConversationRoom(
                                                            slot.studentId
                                                                .toString(),
                                                            int.parse(
                                                                teacherId),
                                                            userTypeId == '2'
                                                                ? 'teacher_student'
                                                                : 'hod_student');
                                                    Get.to(() => ChatFireBaseScreen(
                                                        isDeletedUser: false,
                                                        studentId: slot
                                                            .studentId
                                                            .toString(),
                                                        profileUrl:
                                                            '${HttpUrls.imgBaseUrl}${slot.profilePhotoPath}',
                                                        studentName:
                                                            slot.firstName,
                                                        contactDetails:
                                                            slot.phoneNumber,
                                                        courseId: userTypeId ==
                                                                '2'
                                                            ? '0'
                                                            : '${slot.courseId}Hod',
                                                        userType: userTypeId));
                                                  },
                                                  child: iconProfileWidget(
                                                      height: 35,
                                                      width: 35,
                                                      svgIcon:
                                                          'assets/images/ic_icon_profile_chat.svg'),
                                                ),
                                                SizedBox(
                                                  width: 12.h,
                                                ),
                                                InkWell(
                                                  onTap: PrefUtils()
                                                          .getMeetLink()
                                                          .isNotEmpty
                                                      ? () async {
                                                          await handleCall(
                                                            studentId: slot
                                                                .studentId
                                                                .toString(),
                                                            studentName:
                                                                slot.firstName,
                                                            callId: '',
                                                            isVideo: true,
                                                            profileImageUrl: slot
                                                                .profilePhotoPath,
                                                            liveLink: PrefUtils()
                                                                .getMeetLink(),
                                                            controller:
                                                                controller,
                                                            callandChatController:
                                                                callandChatController,
                                                            safeBack: safeBack,
                                                          );
                                                          setState(() {});

                                                          MeetCallTracker(
                                                            onCallEnded: () {},
                                                          ).startMeetCall(
                                                              meetCode: PrefUtils()
                                                                  .getMeetLink());
                                                        }
                                                      : () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Create a google meet link to initiate call')));
                                                        },
                                                  // onTap: () async {
                                                  //   // Get.to(() =>
                                                  //   //     TeacherInitiateCallScreen(
                                                  //   //         studentId:
                                                  //   //             slot.studentId,
                                                  //   //         video: true));
                                                  //   if (!await isCallExist(
                                                  //       context,
                                                  //       callandChatController)) {
                                                  //     Get.to(() =>
                                                  //         IncomingCallPage(
                                                  //           liveLink: "",
                                                  //           callId: "",
                                                  //           studentId: slot
                                                  //               .studentId
                                                  //               .toString(),
                                                  //           video: true,
                                                  //           profileImageUrl: slot
                                                  //               .profilePhotoPath,
                                                  //           studentName:
                                                  //               slot.firstName,
                                                  //         ));
                                                  //   }
                                                  // },
                                                  child: iconProfileWidget(
                                                      height: 35,
                                                      width: 35,
                                                      svgIcon:
                                                          'assets/images/ic_icon_profile_video.svg'),
                                                ),
                                                SizedBox(
                                                  width: 12.h,
                                                ),
                                                InkWell(
                                                  onTap: PrefUtils()
                                                          .getMeetLink()
                                                          .isNotEmpty
                                                      ? () async {
                                                          await handleCall(
                                                            studentId: slot
                                                                .studentId
                                                                .toString(),
                                                            studentName:
                                                                slot.firstName,
                                                            callId: '',
                                                            isVideo: true,
                                                            profileImageUrl: slot
                                                                .profilePhotoPath,
                                                            liveLink: PrefUtils()
                                                                .getMeetLink(),
                                                            controller:
                                                                controller,
                                                            callandChatController:
                                                                callandChatController,
                                                            safeBack: safeBack,
                                                          );
                                                          setState(() {});

                                                          MeetCallTracker(
                                                            onCallEnded: () {},
                                                          ).startMeetCall(
                                                              meetCode: PrefUtils()
                                                                  .getMeetLink());
                                                        }
                                                      : () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Create a google meet link to initiate call')));
                                                        },
                                                  // onTap: () async {
                                                  //   // Get.to(() =>
                                                  //   //     TeacherInitiateCallScreen(
                                                  //   //         studentId:
                                                  //   //             slot.studentId,
                                                  //   //         video: false));
                                                  //   if (!await isCallExist(
                                                  //       context,
                                                  //       callandChatController)) {
                                                  //     Get.to(() =>
                                                  //         IncomingCallPage(
                                                  //           liveLink: "",
                                                  //           callId: "",
                                                  //           studentId: slot
                                                  //               .studentId
                                                  //               .toString(),
                                                  //           video: false,
                                                  //           profileImageUrl: slot
                                                  //               .profilePhotoPath,
                                                  //           studentName:
                                                  //               slot.firstName,
                                                  //         ));
                                                  //   }
                                                  // },
                                                  child: iconProfileWidget(
                                                      height: 35,
                                                      width: 35,
                                                      svgIcon:
                                                          'assets/images/ic_icon_profile_call.svg'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                    ],
                                  );
                                },
                              ))
                  ],
                );
              }),
            )),
      ),
    );
  }
}
