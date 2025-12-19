
import 'package:lr4/domain/datasource/db_datasource.dart';
import 'package:lr4/domain/datasource/rest_datasource.dart';
import 'package:lr4/domain/model/currency_history_model.dart';
import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(this._restDatasource, this._dbDatasource);

  final RestDatasource _restDatasource;
  final DbDatasource _dbDatasource;

  @override
  Future<List<CurrencyModel>> getCurrencyList() => _restDatasource.getCurrencyList();

  @override
  Future<List<CurrencyHistoryModel>> getCurrencyHistory(String currencyId, DateTime from, DateTime to) {
    return _restDatasource.getCurrencyHistory(currencyId, from, to);
  }
  
  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) => _dbDatasource.saveCurrencyList(value);

  @override
  Future<List<CurrencyModel>> getCurrencyListFromCache() => _dbDatasource.getCurrencyList();

  @override
  Future<void> clearCache() => _dbDatasource.clearCurrencyList();

  @override
  Future<DateTime?> getLastUpdate() => _dbDatasource.getLastCurrencyUpdate();
}