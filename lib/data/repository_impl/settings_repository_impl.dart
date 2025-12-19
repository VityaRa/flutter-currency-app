import 'dart:async';

import 'package:lr4/domain/datasource/db_datasource.dart';
import 'package:lr4/domain/datasource/preference_datasource.dart';
import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._datasource,
    this._dbDatasource
  );

  final PreferenceDatasource _datasource;
  final DbDatasource? _dbDatasource;

  final StreamController<bool> _authStatusController =
      StreamController.broadcast();
  final StreamController<AppThemeMode> _themeModeController =
      StreamController.broadcast();
  final StreamController<DataSource> _datasourceController =
      StreamController.broadcast();

  late bool _isAuth;

  @override
  Future<void> initAsyncData() async {
    final bool isAuth = await getToken() != null;
    _authStatusController.add(isAuth);
    _isAuth = isAuth;

    _datasourceController.add(dataSource);
  }

  @override
  Stream<bool> get isAuthStream => _authStatusController.stream;

  @override
  bool get isAuth => _isAuth;

  @override
  Stream<AppThemeMode> get themeModeStream => _themeModeController.stream;

  @override
  AppThemeMode get themeMode => _datasource.themeMode;

  @override
  void setThemeMode(AppThemeMode mode) {
    _datasource.setThemeMode(mode);

    _themeModeController.add(mode);
  }

  @override
  Future<String?> getToken() => _datasource.getToken();

  @override
  Future<void> setToken(String? token) async {
    await _datasource.setToken(token);

    _authStatusController.add(token != null);
  }

  @override
  Future<void> clearAllCache() {
    if (_dbDatasource != null) {
      return _dbDatasource.clearAll();
    }

    return Future.delayed(const Duration(microseconds: 1));
  }

  @override
  Future<void> setDataSource(DataSource source) async {
    print(source);
    await _datasource.setSelectedDataSource(source);
    _datasourceController.add(source);
  }

  @override
  Stream<DataSource> get dataSourceStream => _datasourceController.stream;

  @override
  DataSource get dataSource => _datasource.selectedDatasource;
}
