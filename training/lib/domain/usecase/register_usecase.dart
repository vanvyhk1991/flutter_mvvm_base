
import '../../data/models/user_model.dart';
import '../../data/repositories/auth/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> call(String email, String password, String name) {
    return repository.register(email, password, name);
  }
}