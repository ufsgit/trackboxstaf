import 'package:breffini_staff/http/http_urls.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherProfileService {
  late Dio dio;

  TeacherProfileService() {
    dio = Dio(
      BaseOptions(
        baseUrl: HttpUrls.baseUrl,
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }

  /// 🔥 ADD TOKEN BEFORE EVERY REQUEST
  Future<void> setAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('breffini_token');

    if (token != null) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
  }

  /// ------------------ QUALIFICATION ------------------

  Future<void> saveQualification({
    required int teacherId,
    required String courseName,
    required String institutionName,
    required String passoutDate,
  }) async {
    final response = await dio.post(
      HttpUrls.saveTeacherQualification,
      data: {
        "Teacher_ID": teacherId,
        "Course_Name": courseName,
        "Institution_Name": institutionName,
        "Passout_Date": passoutDate,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save qualification");
    }
  }

  Future<List<dynamic>> getQualifications(int teacherId) async {
    await setAuthToken();

    final response = await dio.get(
      "${HttpUrls.getTeacherQualificationsByTeacherId}$teacherId",
    );

    return response.data ?? [];
  }

  /// ------------------ EXPERIENCE ------------------

  Future<void> saveExperience({
    required int teacherId,
    required String jobRole,
    required String organizationName,
    required double yearsOfExperience,
  }) async {
    final response = await dio.post(
      HttpUrls.saveTeacherExperience,
      data: {
        "Teacher_ID": teacherId,
        "Job_Role": jobRole,
        "Organization_Name": organizationName,
        "Years_Of_Experience": yearsOfExperience,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save experience");
    }
  }

  Future<List<dynamic>> getExperience(int teacherId) async {
    final response = await dio.get(
      "${HttpUrls.getTeacherExperienceByTeacherId}$teacherId",
    );

    if (response.statusCode == 200 && response.data is List) {
      return response.data;
    } else {
      return [];
    }
  }

  /// ------------------ DELETE QUALIFICATION ------------------
  Future<void> deleteQualification({
    required int qualificationId,
    required int teacherId,
  }) async {
    await setAuthToken(); // 🔥 VERY IMPORTANT

    final response = await dio.delete(
      "${HttpUrls.deleteTeacherQualification}$qualificationId/$teacherId",
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete qualification");
    }
  }

  /// ------------------ DELETE EXPERIENCE ------------------
  Future<void> deleteExperience({
    required int experienceId,
    required int teacherId,
  }) async {
    final response = await dio.delete(
      "/teacher/Delete_Teacher_Experience/$experienceId/$teacherId",
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete experience");
    }
  }

  Future<void> editExperience({
    required int experienceId,
    required int teacherId,
    required String jobRole,
    required String organizationName,
    required double yearsOfExperience,
  }) async {
    final response = await dio.post(
      '/teacher/Edit_Teacher_Experience',
      data: {
        "Experience_ID": experienceId,
        "Teacher_ID": teacherId,
        "Job_Role": jobRole,
        "Organization_Name": organizationName,
        "Years_Of_Experience": yearsOfExperience,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update experience");
    }
  }
  Future<void> editQualification({
  required int qualificationId,
  required int teacherId,
  required String courseName,
  required String institutionName,
  required String passoutDate,
}) async {
  final response = await dio.post(
    '/teacher/Edit_Teacher_Qualification',
    data: {
      "Qualification_ID": qualificationId,
      "Teacher_ID": teacherId,
      "Course_Name": courseName,
      "Institution_Name": institutionName,
      "Passout_Date": passoutDate,
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to edit qualification");
  }
}

}
