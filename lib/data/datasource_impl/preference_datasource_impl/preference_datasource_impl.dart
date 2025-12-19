import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lr4/data/datasource_impl/preference_datasource_impl/mapper/app_theme_mode_mapper.dart';
import 'package:lr4/data/datasource_impl/preference_datasource_impl/mapper/selected_datasource_mode_mapper.dart';
import 'package:lr4/data/datasource_impl/preference_datasource_impl/model/app_theme_mode_dao.dart';
import 'package:lr4/data/datasource_impl/preference_datasource_impl/model/selected_datasource_dao.dart';
import 'package:lr4/domain/datasource/preference_datasource.dart';
import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class _Keys {
  static const String theme = 'theme_key';
  static const String token = 'token_key';
  static const String dataSource = 'datasource_key';
}

class PreferenceDatasourceImpl implements PreferenceDatasource {
  const PreferenceDatasourceImpl(this._sharedPreferences, this._secureStorage);

  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;

  @override
  AppThemeMode get themeMode {
    final String? theme = _sharedPreferences.getString(_Keys.theme);

    return AppThemeModeDao.fromString(theme).model;
  }

  @override
  void setThemeMode(AppThemeMode mode) => _sharedPreferences.setString(_Keys.theme, mode.name);

  @override
  Future<String?> getToken() => _secureStorage.read(key: _Keys.theme);

  @override
  Future<void> setToken(String? token) => _secureStorage.write(key: _Keys.token, value: token);

  @override
  DataSource get selectedDatasource {
    final String? selectedDatasource = _sharedPreferences.getString(_Keys.dataSource);
    print('selectedDatasource, $selectedDatasource');
    return DataSourceDao.fromString(selectedDatasource).model;
  }

  @override
  Future<void> setSelectedDataSource(DataSource datasource) {
    print("setSelectedDataSource $datasource");
    print(selectedDatasource);
    return _sharedPreferences.setString(_Keys.dataSource, datasource.name);
  }
}