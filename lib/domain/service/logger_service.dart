// lib/core/logger/logger_service.dart

import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

class LoggerService {
  static bool _isInitialized = false;
  
  static Logger getAppLogger() => Logger('App');
  static Logger getNetworkLogger() => Logger('Network');
  static Logger getDatabaseLogger() => Logger('Database');
  static Logger getCubitLogger(String cubitName) => Logger('Cubit.$cubitName');
  static Logger getRepositoryLogger(String repoName) => Logger('Repository.$repoName');
  static Logger getDatasourceLogger(String dsName) => Logger('Datasource.$dsName');
  static Logger getUILogger(String pageName) => Logger('UI.$pageName');
  static Logger getServiceLogger(String serviceName) => Logger('Service.$serviceName');
  
  static void initialize({Level level = Level.ALL}) {
    if (_isInitialized) {
      return;
    }
    
    print('🎯 Настройка логгера с уровнем: $level');
    
    Logger.root.level = level;

    Logger.root.onRecord.listen((LogRecord record) {
      _printLog(record);
    });
    
    _isInitialized = true;
  
  }
  
  static void _printLog(LogRecord record) {
    final time = record.time.toLocal();
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:'
                    '${time.minute.toString().padLeft(2, '0')}:'
                    '${time.second.toString().padLeft(2, '0')}.'
                    '${time.millisecond.toString().padLeft(3, '0')}';
    
    final levelStr = _getLevelString(record.level);
    final loggerName = record.loggerName;
    
    // Формируем основное сообщение
    final message = '$timeStr $levelStr [$loggerName] ${record.message}';
    
    // Используем debugPrint для Flutter
    debugPrint(message);
    
    // Также выводим через print для надежности
    print(message);
    
    // Если есть ошибка
    if (record.error != null) {
      final errorMsg = '      ❌ ОШИБКА: ${record.error}';
      debugPrint(errorMsg);
      print(errorMsg);
    }
    
    // Если есть stack trace (только для SEVERE)
    if (record.stackTrace != null && record.level == Level.SEVERE) {
      final stackMsg = '      📋 StackTrace: ${record.stackTrace}';
      debugPrint(stackMsg);
      print(stackMsg);
    }
  }
  
  static String _getLevelString(Level level) {
    switch (level) {
      case Level.SEVERE:
        return '🔥 SEVERE';
      case Level.WARNING:
        return '⚠️ WARNING';
      case Level.INFO:
        return 'ℹ️ INFO';
      case Level.FINE:
        return '🔍 FINE';
      case Level.FINER:
        return '🔬 FINER';
      case Level.FINEST:
        return '🔎 FINEST';
      case Level.CONFIG:
        return '⚙️ CONFIG';
      case Level.SHOUT:
        return '📢 SHOUT';
      default:
        return '[${level.name}]';
    }
  }
}