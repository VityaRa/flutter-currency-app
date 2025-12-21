// lib/utils/formatters.dart
import 'package:intl/intl.dart';

class IntlFormatters {
  static String formatFullDate(String locale, DateTime date) {
    switch (locale) {
      case 'ru':
        // Русская локаль: вт 16:59 29.07.25
        return DateFormat("E HH:mm dd.MM.yy", 'ru_RU').format(date);
      case 'es':
        // Испанская локаль: mar 16:59 29/07/25
        return DateFormat("E HH:mm dd/MM/yy", 'es_ES').format(date);
      default: // en
        // Американская локаль: Tue 04:59 PM 07/29/25
        return DateFormat("E hh:mm a MM/dd/yy", 'en_US').format(date);
    }
  }

  static String formatShortDate(String locale, DateTime date) {
    switch (locale) {
      case 'ru':
        // Русский формат: 29.07.25
        return DateFormat('dd.MM.yy', 'ru_RU').format(date);
      case 'es':
        // Испанский формат: 29/07/25
        return DateFormat('dd/MM/yy', 'es_ES').format(date);
      default: // en и другие
        // Американский формат: 07/29/25
        return DateFormat('MM/dd/yy', 'en_US').format(date);
    }
  }

  static String _getCurrencyCode(String locale) {
    switch (locale) {
      case 'ru':
        return "RUB";
      case 'es':
        return "EUR";
      case 'en':
        return "USD";
      default:
        return "RUB";
    }
  }

  static String formatCurrency(String locale, double amount) {
    final currencyCode = _getCurrencyCode(locale);
    final currencySymbol = _getCurrencySymbol(currencyCode, locale);

    switch (locale) {
      case 'ru':
        final formatter = NumberFormat.currency(
          locale: 'ru_RU',
          symbol: currencySymbol,
          decimalDigits: 2,
        );
        return formatter.format(amount);
      case 'es':
        final formatter = NumberFormat.currency(
          locale: 'es_ES',
          symbol: currencySymbol,
          decimalDigits: 2,
        );
        return formatter.format(amount);
      default: // en
        final formatter = NumberFormat.currency(
          locale: 'en_US',
          symbol: currencySymbol,
          decimalDigits: 2,
        );
        return formatter.format(amount);
    }
  }

  // КОНВЕРТАЦИЯ ВАЛЮТ: Рубли в другую валюту
  static String convertRubToCurrency(String locale, double rubAmount) {
    const usdRate = 0.011; // 1 RUB = 0.011 USD
    const eurRate = 0.010; // 1 RUB = 0.010 EUR

    switch (locale) {
      case 'ru':
        final rub = formatCurrency(locale, rubAmount);
        return rub;
      case 'es':
        final eur = formatCurrency(locale, rubAmount * eurRate);
        return eur;
      default: // en
        final usd = formatCurrency(locale, rubAmount * usdRate);
        return usd;
    }
  }

  static String _getCurrencySymbol(String currencyCode, String locale) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'RUB':
        return locale == 'ru' ? '₽' : 'RUB';
      default:
        return currencyCode;
    }
  }

  static String diffPercentage(String locale, double oldValue, double newValue,
      {bool showSign = true, int decimalDigits = 2}) {
    if (oldValue == 0) {
      return "";
    }
    final percentage = ((newValue - oldValue) / oldValue * 100);
    final formatter = NumberFormat.decimalPercentPattern(
      locale: locale,
      decimalDigits: 2,
    );

    final formattedValue = formatter.format(percentage.abs() / 100);
    if (percentage > 0) {
      return showSign ? '+$formattedValue' : formattedValue;
    } else if (percentage < 0) {
      return '-$formattedValue';
    } else {
      return showSign ? '±0%' : '0%';
    }
  }
}
