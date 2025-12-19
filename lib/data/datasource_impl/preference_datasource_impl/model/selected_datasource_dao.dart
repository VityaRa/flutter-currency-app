enum DataSourceDao {
 network, sqfLite, drift;

  static DataSourceDao fromString(String? name) =>
      DataSourceDao.values.firstWhere((e) => e.name == name,
          orElse: () => DataSourceDao.network);
}
