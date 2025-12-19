enum DataSourceDao {
  networkFirst,
  cacheFirst,
  networkOnly;

  static DataSourceDao fromString(String? name) =>
      DataSourceDao.values.firstWhere((e) => e.name == name,
          orElse: () => DataSourceDao.cacheFirst);
}
