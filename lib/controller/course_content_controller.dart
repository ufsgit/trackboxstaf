import 'dart:developer';

import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/course_content_by_library_model.dart';
import 'package:breffini_staff/model/course_content_by_module.dart';
import 'package:breffini_staff/model/course_content_model.dart';
import 'package:breffini_staff/model/explore_course_model.dart';
import 'package:breffini_staff/model/hod_course_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseContentController extends GetxController {
  var courseContent = CourseContentByModuleModel();
  var courseLibraryList = <CourseContentLibraryModelElement>[].obs;
  var hodCourseList = <HodCourseModel>[].obs;
  RxBool isLoading = false.obs;
  var exploreCoursesList = <ExploreCoursesModel>[].obs;
  // var displayedCourses = <ExploreCoursesModel>[].obs;

  getHodCourse() async {
    await HttpRequest.httpGetRequest(
      showLoader: true,
      endPoint: '${HttpUrls.getHodCourse}',
    ).then((response) {
      if (response!.statusCode == 200) {
        final responseData = response.data;
        if (responseData is List<dynamic>) {
          final hodData = responseData;
          hodCourseList.value =
              hodData.map((result) => HodCourseModel.fromJson(result)).toList();
        } else if (responseData is Map<String, dynamic>) {
          final hodData = [responseData];
          hodCourseList.value =
              hodData.map((result) => HodCourseModel.fromJson(result)).toList();
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        throw Exception('Failed to load profile data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }

  getAllExploreCourses() async {
    await HttpRequest.httpGetRequest(
            endPoint: HttpUrls.getExploreCourses, showLoader: false)
        .then((value) {
      if (value != null) {
        List data = value.data;
        print('explore course details $value');
        exploreCoursesList.value =
            data.map((e) => ExploreCoursesModel.fromJson(e)).toList();
      }
    });
  }

  Future<void> getCourseContent(
      {required String courseId,
      required String moduleId,
      required String sectionId,
      required String dayId,
      required String batchId,
      required bool isLibrary}) async {
    try {
      final response = await HttpRequest.httpGetRequest(
        showLoader: false,
        endPoint:
            '${HttpUrls.getCourseContentByDay}?Course_Id=$courseId&Module_ID=$moduleId&Section_ID=$sectionId&Day_Id=$dayId&isLibrary=$isLibrary&is_Student=false&Batch_ID=$batchId',
      );

      log('Received response: ${response?.data}');
      log('Status code: ${response?.statusCode}');

      if (response!.data != null && response!.statusCode == 200) {
        final responseData = response.data;

        // Check if 'contents' key exists and is a list
        if (responseData['contents'] != null) {
          if (responseData['contents'] is List) {
            courseContent = CourseContentByModuleModel.fromJson(responseData);
            log('Course content: $courseContent');
          } else {
            throw Exception(
                'Expected a List but received: ${responseData['contents'].runtimeType}');
          }
        } else {
          throw Exception('No contents found in response data.');
        }
      } else {
        throw Exception(
            'Failed to load course content data: ${response.statusCode}');
      }
    } catch (error) {
      log('Error fetching data: $error');
    }
  }

  void getCourseContentLibrary(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final String studentId = prefs.getString('breffini_student_id') ?? "0";
    try {
      final response = await HttpRequest.httpGetRequest(
        endPoint: '${HttpUrls.courseContentLibrary}/$studentId/$courseId',
      );

      if (response!.statusCode == 200) {
        final responseData = response!.data;

        if (responseData is List) {
          // Debug print to inspect the structure of the response
          print('Response Data: $responseData');

          // Flatten and convert each item in the list
          courseLibraryList.value = _flattenTypeChange(responseData);
        } else {
          throw Exception(
              'Expected a List<dynamic> but received: ${responseData.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load course content data: ${response!.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<GetCourseContentModelElement> _flattenAndConvert(List<dynamic> data) {
    List<GetCourseContentModelElement> result = [];

    for (var item in data) {
      if (item is Map<String, dynamic>) {
        result.add(GetCourseContentModelElement.fromJson(item));
      } else if (item is List) {
        result.addAll(
            _flattenAndConvert(item)); // Recursive flattening for nested lists
      } else {
        throw Exception('Unexpected item type in list: ${item.runtimeType}');
      }
    }

    return result;
  }

  List<CourseContentLibraryModelElement> _flattenTypeChange(
      List<dynamic> data) {
    List<CourseContentLibraryModelElement> result = [];

    for (var item in data) {
      if (item is Map<String, dynamic>) {
        result.add(CourseContentLibraryModelElement.fromJson(item));
      } else if (item is List) {
        result.addAll(
            _flattenTypeChange(item)); // Recursive flattening for nested lists
      } else {
        throw Exception('Unexpected item type in list: ${item.runtimeType}');
      }
    }

    return result;
  }
}
