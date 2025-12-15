import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart'; // Для дат
import 'package:provider/provider.dart'; // Для провайдеров репозиториев

// Импортируем маршруты и экраны
import 'package:lr4/app/app_routes.dart';
import 'package:lr4/app/home.dart';
import 'package:lr4/app/settings_page.dart';
import 'package:lr4/app/result_screen.dart';
import 'package:lr4/app/currency_detail/currency_detail_page.dart'; 

// Импортируем Cubits
import 'package:lr4/app/home/home_cubit.dart';

// Импортируем Слои данных 
import 'package:lr4/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:lr4/data/repository_impl/currency_repository_impl.dart';
import 'package:lr4/data/repository_impl/news_repository_impl.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/repository/news_repository.dart';
import 'package:lr4/domain/service/network_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем форматирование дат
  await initializeDateFormatting('ru_RU', null);

  // Создаем источник данных 
  final restDatasource = RestDatasourceImpl();
  final networkService = NetworkService();

 runApp(App(
    restDatasource: restDatasource,
    networkService: networkService, 
  ));
}

class App extends StatelessWidget {
  final RestDatasourceImpl restDatasource;
  final NetworkService networkService;

  const App({
    super.key, 
    required this.restDatasource,
    required this.networkService, 
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3929C7);
    const backgroundColor = Color(0xFFf2f2f2);
    const secondaryColor = Color(0xFF7F7F7F);

    // 1. Сначала внедряем Репозитории
    return MultiProvider(
      providers: [
        Provider<CurrencyRepository>(
          create: (_) => CurrencyRepositoryImpl(restDatasource),
        ),
        Provider<NewsRepository>(
          create: (_) => NewsRepositoryImpl(restDatasource),
        ),
        Provider<NetworkService>(
          create: (_) => networkService,
        ),
      ],
      // 2. Затем внедряем Блоки/Кубиты
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(),
          ),
        ],
        // 3. Затем само приложение (UI)
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.home,
          
          routes: {
            AppRoutes.home: (context) => const HomePage(),
            AppRoutes.settings: (context) => const SettingsPage(),
            AppRoutes.resultScreen: (context) => const ResultScreen(),
          },
          
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.currencyDetail) {
              // Пытаемся извлечь аргументы как Map
              final args = settings.arguments;
              
              String title = 'Детали';
              String currencyId = ''; // Значение по умолчанию или для обработки ошибок

              // Если аргументы переданы как Map
              if (args is Map<String, dynamic>) {
                 title = args['title'] as String? ?? 'Детали';
                 currencyId = args['currencyId'] as String? ?? '';
              } 
              // Если аргументы переданы просто как строка
              else if (args is String) {
                 title = args;
              }

              return MaterialPageRoute(
                builder: (context) => CurrencyDetailPage(
                  title: title,
                  currencyId: currencyId, // Передаем ID 
                ),
              );
            }
            return null;
          },

          theme: ThemeData(
            primaryColor: primaryColor,
            scaffoldBackgroundColor: backgroundColor,
            useMaterial3: true, 
            appBarTheme: const AppBarTheme(
              backgroundColor: backgroundColor,
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              titleTextStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.black,
              ),
              centerTitle: true,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: primaryColor,
              unselectedItemColor: secondaryColor,
              selectedLabelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: primaryColor,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: secondaryColor,
              ),
              type: BottomNavigationBarType.fixed, 
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // Импортируем маршруты
// import 'package:lr4/app/app_routes.dart'; 
// import 'package:lr4/app/home.dart'; 
// // import 'package:lr3/app/splash_page.dart'; 
// // import 'package:lr3/app/currency_detail/currency_detail_page.dart';

// // Импортируем Cubits
// import 'package:lr4/app/home/home_cubit.dart'; 

// import 'package:lr4/app/settings_page.dart'; 
// import 'package:lr4/app/result_screen.dart';

// void main() {
//   runApp(const App());
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF3929C7);
//     const backgroundColor = Color(0xFFf2f2f2);
//     const secondaryColor = Color(0xFF7F7F7F);

//     return MultiBlocProvider(
//       // BlocProvider'ы, которые должны быть доступны во всем приложении
//       providers: [
//         BlocProvider<HomeCubit>( 
//           create: (context) => HomeCubit(),
//         ),
//       ],
//       child: MaterialApp(
//         // 1. Устанавливаем стартовый маршрут
//         initialRoute: AppRoutes.home, 

//         // 2. Определяем карту маршрутов
//         routes: {
//           // AppRoutes.splash: (context) => const SplashPage(),
//           AppRoutes.home: (context) => const HomePage(),

//           // AppRoutes.currencyDetail: (context) {
//           //   final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
//           //   final title = args?['title'] ?? 'Детали Валюты';
//           //   return CurrencyDetailPage(title: title);
//           // },

//           AppRoutes.settings: (context) => const SettingsPage(),
//           AppRoutes.resultScreen: (context) => const ResultScreen(),
//         },

//          // Настройки темы 
//          theme: ThemeData(
//            primaryColor: primaryColor,
//            scaffoldBackgroundColor: backgroundColor,
//           appBarTheme: const AppBarTheme(
//             backgroundColor: backgroundColor,
//             elevation: 0.0,
//             scrolledUnderElevation: 0.0,
//             titleTextStyle: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 16,
//                color: Colors.black,
//             ),
//              centerTitle: true,
//            ),
//            bottomNavigationBarTheme: BottomNavigationBarThemeData(
//              backgroundColor: Colors.white,
//              selectedItemColor: primaryColor,
//              unselectedItemColor: secondaryColor,
//              selectedLabelStyle: const TextStyle(
//                fontFamily: 'Inter',
//                fontSize: 12,
//                color: primaryColor,
//              ),
//              unselectedLabelStyle: const TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 12,
//               color: secondaryColor,
//             ),
//            ),
//          ),
//        ),
//      );
//    }
// }