abstract class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => '$runtimeType (code: $code): $message';
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class ServerException extends AppException {
  ServerException(String message, [int? code]) : super(message, code);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = "Unauthorized"]) : super(message, 401);
}

class UnknownException extends AppException {
  UnknownException([String message = "Unknown error"]) : super(message);
}