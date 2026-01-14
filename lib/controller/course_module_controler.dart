import 'dart:convert';

import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/course_info_model.dart';
import 'package:breffini_staff/model/course_module_model.dart';
import 'package:breffini_staff/model/mock_test_module.dart';
import 'package:breffini_staff/model/recordings_model.dart';
import 'package:breffini_staff/model/section_by_course_model.dart';
import 'package:get/get.dart';

class CourseModuleController extends GetxController {
  var courseModulesList = <CourseModulesModel>[].obs;
  var sectionByModule = <SectionByCourseModel>[].obs;
  RxBool isSectionLoading = false.obs;
  RxBool isModuleLoading = false.obs;
  RxBool isCourseLoading = false.obs;

  var courseInfo = <CourseInfoModel>[].obs;
  var recordings = <RecordingsModel>[].obs;
  var mockModules = <MockTestModuleModel>[].obs;

  var contentVideoUrl =
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
          .obs;

  var isExpanded = false.obs;
  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }

  Future<void> getCoursesModules({required String courseId}) async {
    try {
      isModuleLoading.value = true;

      final response = await HttpRequest.httpGetRequest(
        endPoint: '${HttpUrls.getCoursesModules}/$courseId',
        showLoader: false,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is List<dynamic>) {
          courseModulesList.value = responseData
              .map((result) => CourseModulesModel.fromJson(result))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          courseModulesList.value = [responseData]
              .map((result) => CourseModulesModel.fromJson(result))
              .toList();
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        throw Exception('Failed to load data: ${response?.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      isModuleLoading.value = false;
      update();
    }
  }

  Future<void> getSectionByCourse({required String courseId}) async {
    isSectionLoading.value = true;
    try {
      final response = await HttpRequest.httpGetRequest(
        showLoader: false,
        endPoint: '${HttpUrls.getSecttionsByCourse}/$courseId',
      );

      if (response?.statusCode == 200) {
        final responseData = response!.data;

        if (responseData is List<dynamic>) {
          sectionByModule.value = responseData
              .map((result) => SectionByCourseModel.fromJson(result))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          sectionByModule.value = [responseData]
              .map((result) => SectionByCourseModel.fromJson(result))
              .toList();
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        throw Exception('Failed to load data: ${response?.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      isSectionLoading.value = false;
    }

    update(); // Notify listeners
  }

  Future<void> getCourseInfo({required int courseId}) async {
    try {
      isCourseLoading.value = true;
      final response = await HttpRequest.httpGetRequest(
          endPoint: '${HttpUrls.getCourseInfo}/$courseId', showLoader: false);

      if (response!.statusCode == 200) {
        final responseData = response.data;

        print('Response data type: ${responseData.runtimeType}');
        print('Raw response data: $responseData');

        if (responseData == null) {
          throw Exception('Response data is null');
        }

        if (responseData is String) {
          if (responseData.trim().isEmpty) {
            throw Exception('Response data is an empty string');
          }
          try {
            final jsonData = json.decode(responseData);
            if (jsonData is List<dynamic>) {
              courseInfo.value = jsonData
                  .map((result) => CourseInfoModel.fromJson(result))
                  .toList();
            } else if (jsonData is Map<String, dynamic>) {
              courseInfo.value = [CourseInfoModel.fromJson(jsonData)];
            } else {
              throw Exception(
                  'Unexpected JSON structure: ${jsonData.runtimeType}');
            }
          } catch (e) {
            print('Error parsing JSON: $e');
            throw Exception('Invalid JSON format: $e');
          }
        } else if (responseData is List<dynamic>) {
          courseInfo.value = responseData
              .map((result) => CourseInfoModel.fromJson(result))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          courseInfo.value = [CourseInfoModel.fromJson(responseData)];
        } else {
          throw Exception(
              'Unexpected response data type: ${responseData.runtimeType}');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
        print('Response body: ${response.data}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching or processing data: $error');
      // Optionally, you can set courseInfo to a default value or clear it
      // courseInfo.value = [];
      rethrow;
    } finally {
      isCourseLoading.value = false;

      update();
    }
  }

  getRecordings({required String courseId}) async {
    await HttpRequest.httpGetRequest(
      endPoint: '${HttpUrls.getRecordings}/$courseId',
    ).then((response) {
      if (response!.statusCode == 200) {
        final responseData = response.data;
        if (responseData is List<dynamic>) {
          final recordingsData = responseData;
          recordings.value = recordingsData
              .map((result) => RecordingsModel.fromJson(result))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          final recordingsData = [responseData];
          recordings.value = recordingsData
              .map((result) => RecordingsModel.fromJson(result))
              .toList();
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        throw Exception('Failed to load  data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }

  void getModulesofMockTests({required String courseId}) async {
    await HttpRequest.httpGetRequest(
      endPoint: '${HttpUrls.getModulesofMockTests}/$courseId',
    ).then((response) {
      if (response!.statusCode == 200) {
        final responseData = response.data;
        if (responseData is List<dynamic>) {
          final mockModulesData = responseData;
          mockModules.value = mockModulesData
              .map((result) => MockTestModuleModel.fromJson(result))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          final mockModulesData = [responseData];
          mockModules.value = mockModulesData
              .map((result) => MockTestModuleModel.fromJson(result))
              .toList();
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        throw Exception('Failed to load  data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }
}
