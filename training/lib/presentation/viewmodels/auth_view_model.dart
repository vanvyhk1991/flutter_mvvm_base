import 'package:training/core/network/app_exception.dart';

import '../../core/base/base_view_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecase/forgot_password_usecase.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/register_usecase.dart';

class AuthViewModel extends BaseViewModel {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthViewModel(
    this.loginUseCase,
    this.registerUseCase,
    this.forgotPasswordUseCase,
  );

  User? user;

  Future<void> login(String email, String password) async {
    setBusy(true);
    try {
      user = await loginUseCase(email, password);
      notifyListeners();
    } on AppException catch (e) {
      print("Handled AppException: ${e.message}");
    } catch (e) {
      setError('Login failed');
    } finally {
      setBusy(false);
    }
  }

  Future<void> register(String email, String password, String name) async {
    setBusy(true);
    try {
      user = await registerUseCase(email, password, name);
    } catch (e) {
      setError('Register failed');
    } finally {
      setBusy(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    setBusy(true);
    try {
      await forgotPasswordUseCase(email);
    } catch (e) {
      setError('Send forgot password failed');
    } finally {
      setBusy(false);
    }
  }
}
