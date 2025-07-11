import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:go_router/go_router.dart';
import 'package:training/core/network/auth_change_notifier.dart';
import 'package:training/notifications/notification_service.dart';
import 'package:training/notifications/notification_navigation_service.dart';
import 'package:training/presentation/pages/user/user_view.dart' show UserView;
import 'package:training/route/app_route.dart';

import 'injection/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final appRouter = AppRouter(AuthChangeNotifier()); // Hoặc build trực tiếp GoRouter instance
  setupDependencies(appRouter.router);
  
  // Khởi tạo notification service
  final notificationService = getIt<NotificationService>();
  await notificationService.initialize();
  
  // Lấy notification navigation service và set router
  final navigationService = getIt<NotificationNavigationService>();
  navigationService.setRouter(appRouter.router);
  
  runApp(MyApp(router: appRouter.router,));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({required this.router, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 932),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const UserView(),
      ),
    );
  }
}
