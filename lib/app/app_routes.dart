// app/app_routes.dart

abstract class AppRoutes {
  // Главные маршруты приложения
  static const String splash = '/'; // Стартовая страница (Splash Page)
  static const String home = '/home'; // Главный экран с BottomNavigationBar
  
  // Маршруты внутри вкладок (Currency Stack)
  static const String currencyList = '/currencyList';
  static const String currencyDetail = '/currencyDetail';

  // Дополнительные маршруты
  static const String settings = '/settings';
  static const String resultScreen = '/resultScreen';
}