import 'package:lr4/domain/datasource/rest_datasource.dart';
import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/model/currency_history_model.dart'; 
import 'package:lr4/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(this._rest);
  final RestDatasource _rest;

  @override
  Future<List<CurrencyModel>> getCurrencyList() => _rest.getCurrencyList();

  @override
  Future<List<CurrencyHistoryModel>> getCurrencyHistory(String currencyId, DateTime from, DateTime to) {
    return _rest.getCurrencyHistory(currencyId, from, to);
  }
}