import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({
    super.key,
    required this.imageUrl,
  });
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.colorBlack,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text(
            'Image',
            style: GoogleFonts.plusJakartaSans(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
            color: ColorResources.colorwhite,
            height: size.height,
            width: size.width,
            child: Center(
                child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
            ))));
  }
}
