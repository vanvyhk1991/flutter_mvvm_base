import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:training/core/network/error_interceptor.dart';

class DioFactory {
  static Dio createDio(String baseUrl, {required GoRouter router}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(ErrorInterceptor(router: router));
    return dio;
  }
}
