import 'package:lr4/data/datasource_impl/preference_datasource_impl/model/selected_datasource_dao.dart';
import 'package:lr4/domain/model/data_source.dart';

extension DataSourceDaoMapper on DataSourceDao {
  DataSource get model => switch (this) {
    DataSourceDao.cacheFirst => DataSource.cacheFirst,
    DataSourceDao.networkFirst => DataSource.networkFirst,
    DataSourceDao.networkOnly => DataSource.networkOnly,
  };
}