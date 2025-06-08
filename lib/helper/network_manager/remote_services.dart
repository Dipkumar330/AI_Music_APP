// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:ai_music/model/user_model.dart';
import 'package:ai_music/ui/auth/login/controller/login_controller.dart';
import 'package:ai_music/ui/auth/welcome_screen.dart';
import 'package:ai_music/utils/app_common/string_const.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../../model/response_model.dart';
import '../../utils/app_logger.dart';
import '../../utils/loader_component.dart';
import '../../utils/network_util.dart';
import 'api_constant.dart';
import 'init_dio.dart';

var sharedServiceManager = RemoteServices.singleton;

class RemoteServices {
  static var dio = initDio();

  RemoteServices._internal();

  static final RemoteServices singleton = RemoteServices._internal();

  factory RemoteServices() {
    return singleton;
  }

  /// GET requests
  Future<ResponseModel<T>> createGetRequest<T>({
    required ApiType typeOfEndPoint,
    Map<String, dynamic>? params,
    String? urlParam,
    isLoading = true,
    isOrangeBG = false,
  }) async {
    if (await NetworkUtil.isNetworkConnected()) {
      isLoading == true ? showLoader() : null;
      final requestFinal = ApiConstant.requestParamsForSync(
        typeOfEndPoint,
        params: params,
        urlParams: urlParam,
      );

      try {
        Response response = await dio.get(
          requestFinal.item1,
          options: Options(headers: requestFinal.item2),
        );
        Logger().v(response);
        final Map<String, dynamic> responseJson = json.decode(jsonEncode(response.data));
        isLoading == true ? dismissLoader() : null;

        return ResponseModel<T>.fromJson(responseJson, response.statusCode!);
      } on DioException catch (e) {
        isLoading == true ? dismissLoader() : null;
        Logger().v(e.response);
        if (e.response!.statusCode! == 400 ||
            e.response!.statusCode! == 401 ||
            e.response!.statusCode! == 403 ||
            e.response!.statusCode! == 406) {
          return createErrorResponse(
            status: e.response!.statusCode!,
            message: e.response!.data['message'],
          );
        } else if (e.type == DioExceptionType.connectionTimeout) {
          return createErrorResponse(
            status: ApiConstant.timeoutDurationNormalAPIs,
            message: 'Connection time out',
          );
        } else {
          return createErrorResponse(
            status: ApiConstant.statusCodeBadGateway,
            message: "Something went wrong",
          );
        }
      }
    } else {
      return createErrorResponse(
        status: ApiConstant.statusCodeServiceNotAvailable,
        message: AppStrings.noInternetMsg,
      );
    }
  }

  /// POST requests
  Future<ResponseModel<T>> createPostRequest<T>({
    required ApiType typeOfEndPoint,
    Map<String, dynamic>? params,
    String? urlParam,
    isLoading = true,
  }) async {
    if (await NetworkUtil.isNetworkConnected()) {
      isLoading == true ? showLoader() : null;
      final requestFinal = ApiConstant.requestParamsForSync(
        typeOfEndPoint,
        params: params,
        urlParams: urlParam,
      );
      /*
      * item1 => API End-Point
      * item2 => Header
      * item3 => Request Param
      * item4 => Multipart file
      * */
      try {
        Response response = await dio.post(
          requestFinal.item1,
          data: requestFinal.item3,
          options: Options(headers: requestFinal.item2),
        );
        Logger().v("res : ${response.data['data']}");
        isLoading == true ? dismissLoader() : null;

        return ResponseModel<T>.fromJson(response.data, response.statusCode);
      } on DioException catch (e) {
        isLoading == true ? dismissLoader() : null;
        ResponseModel res = ResponseModel<T>.fromJson(e.response?.data, e.response?.statusCode);
        Logger().v(res);

        if (res.status == 400 || res.status == 401 || res.status == 403 || res.status == 406) {
          return createErrorResponse(
            status: res.status!,
            message: res.message ?? "",
            apiType: typeOfEndPoint,
          );
        } else if (e.type == DioExceptionType.connectionTimeout) {
          return createErrorResponse(
            status: ApiConstant.timeoutDurationNormalAPIs,
            message: 'Connection time out',
            apiType: typeOfEndPoint,
          );
        } else {
          return createErrorResponse(
            status: ApiConstant.statusCodeBadGateway,
            message: "Something went wrong",
            apiType: typeOfEndPoint,
          );
        }
      }
    } else {
      return createErrorResponse(
        status: ApiConstant.statusCodeServiceNotAvailable,
        message: AppStrings.noInternetMsg,
        apiType: typeOfEndPoint,
      );
    }
  }

