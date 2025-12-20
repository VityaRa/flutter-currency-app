// import 'package:lr4/app/profile/profile_page.dart';
import 'dart:ui';

import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/domain/model/data_source.dart';

abstract interface class SettingsRepository {
  Future<void> initAsyncData();

  // Аутентификация
  abstract final Stream<bool> isAuthStream;
  abstract final bool isAuth;
  Future<String?> getToken();
  Future<void> setToken(String? token);

  // Тема
  abstract final Stream<AppThemeMode> themeModeStream;
  abstract final AppThemeMode themeMode;
  void setThemeMode(AppThemeMode mode);

  // Локаль
  abstract final Stream<Locale> localeStream;
  abstract final Locale locale;
  void setLocale(Locale locale);

  // Источник данных
  abstract final Stream<DataSource> dataSourceStream;
  abstract final DataSource dataSource;
  Future<void> setDataSource(DataSource source);

  // Кэш
  Future<void> clearAllCache();
  // Future<void> clearNewsCache();
  // Future<void> clearCurrencyCache();


}