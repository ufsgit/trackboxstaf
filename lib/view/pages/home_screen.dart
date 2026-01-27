import 'dart:convert';
import 'dart:io';

import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/controller/individual_call_controller.dart';
import 'package:breffini_staff/controller/ongoing_call_controller.dart';
import 'package:breffini_staff/controller/profile_controller.dart';
import 'package:breffini_staff/core/utils/common_utils.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/file_utils.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/core/utils/key_center.dart';
import 'package:breffini_staff/core/utils/native_utils.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/http/chat_socket.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/http/notification_permission_handler.dart';
import 'package:breffini_staff/http/notification_service.dart';
import 'package:breffini_staff/main.dart';
import 'package:breffini_staff/model/current_call_model.dart';
import 'package:breffini_staff/model/ongoing_call_model.dart';
import 'package:breffini_staff/testpage/exams_page.dart';
import 'package:breffini_staff/view/pages/calls/incoming_call_screen.dart';
import 'package:breffini_staff/view/pages/calls/widgets/google_meet.dart';
import 'package:breffini_staff/view/pages/calls/widgets/handle_new_call.dart';
import 'package:breffini_staff/view/pages/calls/widgets/no_internet_widget.dart';
import 'package:breffini_staff/view/pages/chats/chat_firebase_screen.dart';
import 'package:breffini_staff/view/pages/chats/widgets/loading_circle.dart';
import 'package:breffini_staff/view/pages/courses/course_list_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_callkit_incoming_yoer/entities/android_params.dart';
import 'package:flutter_callkit_incoming_yoer/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming_yoer/entities/ios_params.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/pages/calls/one_to_one_call_screen.dart';
import 'package:breffini_staff/view/pages/chats/student_chat_history_screen.dart';
import 'package:breffini_staff/view/pages/calls/call_log_screen.dart';
import 'package:breffini_staff/view/pages/live/live_page.dart';
import 'package:breffini_staff/view/pages/profile/profile_screen.dart';
import 'package:breffini_staff/testpage/student_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/scheduler.dart' as scheduler;

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  bool _isLivePageVisible = true;
  final CallandChatController callandChatController =
      Get.put<CallandChatController>(CallandChatController());
  final IndividualCallController controller =
      Get.put(IndividualCallController());

  AndroidNotificationChannel? channel;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<Widget> _pages = [
    const TeacherChatHistoryScreen(),
    // const CallLogScreen(),
    const OneToOneCallScreen(),
    ExamsScreen(),
    const LivePage(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    Get.put(ProfileController());

    super.initState();
    _selectedIndex = widget.initialIndex;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _loadUserType();
      initPermission();
      getInitialData();
      listenCalls();
      initLocalNotification();
    });
  }

  initPermission() async {
    await NativeUtils.requestFullScreenIntentPermission();

    await Future.delayed(const Duration(seconds: 3), () async {
      await NativeUtils.requestBatteryOptimization();
    });
  }

  getInitialData() {
    ChatSocket.emitOngoingCalls(); // used to listen calls when first login...
    FirebaseUtils.listenCalls();

    Get.put(ProfileController()).fetchTeacherProfile(showLoader: false);
  }

  Future<void> _loadUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('breffini_token');
    if (token != null) {
      String userTypeId = preferences.getString('user_type_id') ?? '2';

      if (userTypeId == '3') {
        setState(() {
          _isLivePageVisible = false;
          // Index 3 is LivePage/Courses in the list [Chats, OneOne, Exams, LivePage, Profile]
          if (_pages.length > 3) {
            _pages[3] = const CourseListPage(
              isFromProfile: false,
            );
          }

          // _pages.removeAt(3);
        });
      }
    }
  }

  // to handle call notification
  listenCalls() async {
    getCurrentCall();

    ChatSocket().listenCurrentCall((status, callId) {
      if (status) {
        // ChatSocket().removeCallStatusListener();
        if (mounted) {
          FlutterCallkitIncoming.endAllCalls();
          // if (Get.currentRoute == "/IncomingCallPage") {
          //   safeBack();
          //   Get.showSnackbar(const GetSnackBar(
          //     message: 'Call Rejected',
          //     duration: Duration(milliseconds: 2000),
          //   ));
          // } else {
          //   FlutterCallkitIncoming.endAllCalls();
          // }
        }
      }
    });
  }

  Future getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        // _currentUuid = calls[0]['id'];
        if (calls[0].length > 0) {
          bool isAccepted = calls[0]["accepted"];
          var payload = calls[0]["extra"];
          String callId = payload!['id'] ?? '';

          if (isAccepted) {
            int studentId = int.parse(payload!['student_id'] ?? "0");

            if (await FirebaseUtils.checkIfCallExists(
                studentId.toString(), callId)) {
              String liveLink = payload!['Live_Link'] ?? '';
              if (!liveLink.isNullOrEmpty()) {
                String callId = payload!['id'] ?? '';
                String callType = payload!['call_type'] ?? '';
                String profileImgUrl = payload!.containsKey("profile_url")
                    ? payload!['profile_url'] ?? ""
                    : "";
                String callerName = payload!.containsKey("student_name")
                    ? payload!['student_name'] ?? ""
                    : "";
                await handleCall(
                  studentId: studentId.toString(),
                  studentName: callerName,
                  callId: callId,
                  isVideo: true,
                  profileImageUrl: profileImgUrl,
                  liveLink: liveLink,
                  controller: controller,
                  callandChatController: callandChatController,
                  safeBack: safeBack,
                );

                MeetCallTracker(
                  onCallEnded: () {},
                ).startMeetCall(meetCode: liveLink);
              }
            }
          }
        }
      } else {
        // _currentUuid = "";
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationPermissionHandler(
        onPermissionChanged: (isGranted) {
          setState(() {});
        },
        child: SafeArea(
          child: Obx(() {
            return profileController.isLoadingProfile.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const LoadingCircle(),
                  )
                : NoInternetScreen(
                    onConnected: () {
                      getInitialData();
                    },
                    child: Column(
                      children: [
                        if (!callandChatController.currentCallModel.value.callId
                                .isNullOrEmpty() &&
                            callandChatController.audioCallFormatedTime.value !=
                                "00:00")
                          Container(
                              height: 70.h,
                              margin: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // InkWell(
                                  //   onTap: () async {
                                  //     ZegoUIKit().turnMicrophoneOn(!ZegoUIKit()
                                  //         .getMicrophoneStateNotifier(
                                  //             ZegoUIKit().getLocalUser().id)
                                  //         .value);
                                  //   },
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(0.0),
                                  //     child: Card(
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(50)),
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Icon(
                                  //           ZegoUIKit()
                                  //                   .getMicrophoneStateNotifier(
                                  //                       ZegoUIKit()
                                  //                           .getLocalUser()
                                  //                           .id)
                                  //                   .value
                                  //               ? Icons.mic
                                  //               : Icons.mic_off,
                                  //           color: Colors.red,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      // ZegoUIKitPrebuiltCallController()
                                      //     .minimize
                                      //     .restore(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.call,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          "${callandChatController.currentCallModel.value.callerName!}   ${callandChatController.audioCallFormatedTime.value}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      // await ZegoUIKit().leaveRoom();
                                      CallandChatController callChatController =
                                          Get.find();
                                      callChatController.disconnectCall(
                                          true,
                                          false,
                                          callChatController
                                              .currentCallModel.value.callerId!,
                                          callChatController.currentCallModel
                                                  .value.callId ??
                                              "");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.call_end,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        Expanded(child: _pages.elementAt(_selectedIndex)),
                      ],
                    ),
                  );
          }),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ColorResources.colorgrey300,
              width: 1,
            ),
          ),
        ),
        height: 92.h,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                width: 25.w,
                child: SvgPicture.asset(
                  _selectedIndex == 0
                      ? 'assets/images/ic_icon_chat_filled.svg'
                      : 'assets/images/ic_icon_chat.svg',
                ),
              ),
              label: 'Chats',
            ),
            // BottomNavigationBarItem(
            //   icon: SizedBox(
            //     height: 25.h,
            //     width: 25.w,
            //     child: SvgPicture.asset(
            //       _selectedIndex == 1
            //           ? 'assets/images/ic_icon_phone_filled.svg'
            //           : 'assets/images/ic_icon_phone.svg',
            //     ),
            //   ),
            //   label: 'Calls',
            // ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                width: 25.w,
                child: SvgPicture.asset(
                  _selectedIndex == 1
                      ? 'assets/images/ic_connect_filled.svg'
                      : 'assets/images/ic_connect.svg',
                ),
              ),
              label: 'One-one',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2 ? Icons.school : Icons.school_outlined,
              ),
              label: 'Exams',
            ),
            // if (_isLivePageVisible)
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                width: 25.w,
                child: SvgPicture.asset(
                  _selectedIndex == 3
                      ? 'assets/images/batch_filled.svg'
                      : 'assets/images/batch.svg',
                ),
              ),
              label: _isLivePageVisible ? 'Courses' : 'Courses',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                width: 25.w,
                child: SvgPicture.asset(
                  _selectedIndex == 4
                      ? 'assets/images/ic_icon_profile_filled.svg'
                      : 'assets/images/ic_icon_profile.svg',
                ),
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorResources.colorBlue600,
          unselectedItemColor: ColorResources.colorgrey400,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.plusJakartaSans(
            color: ColorResources.colorBlue600,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            color: ColorResources.colorgrey500,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          iconSize: 26.sp,
        ),
      ),
    );
  }

  Future<void> initLocalNotification() async {
    AndroidNotificationChannel? channel;

    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (response) {
      Map<String, dynamic> payLoad = {};
      if (!response.payload.isNullOrEmpty()) {
        payLoad = jsonDecode(response.payload!);
        handleNotificationClick(payLoad);
      }
      // handle interaction when app is active for android
      // handleMessage(message,context);
    });
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.max,
      );
    }
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    if (!kIsWeb) {
      firebaseMessaging.subscribeToTopic("TCR-${PrefUtils().getTeacherId()}");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("");
      showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;
      String imgUrl = "";

      if (notification != null) {
        if (null != android && !android.imageUrl.isNullOrEmpty()) {
          imgUrl = android.imageUrl ?? "";
        }
        if (null != apple && !apple.imageUrl.isNullOrEmpty()) {
          imgUrl = apple.imageUrl ?? "";
        }
        Map<String, dynamic> newData1 = {
          'body': notification.body,
          'title': notification.title,
          'imageUrl': imgUrl,
        };
        data.addAll(newData1);
        handleNotificationClick(data);
      }
    });
    //This method will call when the app is in kill state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;
      AppleNotification? apple = message?.notification?.apple;
      String imgUrl = "";

      if (notification != null) {
        if (null != android && !android.imageUrl.isNullOrEmpty()) {
          imgUrl = android.imageUrl ?? "";
        }
        if (null != apple && !apple.imageUrl.isNullOrEmpty()) {
          imgUrl = apple.imageUrl ?? "";
        }
        Map<String, dynamic> data = message!.data;
        Map<String, dynamic> newData1 = {
          'body': notification.body,
          'title': notification.title,
          'imageUrl': imgUrl,
        };
        data.addAll(newData1);
        handleNotificationClick(data);
      }
    });
  }

  handleNotificationClick(Map<String, dynamic> payLoad) async {
    String type = payLoad.containsKey("type") ? payLoad['type'] : "";
    if (type == "new_message") {
      if (!callandChatController.currentCallModel.value.callId
          .isNullOrEmpty()) {
        // await handleChatNotification();
        // _onItemTapped(0);
        // if (!ZegoUIKitPrebuiltCallController().minimize.isMinimizing) {
        //   ZegoUIKitPrebuiltCallController().minimize.minimize(
        //         navigatorKey.currentContext ?? Get.context!,
        //         rootNavigator: true,
        //       );
        // }
      }
      String senderId = payLoad['sender_id'];
      String senderName = payLoad['senderName'];
      final prefs = await SharedPreferences.getInstance();
      String userTypeId = prefs.getString('user_type_id') ?? '2';
      String courseId = payLoad['course_id'];
      String profileUrl = payLoad['profileUrl'] ?? "";
      Get.to(() => ChatFireBaseScreen(
          isDeletedUser: false,
          studentId: senderId,
          profileUrl: FileUtils.getFileExtension(profileUrl).isNullOrEmpty()
              ? ""
              : profileUrl,
          studentName: senderName,
          contactDetails: "",
          courseId: userTypeId == '2' ? '0' : '${courseId}Hod',
          userType: userTypeId));
    } else if (type == "new_call") {
      // if (!Get.currentRoute.isNullOrEmpty() &&
      //     Get.currentRoute != "/IncomingCallPage") {
      //   CurrentCallModel callModel = CurrentCallModel.fromMap(payLoad);
      //
      //
      //  String liveLink = payLoad['Live_Link'];
      //  String callId = payLoad['id'];
      //  String callerId = payLoad['receiver_id'];
      //  bool isVideo = payLoad['call_type']=="Video";
      //  String profileImg = payLoad['Profile_Photo_Img'];
      //  String callerName = payLoad['Caller_Name'];

      // }
      _selectedIndex = 1;
      setState(() {});
    }
  }

  Future<void> showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;
    String imgUrl = "";
    if (message.data.isNotEmpty) {
      // Convert message.data from Map<String, dynamic> to Map<String, String?>
      final Map<String, String?> payload =
          message.data.map((key, value) => MapEntry(key, value.toString()));

      // Determine the channel key based on the payload
      String channelKey = ""; // Default channel

      if (payload['type'] == 'new_call') {
        channelKey = 'call_channel'; // Use the call channel
      } else
      // if (payload['type'] == 'new_message')
      {
        channelKey = 'message_channel'; // Use the message channel
      }
      String liveLink = message.data.containsKey("Live_Link")
          ? message.data['Live_Link']
          : "";
      int id = message.data.containsKey("id")
          ? int.parse(message.data['id'])
          : message.hashCode;
      if (payload['type'] != 'new_call') {
        // showing notification and ring then ringing go behind notification fix

        Map<String, dynamic> data = message.data;
        Map<String, dynamic> newData1 = {
          'body': notification?.body,
          'title': notification?.title,
          'imageUrl': imgUrl,
        };
        data.addAll(newData1);

        flutterLocalNotificationsPlugin
            .show(
          payload: jsonEncode(data),
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            iOS:
                // filename.isNullOrEmpty()?
                null,
            //     :
            // DarwinNotificationDetails(
            //   presentAlert: true,
            //   presentBadge: true,
            //   presentSound: true,
            //   attachments: [
            //     DarwinNotificationAttachment(filename)
            //   ],
            // ),
            android: AndroidNotificationDetails(
              "high_importance_channel", channelKey,
              // channelDescription: channel!.description,
              importance: Importance.max,
              // priority: Priority.high,
              fullScreenIntent: false, onlyAlertOnce: true,
              autoCancel:
                  true, //cause message always showing when chat msg arrives
              ongoing: false, silent: false, enableVibration: false,
              category: AndroidNotificationCategory.message,
              visibility: NotificationVisibility.public,
              // styleInformation: styleInformation
            ),
          ),
        )
            .then((value) {
          // if(File(filename).existsSync()){
          //   File(filename).delete();
          // }
        });
      }
      // if (Get.currentRoute != "/IncomingCallPage") {
      // hide already started cales
      // String profileImgUrl = message.data.containsKey("Profile_Photo_Img")
      //     ? message.data['Profile_Photo_Img']
      //     : "";
      // String callId =
      //     message.data.containsKey("id") ? message.data['id'] : "";
      // String callerName = message.data.containsKey("Caller_Name")
      //     ? message.data['Caller_Name']
      //     : "";
      // String callType = message.data.containsKey("call_type")
      //     ? message.data['call_type']
      //     : "";

      // if(channelKey == "call_channel"){
      //   //checking notification call id is current call id in server.(to handle delayed notification showing call screen)
      //   List<OnGoingCallsModel> callList =
      //   await Get.put(CallOngoingController()).getOngoingCallsApi();
      //   if(callList.isNotEmpty && callList[0].id.toString()==callId) {
      //     if (!callId.isNullOrEmpty()) {
      //
      //       // to handle duplicate notification
      //       var calls = await FlutterCallkitIncoming.activeCalls();
      //       if (calls is List && calls.isNotEmpty && calls.isNotEmpty) {
      //         if (!calls.any((value) => value["id"].toString() == callId)) {
      //           showCallkitIncoming(
      //               callId, callerName, profileImgUrl, callType, message.data);
      //         }
      //       } else {
      //         showCallkitIncoming(
      //             callId, callerName, profileImgUrl, callType, message.data);
      //       }
      //     }
      //   }else{
      //     // remove all calls when no current call at server
      //     await FlutterCallkitIncoming.endAllCalls();
      //   }
      //
      // }else{
      // if (payload['type'] != 'new_call') {
      //   // showing notification and ring then ringing go behind notification fix
      //
      //   Map<String, dynamic> data = message.data;
      //   Map<String, dynamic> newData1 = {
      //     'body': notification?.body,
      //     'title': notification?.title,
      //     'imageUrl': imgUrl,
      //   };
      //   data.addAll(newData1);
      //
      //   flutterLocalNotificationsPlugin
      //       .show(
      //     payload: jsonEncode(data),
      //     notification.hashCode,
      //     notification?.title,
      //     notification?.body,
      //     NotificationDetails(
      //       iOS:
      //           // filename.isNullOrEmpty()?
      //           null,
      //       //     :
      //       // DarwinNotificationDetails(
      //       //   presentAlert: true,
      //       //   presentBadge: true,
      //       //   presentSound: true,
      //       //   attachments: [
      //       //     DarwinNotificationAttachment(filename)
      //       //   ],
      //       // ),
      //       android: AndroidNotificationDetails(
      //         "high_importance_channel", channelKey,
      //         // channelDescription: channel!.description,
      //         enableLights: true,
      //         fullScreenIntent: true,
      //         //      one that already exists in example app.
      //         // icon: "resource://drawable/res_app_icon",
      //         // largeIcon:
      //         //     const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      //         color: Colors.blueAccent,
      //         enableVibration: true,
      //         playSound: true,
      //         channelShowBadge: true,
      //         // styleInformation: styleInformation
      //       ),
      //     ),
      //   )
      //       .then((value) {
      //     // if(File(filename).existsSync()){
      //     //   File(filename).delete();
      //     // }
      //   });
      // }
      // AwesomeNotifications().createNotification(
      //   actionButtons: channelKey == "call_channel" ? [
      //     NotificationActionButton(
      //         key: 'reject_btn', label: 'Reject', color: Colors.red),
      //     NotificationActionButton(
      //         key: 'accept_btn', label: 'Accept', color: Colors.green),
      //   ] : [],
      //   content: NotificationContent(
      //     id: id,
      //     channelKey: channelKey,
      //     title: message.notification?.title,
      //     body: message.notification?.body,
      //     payload: payload,
      //     largeIcon: HttpUrls.imgBaseUrl + profileImgUrl,
      //     roundedLargeIcon: true,wakeUpScreen: true,
      //
      //   ),
      // );
      // }
      //
      // if(Get.currentRoute=="/IncomingCallPage" && channelKey == "call_channel" ) {
      //   // AwesomeNotifications().cancel(id);
      // }
      // }
    }
  }
}
