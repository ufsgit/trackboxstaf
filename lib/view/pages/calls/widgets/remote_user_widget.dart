import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controller/live_controller.dart';
import '../../../../core/theme/color_resources.dart';

class RemoteBatchUsersWidget extends StatelessWidget {
  const RemoteBatchUsersWidget({
    super.key,
    required this.size,
    required this.videoCallCtrl,
    required this.remoteView,
  });

  final Size size;
  final LiveClassController videoCallCtrl;
  final Widget? remoteView;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 80,
        left: 10,
        right: 10,
        child: Obx(
          () => SizedBox(
            width: size.width,
            height: size.height * 0.23,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoCallCtrl.userInfoList.length,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 02),
                    child: Stack(
                      children: [
                        videoCallCtrl.userInfoList[index]["videoStatus"] == true
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width / 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: remoteView ?? const SizedBox(),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding: const EdgeInsets.all(06),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    videoCallCtrl.userInfoList[index]
                                                ["audioStatus"] ==
                                            false
                                        ? const Row(
                                            children: [
                                              Icon(
                                                Icons.mic_off,
                                                color: Colors.white,
                                              )
                                            ],
                                          )
                                        : const SizedBox(),
                                    Text(
                                      "A",
                                      style: GoogleFonts.plusJakartaSans(
                                          color: ColorResources.colorwhite,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Amal",
                                          style: GoogleFonts.plusJakartaSans(
                                              color: ColorResources.colorwhite,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        Positioned(
                            top: 08,
                            left: 08,
                            child: SvgPicture.asset(videoCallCtrl
                                        .userInfoList[index]["audioStatus"] ==
                                    false
                                ? "assets/images/MicrophoneSlash.svg"
                                : 'assets/images/Microphone.svg')),
                        Positioned(
                          bottom: 08,
                          left: 08,
                          child: Text(
                            videoCallCtrl.userInfoList[index]['userName'],
                            style: GoogleFonts.plusJakartaSans(
                                color: ColorResources.colorwhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ));
  }
}
