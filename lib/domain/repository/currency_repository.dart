import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/model/currency_history_model.dart';

abstract interface class CurrencyRepository {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<List<CurrencyHistoryModel>> getCurrencyHistory(String currencyId, DateTime from, DateTime to);

  Future<void> saveCurrencyList(List<CurrencyModel> value);
}