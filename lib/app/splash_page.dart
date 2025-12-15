// splash_page.dart

import 'package:flutter/material.dart';
import 'package:lr4/app/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
     super.initState();
    // Запускаем инициализацию после того, как виджет построен
    _initAppAndNavigate();
  }

   // 1. Метод для имитации инициализации приложения
   Future<void> _initAppAndNavigate() async {
     // Имитируем задержку инициализации
     await Future.delayed(const Duration(seconds: 3));

     // 2. Переход на главный экран с заменой маршрута
     if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

   @override
  Widget build(BuildContext context) {
    // SplashPage остается простым
    return Scaffold(
      body: const Center(
         child: FlutterLogo(size: 128), 
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}