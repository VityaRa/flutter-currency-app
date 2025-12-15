import 'package:intl/intl.dart';
import 'package:lr4/domain/model/currency_history_model.dart';
import 'package:xml/xml.dart';

extension XmlToHistoryMapper on XmlElement {
  CurrencyHistoryModel get asHistoryModel {
    
    // 1. Парсим дату из атрибута Date
    final dateStr = getAttribute('Date') ?? '';
    DateTime date;
    try {
      date = DateFormat('dd.MM.yyyy').parse(dateStr);
    } catch (e) {
      date = DateTime.now(); 
    }

    // 2. Парсим значение из тэга <Value>
    final valueElement = findElements('Value').firstOrNull?.innerText; 
    
    // Если элемента нет или он пустой, ставим 0.0
    final valueDouble = valueElement != null 
        ? (double.tryParse(valueElement.replaceAll(',', '.')) ?? 0.0) 
        : 0.0;

    return CurrencyHistoryModel(
      date: date,
      value: valueDouble,
    );
  }
}