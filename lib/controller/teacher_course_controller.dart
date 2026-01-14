import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/teacher_course_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherCourseController extends GetxController {
  var teacherCourse = <TeacherCourseModel>[].obs;
  var selectedCourse = ''.obs;

  void getTeacherCourse() async {
    final prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
    await HttpRequest.httpGetRequest(
      endPoint: '${HttpUrls.getCoursesTeacher}/$teacherId',
    ).then((response) {
      if (response!.statusCode == 200) {
        teacherCourse.clear();
        final responseData = response.data as List<dynamic>;
        final getTeacherCourseList = responseData;

        teacherCourse.value = getTeacherCourseList
            .map((result) => TeacherCourseModel.fromJson(result))
            .toList();
        print(teacherCourse);
        print('Teacher course details loaded successfully');
      } else {
        throw Exception(
            'Failed to load teacher course data: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    update();
  }

  // Set<String> getCourseNames() {
  //   update();
  //   return teacherCourse.map((course) => course.courseName).toSet();
  // }

  // Set<String> getBatchNames() {
  //   return teacherCourse.map((course) => course.batchName).toSet();
  // }
}
