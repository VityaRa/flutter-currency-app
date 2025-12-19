import 'package:drift/drift.dart';

class CurrencyDriftTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get symbol => text()();
  RealColumn get value => real()();
  IntColumn get nominal => integer()();
  RealColumn get previousValue => real()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class NewsDriftTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get link => text()();
  TextColumn get date => text()();
}

class MetadataDriftTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  IntColumn get lastUpdated => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [{type}];
}