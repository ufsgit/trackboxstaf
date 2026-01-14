import 'dart:io';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:aws_s3_upload_lite/enum/acl.dart';
import 'package:breffini_staff/core/utils/file_utils.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/http/loader.dart';
import 'package:dio/dio.dart';

class AwsUpload {
  static Future<String?> uploadToAws(File result) async {
    Loader.showLoaderChat();
    try {
      String filePath = result.path;
      FormData formData = FormData.fromMap({
        "myFile": await MultipartFile.fromFile(filePath,
            filename: result.path.split('/').last),
      });
      String uploadFilePath = 'Briffni/User/';
      String uploadFileName = '${DateTime.now().millisecondsSinceEpoch}.png';

      final uploadKey = uploadFilePath + uploadFileName;

      final data = await AwsS3.uploadFile(
        acl: ACL.public_read,
        accessKey: dotenv.env['AWS_ACCESS_KEY_ID']!,
        secretKey: dotenv.env['AWS_SECRET_ACCESS_KEY']!,
        file: result,
        bucket: "ufsnabeelphotoalbum",
        region: "us-east-2",
        key: uploadKey,
        metadata: {"test": "test"},
        contentType: 'image/png', destDir: uploadFilePath,
        filename: uploadFileName, // optional, ensure to specify content type
      );
      print('<<<<<<<<<<<<<<aws result>>>>>>>>>>>>>>');
      print(data.toString());

      Loader.stopLoader();

      // Construct the public URL
      final publicUrl = '${HttpUrls.imgBaseUrl}$uploadKey';
      print('Public URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      Loader.stopLoader();
      print('Error uploading to AWS: $e');
      return null;
    }
  }

  static Future<String?> uploadChatImageToAws(File selectedFile,
      String studentId, String teacherId, String fileType) async {
    // Loader.showLoaderChat();
    try {
      int originalSize = await selectedFile.length();

      // Compress the image if it's a supported type
      File fileToUpload = fileType.toLowerCase() == 'png' ||
              fileType.toLowerCase() == 'jpg' ||
              fileType.toLowerCase() == 'jpeg'
          ? await FileUtils.compressImage(selectedFile)
          : selectedFile;

      // Print compressed file size (or original size if not compressed)
      int finalSize = await fileToUpload.length();

      String fileName =
          FileUtils.getFileName(selectedFile.path) + "." + fileType;
      String uploadFilePath = 'Briffni/Chat/$studentId-$teacherId/';
      final uploadKey = uploadFilePath + fileName;

      final data = await AwsS3.uploadFile(
        acl: ACL.public_read,
        accessKey: dotenv.env['AWS_ACCESS_KEY_ID']!,
        secretKey: dotenv.env['AWS_SECRET_ACCESS_KEY']!,
        file: fileToUpload,
        bucket: "ufsnabeelphotoalbum",
        region: "us-east-2",
        key: uploadKey,
        metadata: {"test": "test"},
        destDir: uploadFilePath,
        filename: fileToUpload.path.split('/').last,
        // contentType: 'image/png', // optional, ensure to specify content type
      );

      // Loader.stopLoader();

      final publicUrl = '${HttpUrls.imgBaseUrl}$uploadKey';

      return uploadKey;
    } catch (e) {
      Loader.stopLoader();
      print('Error uploading to AWS: $e');
      return null;
    }
  }

  static Future<FormData?> prepareFormData(File result) async {
    try {
      String filePath = result.path;
      FormData formData = FormData.fromMap({
        "myFile": await MultipartFile.fromFile(filePath,
            filename: result.path.split('/').last),
      });

      print('FormData prepared: ${formData.files}');
      return formData;
    } catch (e) {
      print('Error preparing FormData: $e');
      return null;
    }
  }

  static String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }
}
