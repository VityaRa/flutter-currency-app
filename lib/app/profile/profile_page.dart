import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:lr4/app/home.dart';
import 'package:lr4/app/home/home_cubit.dart';
import 'package:lr4/app/login_page.dart';
import 'package:lr4/app/splash_page.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/app/utils/theme_mode_ext.dart';
import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/repository/settings_repository.dart';
import 'package:lr4/domain/service/logger_service.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

part 'theme_mode_selector_bs.dart';
part 'data_source_selector_bs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ValueNotifier<AppThemeMode> _themeModeNotifier =
      ValueNotifier(_settingsRepository.themeMode);
  late final ValueNotifier<DataSource> _dataSourceNotifier =
      ValueNotifier(_settingsRepository.dataSource);
  static final Logger _logger = LoggerService.getUILogger('Profile');

  SettingsRepository get _settingsRepository =>
      context.read<SettingsRepository>();

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    _dataSourceNotifier.dispose();
    super.dispose();
  }

  Future<void> _clearCache(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистка кэша'),
        content: const Text(
            'Вы уверены, что хотите очистить все сохранённые данные? '
            'При следующем запуске приложения данные будут загружены заново.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Очистить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        // Очищаем кэш через репозитории
        await _settingsRepository.clearAllCache();

        // Показываем уведомление об успехе
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Кэш успешно очищен'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Показываем уведомление об ошибке
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Ошибка при очистке кэша: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Метод для показа диалога перезагрузки
  Future<void> _showRestartDialog(
      BuildContext context, DataSource newSource) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Перезагрузка приложения'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Вы выбрали источник данных: ${newSource.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Для применения изменений приложение необходимо перезагрузить.',
            ),
            const SizedBox(height: 8),
            Text(
              _getDataSourceDescription(newSource),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Перезагрузить',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      _restartApplication();
    }
  }

  // Метод для получения описания источника данных
  String _getDataSourceDescription(DataSource source) {
    switch (source) {
      case DataSource.network:
        return 'Данные будут загружаться только из сети, без локального кэширования';
      case DataSource.sqfLite:
        return 'Используется SQLite для локального хранения данных';
      case DataSource.drift:
        return 'Используется Drift ORM для локального хранения данных';
    }
  }

  void _restartApplication() {
    _logger.info("Перезагрузка...");
    Restart.restartApp(); // Полная перезагрузка приложения
  }

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Настройка темы
            ValueListenableBuilder(
              valueListenable: _themeModeNotifier,
              builder:
                  (BuildContext context, AppThemeMode mode, Widget? child) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 24),
                  leading: const Icon(Icons.dark_mode),
                  title: child,
                  subtitle: Text(
                    mode.title,
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final AppThemeMode? newMode =
                        await ThemeModeSelectorBottomSheet.show(context, mode);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                  },
                );
              },
              child: Text(
                'Тема',
                style: fonts.regular16,
              ),
            ),

            // Настройка источника данных
            ValueListenableBuilder(
              valueListenable: _dataSourceNotifier,
              builder:
                  (BuildContext context, DataSource source, Widget? child) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 24),
                  leading: const Icon(Icons.storage),
                  title: child,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        source.name,
                        style: fonts.regular12,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getDataSourceDescription(source),
                        style: fonts.regular12.copyWith(
                          color: colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final DataSource? newSource =
                        await DataSourceSelectorBottomSheet.show(
                            context, source);
                    if (newSource == null) return;

                    // Если выбран тот же источник - ничего не делаем
                    if (newSource == source) return;

                    // Показываем диалог перезагрузки
                    await _showRestartDialog(context, newSource);
                  },
                );
              },
              child: Text(
                'Источник данных',
                style: fonts.regular16,
              ),
            ),

            // Очистка кэша
            ListTile(
              contentPadding: const EdgeInsets.only(left: 24),
              leading: Icon(Icons.delete_outline, color: colors.red),
              title: Text(
                'Очистить кэш',
                style: fonts.regular16,
              ),
              subtitle: Text(
                'Удалить все сохранённые данные',
                style: fonts.regular12.copyWith(color: colors.grey),
              ),
              onTap: () => _clearCache(context),
            ),

            const Spacer(),

            // Кнопка выхода
            ElevatedButton(
              onPressed: () =>
                  context.read<SettingsRepository>().setToken(null),
              child: Text(
                'Выйти',
                style: fonts.regular14.copyWith(color: context.colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Временный виджет для имитации перезагрузки
class _RestartWrapper extends StatefulWidget {
  const _RestartWrapper();

  @override
  State<_RestartWrapper> createState() => __RestartWrapperState();
}

class __RestartWrapperState extends State<_RestartWrapper> {
  @override
  void initState() {
    super.initState();
    // Имитируем задержку перезагрузки
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Возвращаемся на главный экран
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const _AppReloader(),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Перезагрузка приложения...'),
            SizedBox(height: 10),
            Text(
              'Применяем новый источник данных',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Виджет который перезагружает приложение
class _AppReloader extends StatelessWidget {
  const _AppReloader();

  @override
  Widget build(BuildContext context) {
    // Получаем текущие настройки
    final settingsRepository = context.read<SettingsRepository>();

    return StreamBuilder<bool>(
      stream: settingsRepository.isAuthStream,
      initialData: settingsRepository.isAuth,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashPage();
        }

        final bool isAuth = snapshot.data ?? false;

        if (!isAuth) {
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
    );
  }
}

// Добавьте эти импорты если их нет:
// import 'package:lr4/app/login_page.dart';
// import 'package:lr4/app/splash_page.dart';
// import 'package:lr4/app/home/home_cubit.dart';
