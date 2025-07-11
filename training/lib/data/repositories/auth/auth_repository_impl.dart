import '../../models/user_model.dart';
import '../../services/auth_api_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService api;

  AuthRepositoryImpl(this.api);

  @override
  Future<User> login(String email, String password) {
    return api.login({'email': email, 'password': password});
  }

  @override
  Future<void> forgotPassword(String email) {
    return api.forgotPassword({'email': email});
  }

  @override
  Future<User> register(String email, String password, String name) {
    return api.register({'email': email, 'password': password, 'name': name});
  }
}