import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api_service.g.dart';

@RestApi()
abstract class NotificationApiService {
  factory NotificationApiService(Dio dio, {String baseUrl}) = _NotificationApiService;

  /// Gửi FCM token lên server
  @POST('/notifications/token')
  Future<void> updateFCMToken(@Body() Map<String, dynamic> body);

  /// Subscribe user to topic
  @POST('/notifications/subscribe')
  Future<void> subscribeToTopic(@Body() Map<String, dynamic> body);

  /// Unsubscribe user from topic
  @POST('/notifications/unsubscribe')
  Future<void> unsubscribeFromTopic(@Body() Map<String, dynamic> body);
} 