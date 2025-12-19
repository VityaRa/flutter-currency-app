import 'package:lr4/data/datasource_impl/preference_datasource_impl/model/selected_datasource_dao.dart';
import 'package:lr4/domain/model/data_source.dart';

extension DataSourceDaoMapper on DataSourceDao {
  DataSource get model => switch (this) {
    DataSourceDao.network => DataSource.network,
    DataSourceDao.drift => DataSource.drift,
    DataSourceDao.sqfLite => DataSource.sqfLite,
  };
}