import 'package:lr4/data/datasource_impl//model/currency_dto.dart';
import 'package:lr4/domain/model/currency_model.dart';

extension CurrencyDtoMapper on CurrencyDto {
  CurrencyModel get model => CurrencyModel(
        id: id,
        nominal: nominal,
        name: name,
        symbol: symbol,
        value: value,
        previousValue: previousValue,
      );
}