import 'package:lr4/domain/model/currency_model.dart';

extension CurrencyModelDriftExt on CurrencyModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'value': value,
      'nominal': nominal,
      'previousValue': previousValue,
    };
  }

  static CurrencyModel fromMap(Map<String, dynamic> row) {
    return CurrencyModel(
      id: row['id'] as String,
      name: row['name'] as String,
      symbol: row['symbol'] as String,
      value: row['value'] as double,
      nominal: row['nominal'] as int? ?? 1,
      previousValue: row['previousValue'] as double? ?? 0.0,
    );
  }
}
