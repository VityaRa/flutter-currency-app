import 'package:intl/intl.dart';

class ReleaseCountdown {
  static final DateTime releaseDate = DateTime(2026, 1, 1);
  
  /// Просто возвращает "N дней до релиза"
  static String getReleaseDate(String locale) {
    final dateFormatter = DateFormat.yMMMd(locale);
    return dateFormatter.format(releaseDate);
  }
}