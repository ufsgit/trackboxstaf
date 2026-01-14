import 'package:breffini_staff/controller/course_enrol_controller.dart';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/model/batch_days_with_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class GridViewDayWidget extends StatefulWidget {
  final List<BatchWithDaysModel> batchDays;
  final void Function(BatchWithDaysModel) onDayTapped;

  const GridViewDayWidget({
    super.key,
    required this.batchDays,
    required this.onDayTapped,
  });

  @override
  State<StatefulWidget> createState() => _GridViewDayWidgetState();
}

class _GridViewDayWidgetState extends State<GridViewDayWidget> {
  int newindex = -1;

  @override
  Widget build(BuildContext context) {
    final CourseEnrolController controller = Get.find();

    return Obx(
      () {
        return GridView.builder(
          itemCount: widget.batchDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, index) {
            final day = widget.batchDays[index];

            bool isSelected = controller.isSelected(day);
            final String dayTitle =
                day.is_exam_day == 1 ? 'Day ${index + 1}' : 'Day ${index + 1}';
            return GestureDetector(
              onTap: () {
                setState(() {
                  newindex = index;
                });

                controller.selectDay(day);
                widget.onDayTapped(day);
              },
              child: Container(
                height: 85,
                width: 75,
                decoration: BoxDecoration(
                  // color: ColorResources.colorwhite,
                  border: Border.all(
                    color: newindex == index
                        ? Colors.blue
                        : Colors.transparent, // Set your desired color here
                    width: 1.5, // Set the width of the border
                  ),

                  // border: day.isToday == 1
                  //     ? Border.all(
                  //         color: Colors.blue, // Set your desired color here
                  //         width: 1.0, // Set the width of the border
                  //       )
                  //     : null,
                  gradient: day.isDayUnlocked == 0
                      ? LinearGradient(
                          tileMode: TileMode.repeated,
                          colors: [
                            ColorResources.colorwhite
                                .withOpacity(0.8), // More dominant
                            const Color(0xFF6A7487)
                                .withOpacity(0.5), // Less dominant
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : const LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white
                          ], // Change colors as needed
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(8.0),
                  // border: Border.all(
                  //   color: isSelected ? Colors.blue : Colors.transparent,
                  //   width: 2.0,
                  // ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 22,
                          width: day.is_exam_day == 1 ? 75 : 55,
                          decoration: BoxDecoration(
                            color: day.is_exam_day == 1
                                ? const Color(0xFFE8EFE6)
                                : ColorResources.colorBlue100,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: day.is_exam_day == 1
                                ? Text(
                                    'Test',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF509144),
                                      fontSize: day.is_exam_day == 1 ? 10 : 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : Text(
                                    'Class',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: ColorResources.colorBlue500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Builder(
                            builder: (context) {
                              String dayName = day.dayName;
                              List<String> parts = dayName.split(' ');
                              if (parts.length < 2) {
                                return const Text("Invalid format");
                              }

                              String dayText = parts[0];
                              String numericPart = parts[1];
                              String formattedNumericPart =
                                  numericPart.padLeft(2, '0');

                              return RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$dayText\n',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: ColorResources.colorgrey500,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: formattedNumericPart,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: day.isDayUnlocked == 0
                                            ? ColorResources.colorgrey600
                                            : ColorResources.colorgrey700,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // if (day.isDayUnlocked == 0)
                    //   const Icon(
                    //     Icons.lock,
                    //     color: Colors.white,
                    //     size: 30,
                    //   )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
