import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/splash/splash_screen.dart';
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home': return MaterialPageRoute(builder: (_) => DashboardScreen());
      case '/profile': return MaterialPageRoute(builder: (_) => ProfileScreen());
      default: return MaterialPageRoute(builder: (_) => DashboardScreen());
    }
  }
}
