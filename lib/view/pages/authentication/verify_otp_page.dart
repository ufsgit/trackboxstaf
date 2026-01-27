import 'package:breffini_staff/controller/login_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyOtpPage extends StatefulWidget {
  VerifyOtpPage(this.email);
  String email = "";

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final LoginController loginController = Get.put(LoginController());

  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    loginController.otpController.clear();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isFocused ? Colors.white : ColorResources.colorgrey400,
            width: isFocused ? 2 : 1),
      ),
    );
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
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Check your Inbox",
                  style: GoogleFonts.plusJakartaSans(
                    color: ColorResources.colorwhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "We've sent a code 4 digit to ${loginController.verifyEmailController.text}",
                  style: GoogleFonts.plusJakartaSans(
                    color: ColorResources.colorwhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Form(
                  key: formKey,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      controller: loginController.otpController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      // androidSmsAutofillMethod:
                      //     AndroidSmsAutofillMethod.smsUserConsentApi,
                      // listenForMultipleSmsOnAndroid: true,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (String verificationCode) {},
                      onChanged: (code) {},
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Didn't get a code?",
                      style: GoogleFonts.plusJakartaSans(
                        color: ColorResources.colorgrey300,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          loginController.otpController.clear();
                          await loginController.verifyEmail(widget.email);
                          loginController.verifyEmailController.clear();
                        },
                        child: Text(
                          'Resend',
                          style: GoogleFonts.plusJakartaSans(
                            color: ColorResources.colorwhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        )),
                  ],
                ),
                const Expanded(child: SizedBox()),
                buttonWidget(
                  backgroundColor: ColorResources.colorBlue600,
                  txtColor: ColorResources.colorwhite,
                  context: context,
                  text: 'Verify',
                  onPressed: loginController.otpController.text.isNotEmpty
                      ? () async {
                          loginController.verifyOtp(
                              otp: loginController.otpController.text);
                        }
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
