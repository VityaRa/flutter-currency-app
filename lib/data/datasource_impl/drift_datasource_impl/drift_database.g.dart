// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $CurrencyDriftTableTable extends CurrencyDriftTable
    with TableInfo<$CurrencyDriftTableTable, CurrencyDriftTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyDriftTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _nominalMeta =
      const VerificationMeta('nominal');
  @override
  late final GeneratedColumn<int> nominal = GeneratedColumn<int>(
      'nominal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _previousValueMeta =
      const VerificationMeta('previousValue');
  @override
  late final GeneratedColumn<double> previousValue = GeneratedColumn<double>(
      'previous_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, symbol, value, nominal, previousValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_drift_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CurrencyDriftTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('nominal')) {
      context.handle(_nominalMeta,
          nominal.isAcceptableOrUnknown(data['nominal']!, _nominalMeta));
    } else if (isInserting) {
      context.missing(_nominalMeta);
    }
    if (data.containsKey('previous_value')) {
      context.handle(
          _previousValueMeta,
          previousValue.isAcceptableOrUnknown(
              data['previous_value']!, _previousValueMeta));
    } else if (isInserting) {
      context.missing(_previousValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrencyDriftTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyDriftTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      nominal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nominal'])!,
      previousValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}previous_value'])!,
    );
  }

  @override
  $CurrencyDriftTableTable createAlias(String alias) {
    return $CurrencyDriftTableTable(attachedDatabase, alias);
  }
}

class CurrencyDriftTableData extends DataClass
    implements Insertable<CurrencyDriftTableData> {
  final String id;
  final String name;
  final String symbol;
  final double value;
  final int nominal;
  final double previousValue;
  const CurrencyDriftTableData(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.value,
      required this.nominal,
      required this.previousValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['symbol'] = Variable<String>(symbol);
    map['value'] = Variable<double>(value);
    map['nominal'] = Variable<int>(nominal);
    map['previous_value'] = Variable<double>(previousValue);
    return map;
  }

  CurrencyDriftTableCompanion toCompanion(bool nullToAbsent) {
    return CurrencyDriftTableCompanion(
      id: Value(id),
      name: Value(name),
      symbol: Value(symbol),
      value: Value(value),
      nominal: Value(nominal),
      previousValue: Value(previousValue),
    );
  }

  factory CurrencyDriftTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyDriftTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String>(json['symbol']),
      value: serializer.fromJson<double>(json['value']),
      nominal: serializer.fromJson<int>(json['nominal']),
      previousValue: serializer.fromJson<double>(json['previousValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String>(symbol),
      'value': serializer.toJson<double>(value),
      'nominal': serializer.toJson<int>(nominal),
      'previousValue': serializer.toJson<double>(previousValue),
    };
  }

  CurrencyDriftTableData copyWith(
          {String? id,
          String? name,
          String? symbol,
          double? value,
          int? nominal,
          double? previousValue}) =>
      CurrencyDriftTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        value: value ?? this.value,
        nominal: nominal ?? this.nominal,
        previousValue: previousValue ?? this.previousValue,
      );
  CurrencyDriftTableData copyWithCompanion(CurrencyDriftTableCompanion data) {
    return CurrencyDriftTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      value: data.value.present ? data.value.value : this.value,
      nominal: data.nominal.present ? data.nominal.value : this.nominal,
      previousValue: data.previousValue.present
          ? data.previousValue.value
          : this.previousValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyDriftTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('value: $value, ')
          ..write('nominal: $nominal, ')
          ..write('previousValue: $previousValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, symbol, value, nominal, previousValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyDriftTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.value == this.value &&
          other.nominal == this.nominal &&
          other.previousValue == this.previousValue);
}

