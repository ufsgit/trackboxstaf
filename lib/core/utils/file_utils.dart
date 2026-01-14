import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';


class FileUtils {
  static String getFileExtension(String filePath) {
    // Find the index of the last dot in the file path
    int lastDotIndex = filePath.lastIndexOf('.');
    if (lastDotIndex != -1 && lastDotIndex < filePath.length - 1) {
      // Return the substring starting from the index after the dot
      return filePath.substring(lastDotIndex + 1); // Excludes the dot
    }
    return ''; // Return empty string if there is no extension
  }

  static String getFileName(String filePath,{bool withExtension=false}) {
    // Split the file path by '/' to get the last part
    List<String> parts = filePath.split('/');
    String fullFileName = parts.last; // Get the last part (file with extension)

    if(!withExtension) {
      // Get the index of the last dot to separate the extension
      int lastDotIndex = fullFileName.lastIndexOf('.');
      if (lastDotIndex != -1) {
        return fullFileName.substring(
            0, lastDotIndex); // Return the filename without extension
      }
    }

    return fullFileName; // Return full filename if no extension found
  }

  static double? getFileSizeInKB(String filePath) {
    try {
      File file = File(filePath);

      if (file.existsSync()) {
        // Get the file statistics synchronously
        var fileStat = file.statSync();

        // File size in kilobytes
        double fileSizeInKB = fileStat.size / 1024; // Convert bytes to KB

        return fileSizeInKB; // Return size in KB
      } else {
        return 0.0;
      }
    } catch (e) {
      print("Error getting file size: $e");
      return null; // Return null if there was an error
    }
  }

  static String getFileSize(double sizeInKB) {
    if (sizeInKB < 1024) {
      return '${sizeInKB.toStringAsFixed(2)} KB'; // Return size in KB
    } else {
      double sizeInMB = sizeInKB / 1024; // Convert KB to MB
      return '${sizeInMB.toStringAsFixed(2)} MB'; // Return size in MB
    }
  }
  static Future<String> generateThumbnail(String filePath) async {

    XFile thumbnailFile= await VideoThumbnail.thumbnailFile(
      video: filePath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 100,
      quality: 70,
    );

    return thumbnailFile.path;

  }
  static Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jpg|.jpeg|.png'));
    final splitted = filePath.substring(0, lastIndex);
    final outPath = "${splitted}_compressed.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 70,
      minWidth: 1024,
      minHeight: 1024,
    );
    return File(result!.path);
  }
}

extension FileExtensions on String? {
  bool isVideoFile() {
    // Define a set of common video file extensions
    const videoExtensions = {'mp4', 'avi', 'mov', 'mkv', 'flv', 'wmv', 'mpeg'};

    // Extract the extension from the file name and convert it to lowercase
    String? extension = this?.split('.').last.toLowerCase();

    // Check if the extension is in the set of video extensions
    return videoExtensions.contains(extension);
  }

  bool isImageFile() {
    // Define a set of common image file extensions
    const imageExtensions = {
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'tiff',
      'webp'
    };

    // Extract the extension from the file name and convert it to lowercase
    String? extension = this?.split('.').last.toLowerCase();

    // Check if the extension is in the set of image extensions
    return imageExtensions.contains(extension);
  }

  bool isPdfFile() {
    // Extract the extension from the file name and convert it to lowercase
    String? extension = this?.split('.').last.toLowerCase();

    // Check if the extension is 'pdf'
    return extension == 'pdf';
  }

}
