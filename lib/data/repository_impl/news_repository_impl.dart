import 'package:lr4/domain/datasource/db_datasource.dart';
import 'package:lr4/domain/datasource/rest_datasource.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:lr4/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._restDatasource, this._dbDatasource);
  final RestDatasource _restDatasource;
  final DbDatasource _dbDatasource;

  @override
  Future<List<NewsModel>> getNewsList() => _restDatasource.getNewsList();

  @override
  Future<void> saveNewsList(List<NewsModel> value) => _dbDatasource.saveNewsList(value);

  @override
  Future<List<NewsModel>> getCachedNewsList() => _dbDatasource.getNewsList();
}
