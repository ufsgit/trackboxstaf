import 'package:breffini_staff/controller/calls_page_controller.dart';
import 'package:breffini_staff/controller/individual_call_controller.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:breffini_staff/core/utils/firebase_utils.dart';
import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/http/loader.dart';
import 'package:breffini_staff/model/current_call_model.dart';
import 'package:breffini_staff/model/save_call_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/scheduler.dart' as scheduler;
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';

Future<void> handleNewCall({
  required String studentId,
  required String studentName,
  required bool isVideo,
  required String profileImageUrl,
  required String liveLink,
  required IndividualCallController controller,
  required CallandChatController callandChatController,
  required Function safeBack,
}) async {
  try {
    // Show loader at the start
    Loader.showLoader();

    String updatedLiveLink = PrefUtils().getMeetLink();

    SaveStudentCallModel callModel = SaveStudentCallModel(
      id: 0,
      teacherId: 0,
      studentId: int.parse(studentId),
      studentName: studentName,
      callStart: DateTime.now(),
      callEnd: '',
      callDuration: null,
      callType: isVideo ? 'Video' : 'Audio',
      isStudentCalled: 0,
      liveLink: updatedLiveLink,
      profileUrl: PrefUtils().getProfileUrl(),
    );

    String newCallId = await controller.saveStudentCall(callModel);

    if (!newCallId.isNullOrEmpty()) {
      bool hasRecentCall =
          await FirebaseUtils.checkForRecentCallWithSameStudent(studentId);
      await FirebaseUtils.saveCall(
        studentId,
        studentName,
        newCallId,
        callModel,
      );
      FirebaseUtils.listeningToCurrentCall(
        studentId,
        newCallId,
      );

      callandChatController.currentCallModel.value = CurrentCallModel(
        callerId: studentId,
        callId: newCallId,
        callerName: studentName,
        isVideo: isVideo,
        profileImg: profileImageUrl,
        liveLink: updatedLiveLink,
        type: "new_call",
      );
    }

    // Hide loader after all operations are complete
    Loader.stopLoader();
  } catch (e) {
    // Hide loader in case of error
    Loader.stopLoader();
    debugPrint('Error in handleNewCall: $e');
    rethrow;
  }
}

Future<void> handleExistingCall({
  required String studentId,
  required String studentName,
  required String callId,
  required bool isVideo,
  required String profileImageUrl,
  required String liveLink,
  required IndividualCallController controller,
  required CallandChatController callandChatController,
  required Function safeBack,
}) async {
  try {
    // Show loader at the start
    Loader.showLoader();

    bool callExists = await FirebaseUtils.checkIfCallExists(studentId, callId);

    if (!callExists) {
      callandChatController.currentCallModel.value = CurrentCallModel();
      callandChatController.disconnectCall(true, false, studentId, callId);
    } else {
      FirebaseUtils.listeningToCurrentCall(studentId, callId);
      FirebaseUtils.updateCallStatus(studentId, FirebaseUtils.callAccepted);
      await controller.updateCallStatusAccept(callId);

      callandChatController.currentCallModel.value = CurrentCallModel(
        callerId: studentId,
        callId: callId,
        callerName: studentName,
        isVideo: isVideo,
        profileImg: profileImageUrl,
        liveLink: liveLink,
        type: "new_call",
      );
    }

    // Hide loader after all operations are complete
    Loader.stopLoader();
  } catch (e) {
    // Hide loader in case of error
    Loader.stopLoader();
    debugPrint('Error in handleExistingCall: $e');
    rethrow;
  }
}

// Also update the main handleCall function to handle errors
Future<void> handleCall({
  required String studentId,
  required String studentName,
  required String callId,
  required bool isVideo,
  required String profileImageUrl,
  required String liveLink,
  required IndividualCallController controller,
  required CallandChatController callandChatController,
  required Function safeBack,
}) async {
  try {
    // Show loader at the start
    Loader.showLoader();

    await FlutterCallkitIncoming.endCall(callId);

    if (callId.isNullOrEmpty()) {
      await handleNewCall(
        studentId: studentId,
        studentName: studentName,
        isVideo: isVideo,
        profileImageUrl: profileImageUrl,
        liveLink: liveLink,
        controller: controller,
        callandChatController: callandChatController,
        safeBack: safeBack,
      );
    } else {
      await handleExistingCall(
        studentId: studentId,
        studentName: studentName,
        callId: callId,
        isVideo: isVideo,
        profileImageUrl: profileImageUrl,
        liveLink: liveLink,
        controller: controller,
        callandChatController: callandChatController,
        safeBack: safeBack,
      );
    }

    // Hide loader after all operations are complete
    Loader.stopLoader();
  } catch (e) {
    // Hide loader in case of error
    Loader.stopLoader();
    debugPrint('Error in handleCall: $e');
    rethrow;
  }
}
