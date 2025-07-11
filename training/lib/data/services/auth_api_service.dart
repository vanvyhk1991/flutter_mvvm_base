
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';
part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST('/login')
  Future<User> login(@Body() Map<String, dynamic> body);

  @POST('/register')
  Future<User> register(@Body() Map<String, dynamic> body);

  @POST('/forgot-password')
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);
}
