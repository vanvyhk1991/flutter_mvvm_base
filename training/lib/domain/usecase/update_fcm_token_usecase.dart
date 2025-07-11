import '../../data/repositories/notification/notification_repository.dart';

class UpdateFCMTokenUseCase {
  final NotificationRepository repository;

  UpdateFCMTokenUseCase(this.repository);

  Future<void> call(String token) {
    return repository.updateFCMToken(token);
  }
} 