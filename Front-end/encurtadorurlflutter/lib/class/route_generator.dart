import 'package:flutter/material.dart';
import 'package:test_encurtar_link/pages/dashboardpage/dashboard.page.dart';
import 'package:test_encurtar_link/pages/homepage/home.page.dart';
import '../pages/loginpage/login.page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case '/dashboard':
        return MaterialPageRoute(
            builder: (_) => const DashBoardPage(),
          );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