class CurrencyDriftTableCompanion
    extends UpdateCompanion<CurrencyDriftTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> symbol;
  final Value<double> value;
  final Value<int> nominal;
  final Value<double> previousValue;
  final Value<int> rowid;
  const CurrencyDriftTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.value = const Value.absent(),
    this.nominal = const Value.absent(),
    this.previousValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrencyDriftTableCompanion.insert({
    required String id,
    required String name,
    required String symbol,
    required double value,
    required int nominal,
    required double previousValue,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        symbol = Value(symbol),
        value = Value(value),
        nominal = Value(nominal),
        previousValue = Value(previousValue);
  static Insertable<CurrencyDriftTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<double>? value,
    Expression<int>? nominal,
    Expression<double>? previousValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (value != null) 'value': value,
      if (nominal != null) 'nominal': nominal,
      if (previousValue != null) 'previous_value': previousValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrencyDriftTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? symbol,
      Value<double>? value,
      Value<int>? nominal,
      Value<double>? previousValue,
      Value<int>? rowid}) {
    return CurrencyDriftTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      value: value ?? this.value,
      nominal: nominal ?? this.nominal,
      previousValue: previousValue ?? this.previousValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (nominal.present) {
      map['nominal'] = Variable<int>(nominal.value);
    }
    if (previousValue.present) {
      map['previous_value'] = Variable<double>(previousValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyDriftTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('value: $value, ')
          ..write('nominal: $nominal, ')
          ..write('previousValue: $previousValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NewsDriftTableTable extends NewsDriftTable
    with TableInfo<$NewsDriftTableTable, NewsDriftTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewsDriftTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
      'link', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, link, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'news_drift_table';
  @override
  VerificationContext validateIntegrity(Insertable<NewsDriftTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
          _linkMeta, link.isAcceptableOrUnknown(data['link']!, _linkMeta));
    } else if (isInserting) {
      context.missing(_linkMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NewsDriftTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NewsDriftTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      link: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}link'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $NewsDriftTableTable createAlias(String alias) {
    return $NewsDriftTableTable(attachedDatabase, alias);
  }
}

class NewsDriftTableData extends DataClass
    implements Insertable<NewsDriftTableData> {
  final int id;
  final String title;
  final String link;
  final String date;
  const NewsDriftTableData(
      {required this.id,
      required this.title,
      required this.link,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['link'] = Variable<String>(link);
    map['date'] = Variable<String>(date);
    return map;
  }

  NewsDriftTableCompanion toCompanion(bool nullToAbsent) {
    return NewsDriftTableCompanion(
      id: Value(id),
      title: Value(title),
      link: Value(link),
      date: Value(date),
    );
  }

  factory NewsDriftTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NewsDriftTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      link: serializer.fromJson<String>(json['link']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'link': serializer.toJson<String>(link),
      'date': serializer.toJson<String>(date),
    };
  }

  NewsDriftTableData copyWith(
          {int? id, String? title, String? link, String? date}) =>
      NewsDriftTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        link: link ?? this.link,
        date: date ?? this.date,
      );
  NewsDriftTableData copyWithCompanion(NewsDriftTableCompanion data) {
    return NewsDriftTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      link: data.link.present ? data.link.value : this.link,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NewsDriftTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, link, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NewsDriftTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.link == this.link &&
          other.date == this.date);
}

class NewsDriftTableCompanion extends UpdateCompanion<NewsDriftTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> link;
  final Value<String> date;
  const NewsDriftTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.link = const Value.absent(),
    this.date = const Value.absent(),
  });
  NewsDriftTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String link,
    required String date,
  })  : title = Value(title),
        link = Value(link),
        date = Value(date);
  static Insertable<NewsDriftTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? link,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (link != null) 'link': link,
      if (date != null) 'date': date,
    });
  }

  NewsDriftTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? link,
      Value<String>? date}) {
    return NewsDriftTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewsDriftTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $MetadataDriftTableTable extends MetadataDriftTable
    with TableInfo<$MetadataDriftTableTable, MetadataDriftTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetadataDriftTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metadata_drift_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<MetadataDriftTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {type},
      ];
  @override
  MetadataDriftTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetadataDriftTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $MetadataDriftTableTable createAlias(String alias) {
    return $MetadataDriftTableTable(attachedDatabase, alias);
  }
}

class MetadataDriftTableData extends DataClass
    implements Insertable<MetadataDriftTableData> {
  final int id;
  final String type;
  final int lastUpdated;
  const MetadataDriftTableData(
      {required this.id, required this.type, required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['last_updated'] = Variable<int>(lastUpdated);
    return map;
  }

  MetadataDriftTableCompanion toCompanion(bool nullToAbsent) {
    return MetadataDriftTableCompanion(
      id: Value(id),
      type: Value(type),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory MetadataDriftTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetadataDriftTableData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      lastUpdated: serializer.fromJson<int>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'lastUpdated': serializer.toJson<int>(lastUpdated),
    };
  }

  MetadataDriftTableData copyWith({int? id, String? type, int? lastUpdated}) =>
      MetadataDriftTableData(
        id: id ?? this.id,
        type: type ?? this.type,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  MetadataDriftTableData copyWithCompanion(MetadataDriftTableCompanion data) {
    return MetadataDriftTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetadataDriftTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetadataDriftTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.lastUpdated == this.lastUpdated);
}

class MetadataDriftTableCompanion
    extends UpdateCompanion<MetadataDriftTableData> {
  final Value<int> id;
  final Value<String> type;
  final Value<int> lastUpdated;
  const MetadataDriftTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  MetadataDriftTableCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required int lastUpdated,
  })  : type = Value(type),
        lastUpdated = Value(lastUpdated);
  static Insertable<MetadataDriftTableData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  MetadataDriftTableCompanion copyWith(
      {Value<int>? id, Value<String>? type, Value<int>? lastUpdated}) {
    return MetadataDriftTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<int>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetadataDriftTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrencyDriftTableTable currencyDriftTable =
      $CurrencyDriftTableTable(this);
  late final $NewsDriftTableTable newsDriftTable = $NewsDriftTableTable(this);
  late final $MetadataDriftTableTable metadataDriftTable =
      $MetadataDriftTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [currencyDriftTable, newsDriftTable, metadataDriftTable];
}

typedef $$CurrencyDriftTableTableCreateCompanionBuilder
    = CurrencyDriftTableCompanion Function({
  required String id,
  required String name,
  required String symbol,
  required double value,
  required int nominal,
  required double previousValue,
  Value<int> rowid,
});
typedef $$CurrencyDriftTableTableUpdateCompanionBuilder
    = CurrencyDriftTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> symbol,
  Value<double> value,
  Value<int> nominal,
  Value<double> previousValue,
  Value<int> rowid,
});

