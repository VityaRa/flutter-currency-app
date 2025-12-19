import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart'; // Для дат
import 'package:lr4/app/profile/profile_page.dart';
import 'package:lr4/data/datasource_impl/preference_datasource_impl/preference_datasource_impl.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/sqflite_datasource_impl.dart';
import 'package:lr4/data/repository_impl/settings_repository_impl.dart';
import 'package:lr4/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart'; // Для провайдеров репозиториев

// Импортируем маршруты и экраны
import 'package:lr4/app/app_routes.dart';
import 'package:lr4/app/home.dart';
import 'package:lr4/app/settings_page.dart';
import 'package:lr4/app/result_screen.dart';
import 'package:lr4/app/currency_detail/currency_detail_page.dart';
import 'package:lr4/app/login_page.dart';
import 'package:lr4/app/splash_page.dart';

// Импортируем Cubits
import 'package:lr4/app/home/home_cubit.dart';

// Импортируем Слои данных 
import 'package:lr4/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:lr4/data/repository_impl/currency_repository_impl.dart';
import 'package:lr4/data/repository_impl/news_repository_impl.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/repository/news_repository.dart';
import 'package:lr4/domain/service/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/app/utils/theme/theme_data.dart' as custom_theme;
import 'package:lr4/app/utils/theme_mode_ext.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем форматирование дат
  await initializeDateFormatting('ru_RU', null);

  final sharedPreferences = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();

  final dbDatasource = SqfliteDatasourceImpl();
  final preferenceDatasource = PreferenceDatasourceImpl(sharedPreferences, secureStorage);

  // Создаем источник данных 
  final restDatasource = RestDatasourceImpl();
  final networkService = NetworkService();

  runApp(GlobalProviders(
    restDatasource: restDatasource,
    networkService: networkService,
    dbDatasource: dbDatasource,
    preferenceDatasource: preferenceDatasource,
    child: const App(),
  ));
}

class GlobalProviders extends StatelessWidget {
  final RestDatasourceImpl restDatasource;
  final NetworkService networkService;
  final SqfliteDatasourceImpl dbDatasource;
  final PreferenceDatasourceImpl preferenceDatasource;
  final Widget child;

  const GlobalProviders({
    super.key,
    required this.restDatasource,
    required this.networkService,
    required this.dbDatasource,
    required this.preferenceDatasource,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Сначала внедряем Репозитории
    return MultiProvider(
      providers: [
        Provider<CurrencyRepository>(
          create: (_) => CurrencyRepositoryImpl(
            restDatasource,
            dbDatasource,
          ),
        ),
        Provider<NewsRepository>(
          create: (_) => NewsRepositoryImpl(
            restDatasource,
            dbDatasource,
          ),
        ),
        Provider<NetworkService>(
          create: (_) => networkService,
        ),
        Provider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(preferenceDatasource, dbDatasource),
        ),
      ],
      child: child,
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  Future<void> _initData() async {
    await Future.delayed(const Duration(seconds: 1));
    await _settingsRepository.initAsyncData();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _settingsRepository.themeModeStream,
      builder: (BuildContext context, AsyncSnapshot<AppThemeMode> snapshot) {
        final AppThemeMode appThemeMode = snapshot.data ?? _settingsRepository.themeMode;
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().appThemeData,
          darkTheme: ThemeData.dark().appThemeData,
          themeMode: appThemeMode.themeMode,
          home: StreamBuilder(
            stream: _settingsRepository.isAuthStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashPage();
              }

              final bool isAuth = snapshot.data ?? _settingsRepository.isAuth;
              
              // Если пользователь не авторизован, показываем LoginPage
              if (!isAuth) {
                return const LoginPage();
              }
              
              // Если авторизован, показываем HomePage с BlocProvider
              return MultiBlocProvider(
                providers: [
                  BlocProvider<HomeCubit>(
                    create: (context) => HomeCubit(),
                  ),
                ],
                child: const HomePage(),
              );
            },
          ),
          routes: {
            AppRoutes.home: (context) {
              // Проверяем авторизацию для маршрута home
              final settingsRepository = context.read<SettingsRepository>();
              if (!settingsRepository.isAuth) {
                return const LoginPage();
              }
              return MultiBlocProvider(
                providers: [
                  BlocProvider<HomeCubit>(
                    create: (context) => HomeCubit(),
                  ),
                ],
                child: const HomePage(),
              );
            },
            AppRoutes.settings: (context) => const SettingsPage(),
            AppRoutes.profile: (context) => const ProfilePage(),
            AppRoutes.resultScreen: (context) => const ResultScreen(),
          },
          
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.currencyDetail) {
              // Пытаемся извлечь аргументы как Map
              final args = settings.arguments;
              
              String title = 'Детали';
              String currencyId = '';

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
                  currencyId: currencyId,
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}