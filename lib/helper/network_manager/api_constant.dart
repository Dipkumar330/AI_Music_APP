import 'dart:convert';
import 'dart:io';

import 'package:ai_music/model/user_model.dart';
import 'package:tuple/tuple.dart';

import '../../utils/app_logger.dart';

enum ApiType { signUp, sendOTP, login, getUser, updateUser, musicGenerate, verifyOtp, musics, artist }

class ApiConstant {
  static const int statusCodeSuccess = 200;
  static const int statusCodeCreated = 201;
  static const int statusCodeNotFound = 404;
  static const int statusCodeServiceNotAvailable = 503;
  static const int statusCodeBadGateway = 502;
  static const int statusCodeServerError = 500;
  static const int statusCodeUnauthorized = 401;

  static const int timeoutDurationNormalAPIs = 60000;

  /// 30 seconds
  static const int timeoutDurationMultipartAPIs = 120000;

  /// 120 seconds

  ///default Location
  static String mapStyle = "assets/map_style.txt";
  static String privacyPolicy = "assets/privacypolicy.txt";
  static String termsCondition = "assets/termscondition.txt";
  static double staticLatitude = 33.78151350894746;
  static double staticLongitude = -84.41362900386731;

  static String get baseDomain => 'https://2644-202-172-96-254.ngrok-free.app'; // Client Live

  static String getValue(ApiType type) {
    switch (type) {
      case ApiType.signUp:
        return '/users/signUp';
      case ApiType.login:
        return '/users/login';
      case ApiType.verifyOtp:
        return '/users/verifyOtp';
      case ApiType.getUser:
        return '/users/get';
      case ApiType.updateUser:
        return '/users/update';
      case ApiType.musicGenerate:
        return '/openai/openAi';
      case ApiType.musics:
        return '/homePage/get';
      case ApiType.artist:
        return '/homePage/artistList';
      case ApiType.sendOTP:
        return '/users/sendOtp';

      default:
        return "";
    }
  }

  /*
  * Tuple Sequence
  * - Url
  * - Header
  * - params
  * - files
  * */
  static Tuple4<String, Map<String, String>, Map<String, dynamic>, List<AppMultiPartFile>> requestParamsForSync(ApiType type, {Map<String, dynamic>? params, List<AppMultiPartFile> arrFile = const [], String? urlParams}) {
    String apiUrl = ApiConstant.baseDomain + ApiConstant.getValue(type);

    if (urlParams != null) apiUrl = apiUrl + urlParams;

    Map<String, dynamic> paramsFinal = params ?? <String, dynamic>{};

    Map<String, String> headers = <String, String>{};
    if (userModelSingleton.accessToken?.isNotEmpty == true) {
      headers['Authorization'] = "Bearer ${userModelSingleton.accessToken}";
    }

    Logger().d("Request Url :: $apiUrl");
    Logger().d("Request Params :: ${jsonEncode(paramsFinal)}");
    Logger().d("Request headers :: $headers");

    return Tuple4(apiUrl, headers, paramsFinal, arrFile);
  }
}

class AppMultiPartFile {
  List<File>? localFiles;
  String? key;

  AppMultiPartFile({this.localFiles, this.key});

  AppMultiPartFile.fromType({this.localFiles, this.key});
}
