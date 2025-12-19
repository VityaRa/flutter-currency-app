abstract class CurrencyTable {
  static const String name = 'currencies';
  static const String creationRequest = '''
          CREATE TABLE $name (
            id TEXT PRIMARY KEY,
            name TEXT,
            symbol TEXT,
            value REAL,
            nominal INTEGER,
            previousValue REAL
          )
        ''';
}

abstract class NewsTable {
  static const String name = 'news';
  static const String creationRequest = '''
          CREATE TABLE $name (
            id INTEGER PRIMARY KEY autoincrement,
            title TEXT,
            link TEXT,
            date TEXT
          )
        ''';
}

abstract class MetadataTable {
  static const String name = 'metadata';
  static const String columnId = 'id';
  static const String columnType = 'type';
  static const String columnLastUpdated = 'last_updated';
  static const String creationRequest = '''
          CREATE TABLE $name (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT UNIQUE NOT NULL,
            last_updated INTEGER NOT NULL
          )
        ''';
}
