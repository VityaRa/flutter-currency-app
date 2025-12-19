import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/model/news_model.dart';

abstract interface class DbDatasource {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<List<NewsModel>> getNewsList();

  Future<void> saveCurrencyList(List<CurrencyModel> value);

  Future<void> saveNewsList(List<NewsModel> value);

  Future<void> clearCurrencyList();

  Future<void> clearNewsList();
  
  Future<void> clearAll();

  Future<void> saveLastCurrencyUpdate(DateTime dateTime);
  Future<DateTime?> getLastCurrencyUpdate();
  Future<void> saveLastNewsUpdate(DateTime dateTime);
  Future<DateTime?> getLastNewsUpdate();
}