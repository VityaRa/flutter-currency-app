import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:lr4/app/profile/profile_page.dart';
import 'package:lr4/app/utils/datasource_factory.dart';
import 'package:lr4/data/datasource_impl/preference_datasource_impl/preference_datasource_impl.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/sqflite_datasource_impl.dart';
import 'package:lr4/data/repository_impl/settings_repository_impl.dart';
import 'package:lr4/domain/datasource/preference_datasource.dart';
import 'package:lr4/domain/repository/settings_repository.dart';
import 'package:lr4/domain/service/logger_service.dart';
import 'package:provider/provider.dart';

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

// Добавляем импорт фабрики источников данных
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/datasource/db_datasource.dart';

void main() async {
  LoggerService.initialize(level: Level.ALL); 
  final appLogger = LoggerService.getAppLogger();
  appLogger.info('Приложение запускается...');
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем форматирование дат
  await initializeDateFormatting('ru_RU', null);

  final sharedPreferences = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();

  // Создаем PreferenceDatasource
  final preferenceDatasource = PreferenceDatasourceImpl(sharedPreferences, secureStorage);
  
  // Создаем SettingsRepository для получения текущего выбора источника
  final settingsRepository = SettingsRepositoryImpl(preferenceDatasource, null);

  // Инициализируем SettingsRepository для получения текущего DataSource
  await settingsRepository.initAsyncData();
  
  // Создаем DbDatasource на основе выбора пользователя
  final dbDatasource = DatasourceFactory.createDbDatasource(
    settingsRepository: settingsRepository,
  );

  // Создаем источник данных 
  final restDatasource = RestDatasourceImpl();
  final networkService = NetworkService();

  runApp(GlobalProviders(
    restDatasource: restDatasource,
    networkService: networkService,
    dbDatasource: dbDatasource,
    preferenceDatasource: preferenceDatasource,
    settingsRepository: settingsRepository, // Добавляем SettingsRepository
    child: const App(),
  ));
}

class GlobalProviders extends StatefulWidget {
  final RestDatasourceImpl restDatasource;
  final NetworkService networkService;
  final DbDatasource? dbDatasource; // Теперь может быть null
  final PreferenceDatasourceImpl preferenceDatasource;
  final SettingsRepository settingsRepository; // Добавляем
  final Widget child;

  const GlobalProviders({
    super.key,
    required this.restDatasource,
    required this.networkService,
    required this.dbDatasource,
    required this.preferenceDatasource,
    required this.settingsRepository,
    required this.child,
  });

  @override
  State<GlobalProviders> createState() => _GlobalProvidersState();
}

class _GlobalProvidersState extends State<GlobalProviders> {
  late DbDatasource? _currentDbDatasource;

  @override
  void initState() {
    super.initState();
    _currentDbDatasource = widget.dbDatasource;
  }

  Future<void> _switchDataSource(DataSource newSource) async {
    // Сохраняем новый выбор
    await widget.settingsRepository.setDataSource(newSource);
    
    // Закрываем текущую базу данных если есть
    await _currentDbDatasource?.dispose();
    
    // Создаем новую базу данных
    final newDatasource = DatasourceFactory.createDbDatasource(
      settingsRepository: widget.settingsRepository,
    );
    
    setState(() {
      _currentDbDatasource = newDatasource;
    });
    
    // Уведомляем о необходимости пересоздания репозиториев
    // В реальном приложении здесь может потребоваться перезагрузка приложения
    // или обновление всех провайдеров
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferenceDatasource>.value(value: widget.preferenceDatasource),
        Provider<SettingsRepository>.value(value: widget.settingsRepository),
        Provider<NetworkService>.value(value: widget.networkService),
        Provider<DbDatasource?>(
          // Передаем текущий источник данных (может быть null)
          create: (_) => _currentDbDatasource,
        ),
        // Репозитории зависят от DbDatasource
        ProxyProvider<DbDatasource?, CurrencyRepository>(
          update: (_, dbDatasource, __) => CurrencyRepositoryImpl(
            widget.restDatasource,
            dbDatasource,
          ),
        ),
        ProxyProvider<DbDatasource?, NewsRepository>(
          update: (_, dbDatasource, __) => NewsRepositoryImpl(
            widget.restDatasource,
            dbDatasource,
          ),
        ),
        // Провайдер для смены источника данных
        Provider<Function(DataSource)>(
          create: (_) => _switchDataSource,
        ),
      ],
      child: widget.child,
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