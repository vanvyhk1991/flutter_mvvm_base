abstract class NotificationRepository {
  /// Gửi FCM token lên server
  Future<void> updateFCMToken(String token);
  
  /// Subscribe user to topic
  Future<void> subscribeToTopic(String topic);
  
  /// Unsubscribe user from topic
  Future<void> unsubscribeFromTopic(String topic);
} 