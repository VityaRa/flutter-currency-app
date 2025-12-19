// lib/core/datasource_provider.dart

import 'package:flutter/material.dart';
import 'package:lr4/domain/datasource/db_datasource.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/repository/settings_repository.dart';
import 'datasource_factory.dart';

class DatasourceProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  DbDatasource? _dbDatasource;
  
  DatasourceProvider(this._settingsRepository) {
    _initDatasource();
  }
  
  void _initDatasource() {
    _dbDatasource = DatasourceFactory.createDbDatasource(
      settingsRepository: _settingsRepository,
    );
  }
  
  DbDatasource? get dbDatasource => _dbDatasource;
  
  bool get hasLocalDatasource => _dbDatasource != null;
  
  Future<void> switchDataSource(DataSource newSource) async {
    await _settingsRepository.setDataSource(newSource);
    
    _dbDatasource = DatasourceFactory.getActiveDbDatasourceOrNull(
      settingsRepository: _settingsRepository,
      currentDatasource: _dbDatasource,
    );
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _dbDatasource?.dispose();
    super.dispose();
  }
}