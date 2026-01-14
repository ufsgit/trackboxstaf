import 'package:breffini_staff/http/chat_socket.dart';
import 'package:breffini_staff/http/http_requests.dart';
import 'package:breffini_staff/http/http_urls.dart';
import 'package:breffini_staff/model/get_completed_model.dart';
import 'package:breffini_staff/model/ongoing_call_model.dart';
import 'package:get/get.dart';

class CallOngoingController extends GetxController {
  // var onGoingCallsList = <OnGoingCallsModel>[].obs;
  var allCompletedCalls = <CompletedLiveModel>[].obs; // Stores all data
  var displayedCalls = <CompletedLiveModel>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  final int itemsPerPage = 10;
  Future<void> getCompletedClass({bool isLoadMore = false}) async {
    try {
      print('getCompletedClass called with isLoadMore: $isLoadMore');

      if (!isLoadMore) {
        isLoading.value = true;
        allCompletedCalls.clear();
        displayedCalls.clear();
        currentPage = 1;
        hasMoreData.value = true;
        print('Initial load - cleared existing data');
      } else {
        if (!hasMoreData.value) {
          print('No more data to load');
          return;
        }
        isLoadingMore.value = true;
        print('Loading more data - page: $currentPage');
      }

      if (!isLoadMore) {
        final response = await HttpRequest.httpGetRequest(
            endPoint: HttpUrls.getCompleted, showLoader: false);

        if (response!.statusCode == 200) {
          final responseData = response.data as List<dynamic>;
          allCompletedCalls.value = responseData
              .map((result) => CompletedLiveModel.fromJson(result))
              .toList();
          print('Loaded ${allCompletedCalls.length} total items from API');
        }
      }

      final startIndex = (currentPage - 1) * itemsPerPage;
      final endIndex = startIndex + itemsPerPage;

      print(
          'Calculating pagination - startIndex: $startIndex, endIndex: $endIndex');

      if (startIndex >= allCompletedCalls.length) {
        hasMoreData.value = false;
        print('No more data available - reached end of list');
        return;
      }

      final nextBatch = allCompletedCalls.sublist(
        startIndex,
        endIndex > allCompletedCalls.length
            ? allCompletedCalls.length
            : endIndex,
      );

      print('Adding ${nextBatch.length} items to displayed list');
      displayedCalls.addAll(nextBatch);
      currentPage++;

      if (endIndex >= allCompletedCalls.length) {
        hasMoreData.value = false;
        print('Reached end of data');
      }
    } catch (error) {
      print('Error loading completed calls: $error');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      print('Loading completed. Displayed items: ${displayedCalls.length}');
    }
  }

  void resetPagination() {
    displayedCalls.clear();
    currentPage = 1;
    hasMoreData.value = true;
    getCompletedClass();
  }
  // getCompletedClass() async {
  //   // final prefs = await SharedPreferences.getInstance();
  //   // final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
  //   await HttpRequest.httpGetRequest(
  //     endPoint: HttpUrls.getCompleted,
  //   ).then((response) {
  //     if (response.statusCode == 200) {
  //       final responseData = response.data as List<dynamic>;
  //       final completedLiveClass = responseData;

  //       completedCallList.value = completedLiveClass
  //           .map((result) => CompletedLiveModel.fromJson(result))
  //           .toList();
  //       print(completedLiveClass);
  //       print('Teacher calls details loaded successfully');
  //     } else {
  //       throw Exception(
  //           'Failed to load teacher calls data: ${response.statusCode}');
  //     }
  //   });

  //   update();
  // }
  Future<List<OnGoingCallsModel>> getOngoingCallsApi() async {
    List<OnGoingCallsModel> callList = [];
    try {
      final response = await HttpRequest.httpGetRequest(
          endPoint: HttpUrls.getOngoingCalls, showLoader: false);

      if (response?.statusCode == 200) {
        final responseData = response?.data as List<dynamic>;
        callList = responseData
            .map((result) => OnGoingCallsModel.fromJson(result))
            .toList();
      } else {
        // throw Exception(
        //     'Failed to load ongoing calls data: ${response?.statusCode}');
      }
    } finally {}
    return callList;
  }

  Future<void> getOngoingCalls() async {
    try {
      isLoading.value = true;

      // Emit the socket event to request ongoing calls
      ChatSocket.emitOngoingCalls();

      // Listen for incoming ongoing call data
      ChatSocket.listenOngoingCalls();

      print('Listening for ongoing calls...');
    } catch (error) {
      print('Error fetching ongoing calls: $error');
    } finally {}
  }

  // getOngoingCalls() async {
  //   // // final prefs = await SharedPreferences.getInstance();
  //   // // final String teacherId = prefs.getString('breffini_teacher_Id') ?? "0";
  //   //
  //   // await HttpRequest.httpGetRequest(
  //   //   endPoint: HttpUrls.getOngoingCalls,
  //   // ).then((response) {
  //   //   print('<<<<<<<<<<<<<<<hgigiui${response.data}>>>>>>>>>>>>>>>');
  //   //   if (response.statusCode == 200) {
  //   //     final responseData = response.data as List<dynamic>;
  //   //     final onGoingCallsDetails = responseData;
  //   //     // print('<<<<<<<<<<<<<<<hgigiui${responseData}>>>>>>>>>>>>>>>');
  //   //     onGoingCallsList.value = onGoingCallsDetails
  //   //         .map((result) => OnGoingCallsModel.fromJson(result))
  //   //         .toList();
  //   //     print(onGoingCallsList);
  //   //     print('Teacher calls details loaded successfully');
  //   //   } else {
  //   //     throw Exception(
  //   //         'Failed to load teacher calls data: ${response.statusCode}');
  //   //   }
  //   // });
  //   //
  //   // update();
  //   try {
  //     isLoading.value = true;
  //
  //     // Emit the socket event to request ongoing calls
  //     // ChatSocket.emitOngoingCalls();
  //
  //     // Listen for incoming ongoing call data
  //     ChatSocket.listenOngoingCalls();
  //
  //     print('Listening for ongoing calls...');
  //   } catch (error) {
  //     print('Error fetching ongoing calls: $error');
  //   } finally {}
  // }
}
