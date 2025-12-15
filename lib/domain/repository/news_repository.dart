import 'package:lr4/domain/model/news_model.dart';

abstract interface class NewsRepository {
  Future<List<NewsModel>> getNewsList();

  Future<void> saveNewsList(List<NewsModel> value);
}