import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:training/core/cache/memory_cache.dart';
import 'package:training/presentation/pages/auth/login_screen.dart';
import 'package:training/presentation/pages/product/product_screen.dart';

import '../core/network/auth_change_notifier.dart';

class AppRouter {
  final GoRouter router;
  // final authNotifier = AuthChangeNotifier(InMemoryCache.authStream);

  AppRouter(AuthChangeNotifier authNotifier) : router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) =>  LoginScreen(),
      ),

      GoRoute(
        path: '/product',
        name: 'product',
        builder: (context, state) => ProductScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = InMemoryCache.token != null;
      final isLoggingIn = state.path.toString().startsWith('/login');

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null; // không redirect
    },
    refreshListenable: authNotifier,
  );
}