class $$CurrencyDriftTableTableFilterComposer
    extends Composer<_$AppDatabase, $CurrencyDriftTableTable> {
  $$CurrencyDriftTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nominal => $composableBuilder(
      column: $table.nominal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get previousValue => $composableBuilder(
      column: $table.previousValue, builder: (column) => ColumnFilters(column));
}

class $$CurrencyDriftTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrencyDriftTableTable> {
  $$CurrencyDriftTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nominal => $composableBuilder(
      column: $table.nominal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get previousValue => $composableBuilder(
      column: $table.previousValue,
      builder: (column) => ColumnOrderings(column));
}

class $$CurrencyDriftTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrencyDriftTableTable> {
  $$CurrencyDriftTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get nominal =>
      $composableBuilder(column: $table.nominal, builder: (column) => column);

  GeneratedColumn<double> get previousValue => $composableBuilder(
      column: $table.previousValue, builder: (column) => column);
}

class $$CurrencyDriftTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrencyDriftTableTable,
    CurrencyDriftTableData,
    $$CurrencyDriftTableTableFilterComposer,
    $$CurrencyDriftTableTableOrderingComposer,
    $$CurrencyDriftTableTableAnnotationComposer,
    $$CurrencyDriftTableTableCreateCompanionBuilder,
    $$CurrencyDriftTableTableUpdateCompanionBuilder,
    (
      CurrencyDriftTableData,
      BaseReferences<_$AppDatabase, $CurrencyDriftTableTable,
          CurrencyDriftTableData>
    ),
    CurrencyDriftTableData,
    PrefetchHooks Function()> {
  $$CurrencyDriftTableTableTableManager(
      _$AppDatabase db, $CurrencyDriftTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrencyDriftTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrencyDriftTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrencyDriftTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<int> nominal = const Value.absent(),
            Value<double> previousValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyDriftTableCompanion(
            id: id,
            name: name,
            symbol: symbol,
            value: value,
            nominal: nominal,
            previousValue: previousValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String symbol,
            required double value,
            required int nominal,
            required double previousValue,
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrencyDriftTableCompanion.insert(
            id: id,
            name: name,
            symbol: symbol,
            value: value,
            nominal: nominal,
            previousValue: previousValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrencyDriftTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrencyDriftTableTable,
    CurrencyDriftTableData,
    $$CurrencyDriftTableTableFilterComposer,
    $$CurrencyDriftTableTableOrderingComposer,
    $$CurrencyDriftTableTableAnnotationComposer,
    $$CurrencyDriftTableTableCreateCompanionBuilder,
    $$CurrencyDriftTableTableUpdateCompanionBuilder,
    (
      CurrencyDriftTableData,
      BaseReferences<_$AppDatabase, $CurrencyDriftTableTable,
          CurrencyDriftTableData>
    ),
    CurrencyDriftTableData,
    PrefetchHooks Function()>;
typedef $$NewsDriftTableTableCreateCompanionBuilder = NewsDriftTableCompanion
    Function({
  Value<int> id,
  required String title,
  required String link,
  required String date,
});
typedef $$NewsDriftTableTableUpdateCompanionBuilder = NewsDriftTableCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> link,
  Value<String> date,
});

class $$NewsDriftTableTableFilterComposer
    extends Composer<_$AppDatabase, $NewsDriftTableTable> {
  $$NewsDriftTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get link => $composableBuilder(
      column: $table.link, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$NewsDriftTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NewsDriftTableTable> {
  $$NewsDriftTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get link => $composableBuilder(
      column: $table.link, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$NewsDriftTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NewsDriftTableTable> {
  $$NewsDriftTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$NewsDriftTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NewsDriftTableTable,
    NewsDriftTableData,
    $$NewsDriftTableTableFilterComposer,
    $$NewsDriftTableTableOrderingComposer,
    $$NewsDriftTableTableAnnotationComposer,
    $$NewsDriftTableTableCreateCompanionBuilder,
    $$NewsDriftTableTableUpdateCompanionBuilder,
    (
      NewsDriftTableData,
      BaseReferences<_$AppDatabase, $NewsDriftTableTable, NewsDriftTableData>
    ),
    NewsDriftTableData,
    PrefetchHooks Function()> {
  $$NewsDriftTableTableTableManager(
      _$AppDatabase db, $NewsDriftTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NewsDriftTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NewsDriftTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NewsDriftTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> link = const Value.absent(),
            Value<String> date = const Value.absent(),
          }) =>
              NewsDriftTableCompanion(
            id: id,
            title: title,
            link: link,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String link,
            required String date,
          }) =>
              NewsDriftTableCompanion.insert(
            id: id,
            title: title,
            link: link,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NewsDriftTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NewsDriftTableTable,
    NewsDriftTableData,
    $$NewsDriftTableTableFilterComposer,
    $$NewsDriftTableTableOrderingComposer,
    $$NewsDriftTableTableAnnotationComposer,
    $$NewsDriftTableTableCreateCompanionBuilder,
    $$NewsDriftTableTableUpdateCompanionBuilder,
    (
      NewsDriftTableData,
      BaseReferences<_$AppDatabase, $NewsDriftTableTable, NewsDriftTableData>
    ),
    NewsDriftTableData,
    PrefetchHooks Function()>;
typedef $$MetadataDriftTableTableCreateCompanionBuilder
    = MetadataDriftTableCompanion Function({
  Value<int> id,
  required String type,
  required int lastUpdated,
});
typedef $$MetadataDriftTableTableUpdateCompanionBuilder
    = MetadataDriftTableCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<int> lastUpdated,
});

class $$MetadataDriftTableTableFilterComposer
    extends Composer<_$AppDatabase, $MetadataDriftTableTable> {
  $$MetadataDriftTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));
}

class $$MetadataDriftTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MetadataDriftTableTable> {
  $$MetadataDriftTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$MetadataDriftTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetadataDriftTableTable> {
  $$MetadataDriftTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);
}

class $$MetadataDriftTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MetadataDriftTableTable,
    MetadataDriftTableData,
    $$MetadataDriftTableTableFilterComposer,
    $$MetadataDriftTableTableOrderingComposer,
    $$MetadataDriftTableTableAnnotationComposer,
    $$MetadataDriftTableTableCreateCompanionBuilder,
    $$MetadataDriftTableTableUpdateCompanionBuilder,
    (
      MetadataDriftTableData,
      BaseReferences<_$AppDatabase, $MetadataDriftTableTable,
          MetadataDriftTableData>
    ),
    MetadataDriftTableData,
    PrefetchHooks Function()> {
  $$MetadataDriftTableTableTableManager(
      _$AppDatabase db, $MetadataDriftTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetadataDriftTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetadataDriftTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetadataDriftTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> lastUpdated = const Value.absent(),
          }) =>
              MetadataDriftTableCompanion(
            id: id,
            type: type,
            lastUpdated: lastUpdated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required int lastUpdated,
          }) =>
              MetadataDriftTableCompanion.insert(
            id: id,
            type: type,
            lastUpdated: lastUpdated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MetadataDriftTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MetadataDriftTableTable,
    MetadataDriftTableData,
    $$MetadataDriftTableTableFilterComposer,
    $$MetadataDriftTableTableOrderingComposer,
    $$MetadataDriftTableTableAnnotationComposer,
    $$MetadataDriftTableTableCreateCompanionBuilder,
    $$MetadataDriftTableTableUpdateCompanionBuilder,
    (
      MetadataDriftTableData,
      BaseReferences<_$AppDatabase, $MetadataDriftTableTable,
          MetadataDriftTableData>
    ),
    MetadataDriftTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrencyDriftTableTableTableManager get currencyDriftTable =>
      $$CurrencyDriftTableTableTableManager(_db, _db.currencyDriftTable);
  $$NewsDriftTableTableTableManager get newsDriftTable =>
      $$NewsDriftTableTableTableManager(_db, _db.newsDriftTable);
  $$MetadataDriftTableTableTableManager get metadataDriftTable =>
      $$MetadataDriftTableTableTableManager(_db, _db.metadataDriftTable);
}
