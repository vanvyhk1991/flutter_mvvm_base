import '../../services/notification_api_service.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApiService api;

  NotificationRepositoryImpl(this.api);

  @override
  Future<void> updateFCMToken(String token) {
    return api.updateFCMToken({'token': token});
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    return api.subscribeToTopic({'topic': topic});
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    return api.unsubscribeFromTopic({'topic': topic});
  }
} 