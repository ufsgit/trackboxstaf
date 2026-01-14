import 'package:breffini_staff/controller/login_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/core/utils/image_constants.dart';
import 'package:breffini_staff/model/teacher_login_model.dart';
import 'package:breffini_staff/view/pages/authentication/verify_email_page.dart';
import 'package:breffini_staff/view/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    loginController.emailIDController.addListener(_updateButtonState);
    loginController.passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    loginController.emailIDController.removeListener(_updateButtonState);
    loginController.passwordController.removeListener(_updateButtonState);
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/HE NEW LOGO WHITE-02.png"),
                          Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorResources.colorwhite),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          // Text(
                          //   "Enter your email address and password to log in to a Trackbox account",
                          //   style: GoogleFonts.plusJakartaSans(
                          //     color: ColorResources.colorgrey200,
                          //     fontSize: 14.sp,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          SizedBox(
                            height: 24.h,
                          ),
                          textFieldWidget(
                            height: 54.h,
                            controller: loginController.emailIDController,
                            labelText: 'Email',
                            // suffixIcon: const Icon(Icons.mail_outline),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          textFieldWidget(
                            height: 54.h,
                            controller: loginController.passwordController,
                            labelText: 'Password',
                            obscureText: _obscureText,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: _toggleVisibility,
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const VerifyEmailPage());
                            },
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.plusJakartaSans(
                                color: ColorResources.colorwhite,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 16),
                            child: buttonWidget(
                              fontSize: 16,
                              width: Get.width,
                              height: 45,
                              backgroundColor: loginController
                                          .emailIDController.text.isEmpty ||
                                      loginController
                                          .passwordController.text.isEmpty
                                  ? ColorResources.colorgrey400
                                  : ColorResources.colorBlue400,
                              txtColor: loginController
                                          .emailIDController.text.isEmpty ||
                                      loginController
                                          .passwordController.text.isEmpty
                                  ? ColorResources.colorgrey200
                                  : ColorResources.colorwhite,
                              context: context,
                              text: 'Continue',
                              onPressed: loginController
                                          .emailIDController.text.isNotEmpty &&
                                      loginController
                                          .passwordController.text.isNotEmpty
                                  ? () {
                                      print('login credentials');
                                      print(loginController
                                          .emailIDController.text);
                                      print(loginController
                                          .passwordController.text);
                                      if (loginController.emailIDController.text
                                              .contains("@") &&
                                          loginController.emailIDController.text
                                              .contains(".")) {
                                        loginController.teacherLogin(
                                            TeacherLoginModel(
                                                email: loginController
                                                    .emailIDController.text,
                                                password: loginController
                                                    .passwordController.text));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Invalid Email Entered"),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    }
                                  // : null,
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        //   child: buttonWidget(
        //     backgroundColor: loginController.emailIDController.text.isEmpty ||
        //             loginController.passwordController.text.isEmpty
        //         ? ColorResources.colorgrey600
        //         : ColorResources.colorBlue600,
        //     txtColor: Colors.white,
        //     context: context,
        //     text: 'Continue',
        //     onPressed: loginController.emailIDController.text.isNotEmpty &&
        //             loginController.passwordController.text.isNotEmpty
        //         ? () {
        //             print('login credentials');
        //             print(loginController.emailIDController.text);
        //             print(loginController.passwordController.text);
        //             loginController.teacherLogin(TeacherLoginModel(
        //                 email: loginController.emailIDController.text,
        //                 password: loginController.passwordController.text));
        //           }
        //         : null,
        //   ),
        // ),
      ),
    );
  }
}
