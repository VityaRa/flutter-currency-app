import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:lr4/app/gen/l10n/app_localizations.dart';
import 'package:lr4/app/home.dart';
import 'package:lr4/app/home/home_cubit.dart';
import 'package:lr4/app/login_page.dart';
import 'package:lr4/app/splash_page.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/app/utils/theme_mode_ext.dart';
import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/repository/news_repository.dart';
import 'package:lr4/domain/repository/settings_repository.dart';
import 'package:lr4/domain/service/logger_service.dart';
import 'package:restart_app/restart_app.dart';

part 'theme_mode_selector_bs.dart';
part 'data_source_selector_bs.dart';
part 'language_selector_bs.dart';

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
  late final ValueNotifier<Locale> _localeNotifier =
      ValueNotifier(_settingsRepository.locale); // Нотификатор для локали
  
  static final Logger _logger = LoggerService.getUILogger('Profile');

  SettingsRepository get _settingsRepository =>
      context.read<SettingsRepository>();

  NewsRepository get _newsRepository => context.read<NewsRepository>();

  CurrencyRepository get _currencyRepository => context.read<CurrencyRepository>();

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    _dataSourceNotifier.dispose();
    _localeNotifier.dispose();
    super.dispose();
  }

  Future<void> _clearCache(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc.clearCache),
        content: Text(context.loc.confirmClearCache),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              context.loc.clear,
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
        await _newsRepository.clearCache();
        await _currencyRepository.clearCache();
        // Показываем уведомление об успехе
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(context.loc.cacheCleared),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Показываем уведомление об ошибке
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${context.loc.cacheClearError}: $e'),
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
        title: Text(context.loc.restartApp),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.loc.chosedDataSource}: ${newSource.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              context.loc.restartForApply,
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
            child: Text(context.loc.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              context.loc.restart,
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
        return context.loc.dataWillLoadedViaNetwork;
      case DataSource.sqfLite:
        return context.loc.localStorageInfo("SQLite");
      case DataSource.drift:
        return context.loc.localStorageInfo("Drift");
    }
  }

  // Метод для получения названия языка
  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return context.loc.languageRussian;
      case 'en':
        return context.loc.languageEnglish;
      case 'es':
        return context.loc.languageSpanish;
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  String _getThemeName(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.system:
        return context.loc.system;
      case AppThemeMode.light:
        return context.loc.light;
      case AppThemeMode.dark:
        return context.loc.dark;
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
      appBar: AppBar(title: Text(context.loc.profile)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Настройка темы
            ValueListenableBuilder(
              valueListenable: _themeModeNotifier,
              builder: (BuildContext context, AppThemeMode mode, Widget? child) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 24),
                  leading: const Icon(Icons.dark_mode),
                  title: child,
                  subtitle: Text(
                    _getThemeName(mode),
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final AppThemeMode? newMode =
                        await ThemeModeSelectorBottomSheet.show(context, mode);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                    _settingsRepository.setThemeMode(newMode);
                  },
                );
              },
              child: Text(
                context.loc.theme,
                style: fonts.regular16,
              ),
            ),

            // Настройка языка
            ValueListenableBuilder(
              valueListenable: _localeNotifier,
              builder: (BuildContext context, Locale locale, Widget? child) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 24),
                  leading: const Icon(Icons.language),
                  title: child,
                  subtitle: Text(
                    _getLanguageName(locale),
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final Locale? newLocale =
                        await LanguageSelectorBottomSheet.show(context, locale);
                    if (newLocale == null) return;

                    _localeNotifier.value = newLocale;
                    _settingsRepository.setLocale(newLocale);
                    
                    // Показываем уведомление о смене языка
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       '${context.loc.language} ${context.loc.changedTo} ${_getLanguageName(newLocale)}',
                    //     ),
                    //     duration: const Duration(seconds: 2),
                    //   ),
                    // );
                  },
                );
              },
              child: Text(
                context.loc.language, // Можно добавить в локализацию
                style: fonts.regular16,
              ),
            ),

            // Настройка источника данных
            ValueListenableBuilder(
              valueListenable: _dataSourceNotifier,
              builder: (BuildContext context, DataSource source, Widget? child) {
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
                        await DataSourceSelectorBottomSheet.show(context, source);
                    if (newSource == null) return;

                    // Если выбран тот же источник - ничего не делаем
                    if (newSource == source) return;

                    // Показываем диалог перезагрузки
                    await _showRestartDialog(context, newSource);
                  },
                );
              },
              child: Text(
                context.loc.dataSource,
                style: fonts.regular16,
              ),
            ),

            // Очистка кэша
            ListTile(
              contentPadding: const EdgeInsets.only(left: 24),
              leading: Icon(Icons.delete_outline, color: colors.red),
              title: Text(
                context.loc.clearCache,
                style: fonts.regular16,
              ),
              subtitle: Text(
                context.loc.removeAllSavedData,
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
                context.loc.logout,
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(context.loc.restartApp),
            SizedBox(height: 10),
            Text(
              context.loc.applyNewDatasource,
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