import 'package:dio/dio.dart';

import 'api_constant.dart';
import 'app_interceptors.dart';

Dio initDio() {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseDomain,
      connectTimeout: const Duration(milliseconds: ApiConstant.timeoutDurationNormalAPIs),
      receiveTimeout: const Duration(milliseconds: ApiConstant.timeoutDurationNormalAPIs),
    ),
  );

  dio.interceptors.add(AppInterceptors());

  return dio;
}
