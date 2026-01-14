// import 'dart:developer';

// import 'package:breffini_staff/core/utils/key_center.dart';
// import 'package:breffini_staff/core/utils/zego_token_utils.dart';
// import 'package:dio/dio.dart';
// import 'package:zego_effects_plugin/zego_effects_plugin.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Future<Map<String, dynamic>> getZegoEffectsLicense() async {
//   final dio = Dio();

//   try {
//     String encryptInfo =
//         await ZegoEffectsPlugin.instance.getAuthInfo(ZegoUtils.appSign);
//     String licenceUrl = "https://aieffects-api.zego.im";
//     Map<String, dynamic> queryParams = {
//       'Action': 'DescribeEffectsLicense',
//       'AppId': ZegoUtils.appID.toString(),
//       'AuthInfo': encryptInfo,
//     };
//     final response = await dio.get(
//       licenceUrl,
//       queryParameters: queryParams,
//       options: Options(
//         responseType: ResponseType.json,
//         validateStatus: (status) => status! < 500,
//       ),
//     );
//     if (response.statusCode == 200) {
//       log(response.data.toString()); // Convert to String for logging
//       return response.data;
//     } else {
//       throw DioException(
//         requestOptions: response.requestOptions,
//         response: response,
//         message:
//             'Failed to load Zego Effects License. Status code: ${response.statusCode}',
//       );
//     }
//   } catch (e) {
//     if (e is DioException) {
//       throw Exception('Dio error fetching Zego Effects License: ${e.message}');
//     } else {
//       throw Exception('Error fetching Zego Effects License: $e');
//     }
//   }
// }
