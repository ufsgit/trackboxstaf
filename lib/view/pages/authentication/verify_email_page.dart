import 'package:breffini_staff/controller/login_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
    loginController.verifyEmailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    loginController.verifyEmailController.removeListener(_updateButtonState);

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
                  "Verify Your Email",
                  style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorResources.colorBlue100),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Please enter yor email address to reset your password",
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
                  controller: loginController.verifyEmailController,
                  labelText: 'Email',
                  suffixIcon: const Icon(Icons.mail_outline),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  child: buttonWidget(
                    width: Get.width,
                    fontSize: 16,
                    height: 45,
                    backgroundColor:
                        loginController.verifyEmailController.text.isEmpty
                            ? ColorResources.colorgrey400
                            : ColorResources.colorBlue400,
                    txtColor:
                        loginController.verifyEmailController.text.isNotEmpty
                            ? ColorResources.colorwhite
                            : ColorResources.colorgrey200,
                    context: context,
                    text: 'Send Verification Code',
                    onPressed:
                        loginController.verifyEmailController.text.isNotEmpty
                            ? () async {
                                await loginController.verifyEmail(
                                    loginController.verifyEmailController.text);
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
