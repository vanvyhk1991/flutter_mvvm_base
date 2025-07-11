import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import 'app_exception.dart';

class ErrorInterceptor extends Interceptor {
  final GoRouter router;

  ErrorInterceptor({required this.router});
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    AppException customException;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      customException = NetworkException("Connection timed out");
    } else if (err.type == DioExceptionType.badResponse && response != null) {
      final code = response.statusCode ?? 0;
      final message = response.data['message'] ?? 'Server error';

      if (code == 401 || code == 403) {
        customException = UnauthorizedException(message);
      } else {
        customException = ServerException(message, code);
      }
    } else {
      customException = UnknownException(err.message ?? 'Unknown error');
    }

    return handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: customException,
      response: err.response,
      type: DioExceptionType.unknown,
    ));
  }
}