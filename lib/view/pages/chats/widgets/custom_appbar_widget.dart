import 'package:breffini_staff/controller/login_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/view/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final TextEditingController controller;
  final bool isStudentList;
  final void Function(String)? onChanged;
  final String labelText;

  const CustomAppBar(
      {super.key,
      required this.title,
      required this.isStudentList,
      required this.controller,
      required this.onChanged,
      required this.labelText});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(130.h);
}

final LoginController loginController = Get.put(LoginController());

class _CustomAppBarState extends State<CustomAppBar> {
  void showLogoutDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
                fontSize: 18.w,
                fontWeight: FontWeight.w700,
                color: const Color(0xff283B52)),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.plusJakartaSans(),
          ),
          actions: [
            TextButton(
              child: Text(
                'No',
                style: GoogleFonts.plusJakartaSans(
                  color: ColorResources.colorgrey700,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xffEB4141),
                ),
              ),
              onPressed: () {
                Get.back();
                loginController.logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: AppBar(
        leading: widget.isStudentList
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    height: 25.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: ColorResources.colorBlue100),
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          CupertinoIcons.back,
                          color: ColorResources.colorgrey500,
                          size: 20,
                        ))),
              )
            : null,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.isStudentList ? 48.w : 16.w,
                  vertical: widget.isStudentList ? 4 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.plusJakartaSans(
                      color: ColorResources.colorgrey700,
                      fontSize: widget.isStudentList ? 20.sp : 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: textFieldWidget(
                onChanged: widget.onChanged,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: ColorResources.colorgrey400,
                  size: 24.sp,
                ),
                height: 43.h,
                controller: widget.controller,
                labelText: widget.labelText,
                // suffixIcon: Icon(
                //   CupertinoIcons.slider_horizontal_3,
                //   color: ColorResources.colorgrey400,
                //   size: 24.sp,
                // ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
