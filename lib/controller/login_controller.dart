import 'dart:developer';

import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/controller/live_controller.dart';
import 'package:breffini_staff/controller/ongoing_call_controller.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/teacher_login_model.dart';
import 'package:breffini_staff/view/pages/authentication/change_password_page.dart';
import 'package:breffini_staff/view/pages/authentication/login_page.dart';
import 'package:breffini_staff/view/pages/authentication/verify_otp_page.dart';
import 'package:breffini_staff/view/pages/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';

class LoginController extends GetxController {
  //loginpage controllers
  TextEditingController emailIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //verifyemailcontroller
  TextEditingController verifyEmailController = TextEditingController();
  //otp controller
  TextEditingController otpController = TextEditingController();
  //change password page controllers
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String fcmToken = "";
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  @override
  void onClose() {
    emailIDController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _checkLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('breffini_token');
    if (token != null) {
      isLoggedIn.value = true;
    }
  }

  Future<void> getFCMToken() async {
    // Ensure the function returns a Future and uses async/await
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print('print token $token');
      fcmToken = token ?? "";
      log('fmcToken  $fcmToken');
    } catch (e) {
      print('Failed to get FCM token: $e');
    }
  }

  Future<void> teacherLogin(TeacherLoginModel teacher) async {
    // Wait for the token to be retrieved before proceeding
    await getFCMToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, dynamic> jsonData = {
      "email": teacher.email,
      "password": teacher.password,
      "Device_ID": fcmToken
    };

    print('login data $jsonData');
    try {
      var response = await HttpRequest.httpPostLogin(
        bodyData: jsonData,
        endPoint: HttpUrls.login,
      );

      if (response != null) {
        var userTypeId = response.data['0']['User_Type_Id'].toString();

        // Save token, teacher ID, and User_Type_Id in SharedPreferences
        preferences.setString('breffini_token', response.data['token']);
        preferences.setString(
            'breffini_teacher_Id', response.data['0']['Id'].toString());
        preferences.setString('user_type_id', userTypeId);

        isLoggedIn.value = true;

        // Redirect based on User_Type_Id
        if (userTypeId == '2') {
          Get.offAll(() => const HomePage());
          print("Successful, redirected to HomePage");
        } else if (userTypeId == '3') {
          Get.offAll(() => const HomePage()); // Assuming DemoPage is defined
          print("Successful, redirected to DemoPage");
        } else {
          Get.showSnackbar(const GetSnackBar(
            message: 'Invalid login credentials',
            duration: Duration(milliseconds: 800),
          ));
          print("Not Successful");
        }

        // Clear controllers after successful login
        emailIDController.clear();
        passwordController.clear();
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: 'Invalid login credentials',
          duration: Duration(milliseconds: 800),
        ));
        print("Not Successful");
      }
    } catch (e) {
      print('Failed to login: $e');
      Get.showSnackbar(const GetSnackBar(
        message: 'An error occurred during login',
        duration: Duration(milliseconds: 800),
      ));
    }

    update();
  }

  verifyEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, dynamic> jsonData = {
      "Email": email,
    };
    await HttpRequest.httpPostBodyRequest(
      bodyData: jsonData,
      endPoint: HttpUrls.generateForgetPassword,
    ).then((response) {
      if (response != null) {
        preferences.setString('teacherid', response.data['User_ID'].toString());
        preferences.setString('generateToken', response.data['token']);
        preferences.setString('newOtp', response.data['otp']);
        Get.to(() => VerifyOtpPage(email));

        newPasswordController.clear();
        confirmPasswordController.clear();
        if (kDebugMode) {
          Get.showSnackbar(GetSnackBar(
            message: response.data['otp'],
            duration: const Duration(milliseconds: 2000),
          ));
        }
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: 'Invalid login credentials',
          duration: Duration(milliseconds: 800),
        ));
        print(response);
        print("Not Successful");
      }
    });

    update();
  }

  verifyOtp({required String otp}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? teacherId = preferences.getString('teacherid').toString();
    String? newOtp = preferences.getString('newOtp').toString();
    String? tokens = preferences.getString('generateToken');
    print(newOtp);
    print(tokens);
    await HttpRequest.httpPostBodyRequest(
      endPoint: HttpUrls.checkOtp,
      bodyData: {"student_id": teacherId, "otp": otp, "isStudnet": 0},
    ).then((value) async {
      print('login value $value');

      if (value != null) {
        if (value.data['0']['otp_match'].toString() == '1') {
          // preferences.setString('breffini_token', value.data['token']);
          otpController.clear();
          Get.to(() => const ChangePasswordPage());
        } else {
          Get.showSnackbar(const GetSnackBar(
            message: 'invalid otp',
            duration: Duration(milliseconds: 800),
          ));
        }
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: 'invalid request',
          duration: Duration(milliseconds: 800),
        ));
      }
    });
  }

  generateNewPassword({required String password}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? teacherId = preferences.getString('teacherid').toString();
    String? tokens = preferences.getString('generateToken');

    print(tokens);
    await HttpRequest.httpPostBodyRequest(
        endPoint: HttpUrls.newPassword,
        bodyData: {
          "token": tokens,
          "password": password,
          "user_id": teacherId
        }).then((value) async {
      print('login value $value');

      if (value?.statusCode == 200) {
        await Get.offAll(() => const LoginPage());
        newPasswordController.clear();
        confirmPasswordController.clear();
        emailIDController.clear();
        passwordController.clear();
        Get.showSnackbar(const GetSnackBar(
          message: 'Password changed successfully',
          duration: Duration(milliseconds: 1000),
        ));
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: 'invalid otp',
          duration: Duration(milliseconds: 700),
        ));
      }
    });
  }

  void logout() async {
    FirebaseFirestore.instance.clearPersistence();
    FirebaseFirestore.instance.terminate();
    CallandChatController callOngoingController = Get.find();
    String callId = callOngoingController.currentCallModel.value.callId ?? "";

    if (!callOngoingController.currentCallModel.value.callId.isNullOrEmpty()) {
      if (callOngoingController.currentCallModel.value.type == "new_live") {
        LiveClassController liveController = Get.find();

        await liveController.stopBatchLive(
            callOngoingController.currentCallModel.value.callId!,
            batchId: callOngoingController.currentCallModel.value.batchId!,
            courseId: callOngoingController.currentCallModel.value.courseId!);
      } else {
        await callOngoingController.disconnectCall(
            true,
            false,
            callOngoingController.currentCallModel.value.callerId!,
            callOngoingController.currentCallModel.value.callId!);
      }

      await FlutterCallkitIncoming.endCall(callId);
    }

    FirebaseMessaging.instance
        .unsubscribeFromTopic("TCR-" + PrefUtils().getTeacherId());

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('breffini_token');
    await preferences.remove('breffini_teacher_Id');
    isLoggedIn.value = false;
    // await Get.delete(force: true);

    Get.offAll(() => const LoginPage());
    // Get.deleteAll(force: false); //riyas brain
  }
}
