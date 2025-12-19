import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/database_helper.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/mapper/currency_model_mapper.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/mapper/news_model_mapper.dart';
import 'package:lr4/data/datasource_impl/sqflite_datasorce_impl/table.dart';
import 'package:lr4/domain/datasource/db_datasource.dart';
import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasourceImpl implements DbDatasource {
  final DatabaseHelper _helper = DatabaseHelper();

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    final Database db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(CurrencyTable.name);

    return maps.map((e) => CurrencyModelDbMapper.fromMap(e)).toList(growable: false);
  }

  @override
  Future<List<NewsModel>> getNewsList() async {
    final Database db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(NewsTable.name);

    return maps.map((e) => NewsModelDbMapper.fromMap(e)).toList(growable: false);
  }

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) async {
    final Database db = await _helper.database;
    final Batch batch = db.batch();

    for (final CurrencyModel item in value) {
      batch.insert(
        CurrencyTable.name,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    await saveLastCurrencyUpdate(DateTime.now());
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) async {
    final Database db = await _helper.database;
    final Batch batch = db.batch();

    for (final NewsModel item in value) {
      batch.insert(
        NewsTable.name,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    await saveLastNewsUpdate(DateTime.now());
  }

  @override
  Future<void> clearNewsList() async {
    final Database db = await _helper.database;
    final batch = db.batch();
    
    batch.delete(NewsTable.name);
    batch.delete(
      MetadataTable.name,
      where: '${MetadataTable.columnType} = ?',
      whereArgs: ['news'],
    );
    
    await batch.commit(noResult: true);
  }

  @override
  Future<void> clearCurrencyList() async {
    final Database db = await _helper.database;
    final batch = db.batch();
    
    batch.delete(CurrencyTable.name);
    batch.delete(
      MetadataTable.name,
      where: '${MetadataTable.columnType} = ?',
      whereArgs: ['currency'],
    );
    
    await batch.commit(noResult: true);
  }

  @override
  Future<void> clearAll() async {
    final Database db = await _helper.database;
    final Batch batch = db.batch();
    
    batch.delete(NewsTable.name);
    batch.delete(CurrencyTable.name);
    
    await batch.commit(noResult: true);
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
    final Database db = await _helper.database;
    
    await db.insert(
      MetadataTable.name,
      {
        MetadataTable.columnType: type,
        MetadataTable.columnLastUpdated: dateTime.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DateTime?> _getLastUpdate(String type) async {
    final Database db = await _helper.database;
    
    final List<Map<String, dynamic>> result = await db.query(
      MetadataTable.name,
      where: '${MetadataTable.columnType} = ?',
      whereArgs: [type],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      final timestamp = result.first[MetadataTable.columnLastUpdated] as int;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    
    return null;
  }

}
