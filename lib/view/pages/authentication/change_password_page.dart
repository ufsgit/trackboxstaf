import 'package:breffini_staff/controller/login_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/model/teacher_login_model.dart';
import 'package:breffini_staff/view/pages/authentication/login_page.dart';
import 'package:breffini_staff/view/pages/authentication/verify_otp_page.dart';
import 'package:breffini_staff/view/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
    loginController.newPasswordController.addListener(_updateButtonState);
    loginController.confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    loginController.newPasswordController.addListener(_updateButtonState);
    loginController.confirmPasswordController.addListener(_updateButtonState);

    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorResources.colorBlue800,
                ColorResources.colorBlue400
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You're verified! Create a   new password to continue.",
                  style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorResources.colorBlue100),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Set up your new password for future logins.",
                  style: GoogleFonts.plusJakartaSans(
                    color: ColorResources.colorgrey400,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                textFieldWidget(
                  height: 54.h,
                  controller: loginController.newPasswordController,
                  labelText: 'Password',
                  suffixIcon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                textFieldWidget(
                  height: 54.h,
                  controller: loginController.confirmPasswordController,
                  labelText: 'Confirm password',
                  suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  child: buttonWidget(
                    fontSize: 16,
                    width: Get.width,
                    height: 45,
                    backgroundColor:
                        loginController.newPasswordController.text.isEmpty &&
                                loginController
                                    .confirmPasswordController.text.isEmpty
                            ? ColorResources.colorgrey400
                            : ColorResources.colorBlue400,
                    txtColor:
                        loginController.newPasswordController.text.isEmpty &&
                                loginController
                                    .confirmPasswordController.text.isEmpty
                            ? ColorResources.colorwhite
                            : ColorResources.colorgrey200,
                    context: context,
                    text: 'Save Changes',
                    onPressed: loginController
                                .newPasswordController.text.isNotEmpty &&
                            loginController
                                .confirmPasswordController.text.isNotEmpty
                        ? () async {
                            if (loginController
                                    .confirmPasswordController.text ==
                                loginController.newPasswordController.text) {
                              await loginController.generateNewPassword(
                                  password: loginController
                                      .confirmPasswordController.text);
                            } else {
                              Get.showSnackbar(const GetSnackBar(
                                message: 'Password mismatch',
                                duration: Duration(milliseconds: 800),
                              ));
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