  /// PUT requests
  Future<ResponseModel<T>> createPutRequest<T>({
    required ApiType typeOfEndPoint,
    Map<String, dynamic>? params,
    String? urlParam,
  }) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final requestFinal = ApiConstant.requestParamsForSync(
        typeOfEndPoint,
        params: params,
        urlParams: urlParam,
      );
      /*
      * item1 => API End-Point
      * item2 => Header
      * item3 => Request Param
      * item4 => Multipart file
      * */
      try {
        Response response = await dio.put(
          requestFinal.item1,
          data: requestFinal.item3,
          options: Options(headers: requestFinal.item2),
        );

        return ResponseModel<T>.fromJson(
          json.decode(response.data.toString()),
          response.statusCode,
        );
      } on DioException catch (e) {
        Logger().v(e.response);
        // isLoading == true ? await Future.delayed(const Duration(milliseconds: 500), () => dismissLoader())l;
        if (e.response!.statusCode! == 400 ||
            e.response!.statusCode! == 401 ||
            e.response!.statusCode! == 403 ||
            e.response!.statusCode! == 406) {
          return createErrorResponse(
            status: e.response!.statusCode!,
            message: e.response!.data['message'],
          );
        } else if (e.type == DioExceptionType.connectionTimeout) {
          return createErrorResponse(
            status: ApiConstant.timeoutDurationNormalAPIs,
            message: 'Connection time out',
          );
        } else {
          return createErrorResponse(
            status: ApiConstant.statusCodeBadGateway,
            message: "Something went wrong",
          );
        }
      }
    } else {
      return createErrorResponse(
        status: ApiConstant.statusCodeServiceNotAvailable,
        message: AppStrings.noInternetMsg,
      );
    }
  }

  /// DELETE requests
  Future<ResponseModel<T>> createDeleteRequest<T>({
    required ApiType typeOfEndPoint,
    Map<String, dynamic>? params,
    String? urlParam,
  }) async {
    if (await NetworkUtil.isNetworkConnected()) {
      showLoader();
      final requestFinal = ApiConstant.requestParamsForSync(
        typeOfEndPoint,
        params: params,
        urlParams: urlParam,
      );
      /*
      * item1 => API End-Point
      * item2 => Header
      * item3 => Request Param
      * item4 => Multipart file
      * */
      try {
        Response response = await dio.delete(
          requestFinal.item1,
          data: requestFinal.item3,
          options: Options(headers: requestFinal.item2),
        );
        dismissLoader();
        return ResponseModel<T>.fromJson(response.data, response.statusCode);
      } on DioException catch (e) {
        dismissLoader();
        Logger().v(e.response);
        if (e.response!.statusCode! == 400 ||
            e.response!.statusCode! == 401 ||
            e.response!.statusCode! == 403 ||
            e.response!.statusCode! == 406) {
          return createErrorResponse(
            status: e.response!.statusCode!,
            message: e.response!.data['message'],
          );
        } else if (e.type == DioExceptionType.connectionTimeout) {
          return createErrorResponse(
            status: ApiConstant.timeoutDurationNormalAPIs,
            message: 'Connection time out',
          );
        } else {
          return createErrorResponse(
            status: ApiConstant.statusCodeBadGateway,
            message: "Something went wrong",
          );
        }
      }
    } else {
      return createErrorResponse(
        status: ApiConstant.statusCodeServiceNotAvailable,
        message: AppStrings.noInternetMsg,
      );
    }
  }

  ResponseModel<T> createErrorResponse<T>({
    required int status,
    required String message,
    ApiType? apiType,
  }) {
    if ((status == 401 || status == 403)) {
      if (get_x.Get.isRegistered<LoginController>() == true) {
        userModelSingleton.accessToken = "";
        userModelSingleton.clearPreference();
        get_x.Get.offAll(WelcomeScreen());
      } else {
        userModelSingleton.clearPreference();
      }
    }
    return ResponseModel(status: status, message: message, data: null);
  }

  Future<ResponseModel<T>> uploadRequest<T>(
    ApiType apiType, {
    Map<String, dynamic>? params,
    List<AppMultiPartFile>? arrFile,
    isLoading = true,
    String? urlParam,
    bool isOrangeBG = false,
  }) async {
    if (await NetworkUtil.isNetworkConnected()) {
      isLoading == true ? showLoader() : null;
      final requestFinal = ApiConstant.requestParamsForSync(
        apiType,
        params: params,
        arrFile: arrFile ?? [],
      );

      Map<String, dynamic> other = <String, dynamic>{};
      other.addAll(requestFinal.item3);

      /* Adding File Content */
      for (AppMultiPartFile partFile in requestFinal.item4) {
        List<MultipartFile> uploadFiles = [];
        for (File file in partFile.localFiles ?? []) {
          String filename = basename(file.path);

          /// PDF Media
          if (filename.toLowerCase().contains(".pdf")) {
            MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename);
            uploadFiles.add(mFile);
          }
          /// Video Media
          else if (filename.toLowerCase().contains(".mp4") ||
              filename.toLowerCase().contains(".mov") ||
              filename.toLowerCase().contains(".mkv")) {
            MultipartFile mFile = await MultipartFile.fromFile(
              file.path,
              filename: filename,
              contentType: MediaType('video', filename.split(".").last),
            );
            uploadFiles.add(mFile);
          }
          /// Image Media
          else {
            MultipartFile mFile = await MultipartFile.fromFile(
              file.path,
              filename: filename,
              contentType: MediaType('image', filename.split(".").last),
            );
            uploadFiles.add(mFile);
          }
        }
        if (uploadFiles.isNotEmpty) {
          other[partFile.key ?? ""] = (uploadFiles.length == 1) ? uploadFiles.first : uploadFiles;
        }
      }

      FormData formData = FormData.fromMap(other);
      final option = Options(headers: requestFinal.item2);

      try {
        final response = await dio.post(
          requestFinal.item1,
          data: formData,
          options: option,
          onSendProgress: (sent, total) {
            var progress = sent / total;
            Logger().v("uploadFile $progress");
          },
        );
        isLoading == true ? dismissLoader() : null;
        return ResponseModel<T>.fromJson(
          json.decode(jsonEncode(response.data)),
          response.statusCode,
        );
      } on DioException catch (e) {
        isLoading == true ? dismissLoader() : null;
        Logger().v(e.response);
        if (e.response!.statusCode! == 400 ||
            e.response!.statusCode! == 401 ||
            e.response!.statusCode! == 403 ||
            e.response!.statusCode! == 406) {
          return createErrorResponse(
            status: e.response!.statusCode!,
            message: e.response!.data['message'],
          );
        } else if (e.type == DioExceptionType.connectionTimeout) {
          return createErrorResponse(
            status: ApiConstant.timeoutDurationNormalAPIs,
            message: 'Connection time out',
          );
        } else {
          return createErrorResponse(
            status: ApiConstant.statusCodeBadGateway,
            message: "Something went wrong",
          );
        }
      }
    } else {
      return createErrorResponse(
        status: ApiConstant.statusCodeServiceNotAvailable,
        message: AppStrings.noInternetMsg,
      );
    }
  }
}
