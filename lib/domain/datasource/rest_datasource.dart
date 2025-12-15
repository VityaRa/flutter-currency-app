import 'package:lr4/domain/model/currency_model.dart'; 
import 'package:lr4/domain/model/news_model.dart';  
import 'package:lr4/domain/model/currency_history_model.dart';  

abstract interface class RestDatasource {
  Future<List<CurrencyModel>> getCurrencyList();
  Future<List<NewsModel>> getNewsList();
  Future<List<CurrencyHistoryModel>> getCurrencyHistory(String id, DateTime date1, DateTime date2);
}