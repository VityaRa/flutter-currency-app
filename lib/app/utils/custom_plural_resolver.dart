import 'dart:ui';

class CustomPluralResolver {
  static String russianPlural(String message, int value) {
    // Регулярное выражение для поиска plural шаблонов
    final regex = RegExp(r'\{([^}]+)\}');
    final match = regex.firstMatch(message);
    
    if (match == null) return message;
    
    final pluralContent = match.group(1)!;
    // Извлекаем варианты
    final variants = _parsePluralVariants(pluralContent);
    
    // Определяем форму для русского языка
    final form = _getRussianPluralForm(value);
    
    // Возвращаем соответствующий вариант
    final selectedVariant = variants[form] ?? variants['other'] ?? '';
    
    // Заменяем # на значение
    return selectedVariant.replaceAll('#', value.toString());
  }
  
  static Map<String, String> _parsePluralVariants(String content) {
    final variants = <String, String>{};
    final parts = content.split(',');
    
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.contains('=')) {
        final eqParts = trimmed.split('=');
        final key = eqParts[0].trim();
        final value = eqParts[1].trim();
        variants[key] = value;
      } else if (trimmed.contains('{')) {
        final braceIndex = trimmed.indexOf('{');
        final key = trimmed.substring(0, braceIndex).trim();
        final value = trimmed.substring(braceIndex + 1, trimmed.length - 1).trim();
        variants[key] = value;
      }
    }
    
    return variants;
  }
  
  /// Определяет plural форму для русского языка
  static String _getRussianPluralForm(int value) {
    final int lastDigit = value % 10;
    final int lastTwoDigits = value % 100;
    
    // Исключение для чисел 11-14
    if (lastTwoDigits >= 11 && lastTwoDigits <= 14) {
      return 'many';
    }
    
    switch (lastDigit) {
      case 1:
        return '=1';
      case 2:
      case 3:
      case 4:
        return 'few';
      default:
        return 'many';
    }
  }
  
  /// Получает локализованную строку с правильным plural
  static String getPluralString(Locale locale, String template, int value) {
    if (locale.languageCode == 'ru') {
      return russianPlural(template, value);
    }
    
    // Для других языков используем стандартную логику
    // или добавляйте кастомные resolvers для других языков
    
    // Простая замена как fallback
    return template
        .replaceAll('{value}', value.toString())
        .replaceAll('#', value.toString());
  }
}