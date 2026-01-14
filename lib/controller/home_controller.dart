import 'package:breffini_staff/controller/profile_controller.dart';
import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxInt selectedAudioCheckBoxIndex = 0.obs;
  RxBool selectedPdfCheckBoxIndex = false.obs;
  RxString title = ''.obs;
  RxString selectedCourseCategory = ''.obs;
  String videoURL = '';
  RxBool selectedPDF = false.obs;
  RxBool selectedAudio = false.obs;
  late ProfileController profileController;

  RxList<RxList<bool>> checkboxStates = <RxList<bool>>[].obs;
  setTitle(String selectedTitle) {
    title.value = selectedTitle;
  }

  @override
  void onInit() {
    super.onInit();
    profileController = Get.find<ProfileController>();
  }

  getSelectedCourseCategory(String selectedCategory) {
    selectedCourseCategory.value = selectedCategory;
  }

  unlockExam({
    required String contentId,
    required String examId,
    required String batchId,
    required bool isPDFUnlocked,
    required bool isAudioUnlocked,
    required bool isAnswerUnlocked,
  }) async {
    await HttpRequest.httpPostBodyRequest(
      endPoint: HttpUrls.unlockExam,
      bodyData: {
        "contentId": contentId,
        "examID": examId,
        "Is_Question_Unlocked": isPDFUnlocked ? 1 : 0,
        "Is_Question_Media_Unlocked": isAudioUnlocked ? 1 : 0,
        "Batch_ID": batchId,
        "Is_Answer_Unlocked": isAnswerUnlocked ? 1 : 0
      },
    );
  }
}
