// lib/data/datasource_impl/drift_datasource_impl/drift_datasource_impl.dart

import 'package:drift/drift.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/mapper/currency_model_mapper.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/mapper/news_model_mapper.dart';
import 'package:lr4/domain/datasource/db_datasource.dart';
import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/model/news_model.dart';

import 'drift_database.dart';

class DriftDatasourceImpl implements DbDatasource {
  late AppDatabase _database;

  DriftDatasourceImpl() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = AppDatabase();
  }

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    try {
      // Используем сырые SQL запросы для совместимости
      final rows =
          await _database.customSelect('SELECT * FROM currencies').get();

      final maps = rows.map((row) => row.data).toList();
      return maps
          .map((e) => CurrencyModelDbMapper.fromMap(e))
          .toList(growable: false);
    } catch (e) {
      print('Ошибка при получении списка валют: $e');
      return [];
    }
  }

  @override
  Future<List<NewsModel>> getNewsList() async {
    try {
      final rows = await _database.customSelect('SELECT * FROM news').get();

      final maps = rows.map((row) => row.data).toList();
      return maps
          .map((e) => NewsModelDbMapper.fromMap(e))
          .toList(growable: false);
    } catch (e) {
      print('Ошибка при получении списка новостей: $e');
      return [];
    }
  }

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) async {
    await _database.transaction(() async {
      // Очищаем старую таблицу
      await _database.customStatement('DELETE FROM currencies');

      // Вставляем новые данные с помощью customInsert
      for (final item in value) {
        final map = item.toMap();
        await _database.customInsert(
          '''
          INSERT OR REPLACE INTO currencies (id, name, symbol, value, nominal, previousValue) 
          VALUES (?, ?, ?, ?, ?, ?)
          ''',
          variables: [
            Variable(map['id']),
            Variable(map['name']),
            Variable(map['symbol']),
            Variable(map['value']),
            Variable(map['nominal'] ?? 1),
            Variable(map['previousValue'] ?? 0.0),
          ],
        );
      }

      await saveLastCurrencyUpdate(DateTime.now());
    });
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) async {
    await _database.transaction(() async {
      // Очищаем старую таблицу
      await _database.customStatement('DELETE FROM news');

      // Вставляем новые данные
      for (final item in value) {
        final map = item.toMap();
        await _database.customInsert(
          '''
          INSERT OR REPLACE INTO news (title, link, date) 
          VALUES (?, ?, ?)
          ''',
          variables: [
            Variable(map['title']),
            Variable(map['link']),
            Variable(map['date'] ?? DateTime.now().toIso8601String()),
          ],
        );
      }

      await saveLastNewsUpdate(DateTime.now());
    });
  }

  @override
  Future<void> clearNewsList() async {
    await _database.transaction(() async {
      await _database.customStatement('DELETE FROM news');
      await _database.customStatement(
        'DELETE FROM metadata WHERE type = ?',
        [Variable('news')],
      );
    });
  }

  @override
  Future<void> clearCurrencyList() async {
    await _database.transaction(() async {
      await _database.customStatement('DELETE FROM currencies');
      await _database.customStatement(
        'DELETE FROM metadata WHERE type = ?',
        [Variable('currency')],
      );
    });
  }

  @override
  Future<void> clearAll() async {
    await _database.transaction(() async {
      await _database.customStatement('DELETE FROM news');
      await _database.customStatement('DELETE FROM currencies');
      await _database.customStatement('DELETE FROM metadata');
    });
  }

  @override
  Future<void> saveLastCurrencyUpdate(DateTime dateTime) async {
    await _saveLastUpdate('currency', dateTime);
  }

  @override
  Future<DateTime?> getLastCurrencyUpdate() async {
    return await _getLastUpdate('currency');
  }

  @override
  Future<void> saveLastNewsUpdate(DateTime dateTime) async {
    await _saveLastUpdate('news', dateTime);
  }

  @override
  Future<DateTime?> getLastNewsUpdate() async {
    return await _getLastUpdate('news');
  }

  Future<void> _saveLastUpdate(String type, DateTime dateTime) async {
    try {
      await _database.customInsert(
        '''
        INSERT OR REPLACE INTO metadata (type, last_updated) 
        VALUES (?, ?)
        ''',
        variables: [
          Variable(type),
          Variable(dateTime.millisecondsSinceEpoch),
        ],
      );
    } catch (e) {
      print('Ошибка при сохранении времени обновления для $type: $e');
    }
  }

  Future<DateTime?> _getLastUpdate(String type) async {
    try {
      final rows = await _database.customSelect(
        'SELECT last_updated FROM metadata WHERE type = ? LIMIT 1',
        variables: [Variable(type)],
      ).get();

      if (rows.isNotEmpty) {
        final timestamp = rows.first.read<int>('last_updated');
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }

      return null;
    } catch (e) {
      print('Ошибка при получении времени обновления для $type: $e');
      return null;
    }
  }

  @override
  Future<void> close() async {
    await _database.close();
  }

   @override
  Future<void> dispose() async {
    await _database.close();
  }
}
