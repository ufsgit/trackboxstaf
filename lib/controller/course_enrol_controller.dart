import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/batch_days_with_model.dart';
import 'package:get/get.dart';

class CourseEnrolController extends GetxController {
  var batchDaysList = <BatchWithDaysModel>[].obs;
  var selectedDay = Rx<BatchWithDaysModel?>(null);
  var selectedIndex = 0.obs;
  RxBool isLoading = false.obs;

  void selectIndex(int index) {
    selectedIndex.value = index;
  }

  void selectDay(BatchWithDaysModel day) {
    selectedDay.value = day;
  }

  bool isSelected(BatchWithDaysModel day) {
    return selectedDay.value == day;
  }

  getBatchWithDays(String courseId, String moduleId) async {
    isLoading.value = true;

    await HttpRequest.httpGetRequest(
            endPoint: '${HttpUrls.getBatchDays}/$courseId/$moduleId',
            showLoader: false)
        .then((response) {
      if (response!.statusCode == 200) {
        isLoading.value = false;

        final responseData = response.data;
        if (responseData is List<dynamic>) {
          final batchDays = responseData;
          batchDaysList.value = batchDays
              .map((result) => BatchWithDaysModel.fromJson(result))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          final batchDays = [responseData];
          batchDaysList.value = batchDays
              .map((result) => BatchWithDaysModel.fromJson(result))
              .toList();
          isLoading.value = false;
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
}
