import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationNavigationService {
  static final NotificationNavigationService _instance = 
      NotificationNavigationService._internal();
  factory NotificationNavigationService() => _instance;
  NotificationNavigationService._internal();

  GoRouter? _router;

  /// Set router instance
  void setRouter(GoRouter router) {
    _router = router;
  }

  /// Handle navigation from notification
  void handleNotificationNavigation(Map<String, dynamic> data) {
    if (_router == null) {
      debugPrint('Router not initialized');
      return;
    }

    try {
      final String? screen = data['screen'];
      final String? action = data['action'];
      final String? id = data['id'];

      switch (screen) {
        case 'login':
          _router!.go('/login');
          break;
        case 'product':
          if (id != null) {
            _router!.go('/product/$id');
          } else {
            _router!.go('/product');
          }
          break;
        case 'user':
          _router!.go('/user');
          break;
        case 'home':
          _router!.go('/');
          break;
        default:
          debugPrint('Unknown screen: $screen');
      }

      // Handle specific actions
      if (action != null) {
        _handleAction(action, data);
      }
    } catch (e) {
      debugPrint('Error handling notification navigation: $e');
    }
  }

  /// Handle specific actions
  void _handleAction(String action, Map<String, dynamic> data) {
    switch (action) {
      case 'refresh':
        // Refresh current screen data
        debugPrint('Refreshing current screen');
        break;
      case 'show_dialog':
        // Show dialog with message
        final String? message = data['message'];
        if (message != null) {
          _showDialog(message);
        }
        break;
      default:
        debugPrint('Unknown action: $action');
    }
  }

  /// Show dialog
  void _showDialog(String message) {
    if (_router?.routerDelegate.navigatorKey.currentContext != null) {
      showDialog(
        context: _router!.routerDelegate.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
} 