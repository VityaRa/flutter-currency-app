// lib/core/datasource_factory.dart

import 'package:lr4/data/datasource_impl/drift_datasource_impl/drift_datasource_impl.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/sqflite_datasource_impl.dart';
import 'package:lr4/domain/datasource/db_datasource.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/repository/settings_repository.dart';

class DatasourceFactory {
  static DbDatasource createDbDatasource({
    required SettingsRepository settingsRepository,
  }) {
    final dataSource = settingsRepository.dataSource;
    
    switch (dataSource) {
      case DataSource.network:
      case DataSource.sqfLite:
        return SqfliteDatasourceImpl();
      case DataSource.drift:
        return DriftDatasourceImpl();
    }
  }
  
  // Метод для получения активного источника с обработкой null
  static DbDatasource getActiveDbDatasourceOrNull({
    required SettingsRepository settingsRepository,
    DbDatasource? currentDatasource,
  }) {
    final dataSource = settingsRepository.dataSource;
    
    // Если текущий источник уже нужного типа - возвращаем его
    if (currentDatasource != null) {
      if (dataSource == DataSource.sqfLite && 
          currentDatasource is SqfliteDatasourceImpl) {
        return currentDatasource;
      }
      if (dataSource == DataSource.drift && 
          currentDatasource is DriftDatasourceImpl) {
        return currentDatasource;
      }
      
      // Закрываем старую БД
      currentDatasource.dispose();
    }
    
    // Создаем новый источник
    return createDbDatasource(settingsRepository: settingsRepository);
  }
}