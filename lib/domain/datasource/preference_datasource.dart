import 'dart:ui';

import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/domain/model/data_source.dart';

abstract interface class PreferenceDatasource {
  abstract final AppThemeMode themeMode;
  abstract final DataSource selectedDatasource;
  abstract final Locale locale;

  void setThemeMode(AppThemeMode mode);

  Future<String?> getToken();

  Future<void> setToken(String? token);

  Future<void> setSelectedDataSource(DataSource datasource);

  void setLocale(Locale locale);
}