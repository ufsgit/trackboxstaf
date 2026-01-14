import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/My_Course_Details_Model.dart';
import 'package:breffini_staff/model/student_call_model.dart';
import 'package:breffini_staff/model/student_media_model.dart';
import 'package:breffini_staff/model/teacher_course_model.dart';
import 'package:breffini_staff/model/teacher_course_model_details.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentCourseController extends GetxController {
  var studentCourseList = <MyCourseDetailsModel>[].obs;
  var studentMediaList = <StudentMediaModel>[].obs;
  var studentCallsList = <StudentCallModel>[].obs;
  var teacherCourseList = <TeacherCourseModelDetails>[].obs;
  RxBool isStudentCourseLoading = false.obs;

  getCoursesOfTeacher() async {
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    final String endpoint = '${HttpUrls.getCoursesDetailsTeacher}$teacherId';

    try {
      final response = await HttpRequest.httpGetRequest(
          endPoint: endpoint, showLoader: false);

      if (response!.statusCode == 200) {
        teacherCourseList.clear();
        final responseData = response.data as List<dynamic>;
        final teacherCourseListData = responseData;

        teacherCourseList.value = teacherCourseListData
            .map((result) => TeacherCourseModelDetails.fromJson(result))
            .toList();

        print(teacherCourseList);
        print('Loaded successfully');
      } else {
        throw Exception('Failed to load course data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }

    update();
  }

  Future<void> getCourseOfStudent(dynamic studentId) async {
    // Convert studentId to a String, if necessary
    final String studentIdString = studentId.toString();

    if (studentIdString.isEmpty) {
      print('Student ID cannot be empty');
      return;
    }

    isStudentCourseLoading.value = true;

    final String endpoint = '${HttpUrls.getCourseOfStudent}/$studentIdString';

    try {
      // Make the HTTP request
      final response = await HttpRequest.httpGetRequest(
        endPoint: endpoint,
        showLoader: false,
      );

      // Check for null response
      if (response == null) {
        throw Exception('Response is null');
      }

      // Handle response
      if (response.statusCode == 200) {
        studentCourseList.clear();

        final responseData = response.data;
        if (responseData is List<dynamic>) {
          studentCourseList.value = responseData
              .map((result) => MyCourseDetailsModel.fromJson(result))
              .toList();

          print('Student course list loaded successfully: $studentCourseList');
        } else {
          throw Exception(
              'Unexpected response data type: ${responseData.runtimeType}');
        }
      } else {
        throw Exception('Failed to load course data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors
      print('Error fetching student courses: $error');
    } finally {
      isStudentCourseLoading.value = false;
      update();
    }
  }

  void getMediaofStudent(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    await HttpRequest.httpGetRequest(
      showLoader: false,
      endPoint: '${HttpUrls.getMediaofStudent}/$studentId/$teacherId',
    ).then((response) {
      if (response!.statusCode == 200) {
        studentMediaList.clear();
        final responseData = response.data as List<dynamic>;
        final getStudentMedia = responseData;

        studentMediaList.value = getStudentMedia
            .map((result) => StudentMediaModel.fromJson(result))
            .toList();
        print(studentCourseList);
        print('loaded successfully');
      } else {
        throw Exception('Failed to load  course data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }

  void getCallOfStudent(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    await HttpRequest.httpGetRequest(
      showLoader: false,
      endPoint: '${HttpUrls.getCallLogOfStudent}/$studentId/$teacherId',
    ).then((response) {
      if (response!.statusCode == 200) {
        studentCallsList.clear();
        final responseData = response.data as List<dynamic>;
        final getCallList = responseData;

        studentCallsList.value = getCallList
            .map((result) => StudentCallModel.fromJson(result))
            .toList();
        print(studentCourseList);
        print('loaded successfully');
      } else {
        throw Exception('Failed to load  course data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }
}
