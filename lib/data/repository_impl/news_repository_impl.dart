import 'package:lr4/domain/datasource/rest_datasource.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:lr4/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._rest);
  final RestDatasource _rest;

  @override
  Future<List<NewsModel>> getNewsList() => _rest.getNewsList();
}