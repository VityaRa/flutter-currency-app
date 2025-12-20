part of 'profile_page.dart';

class LanguageSelectorBottomSheet extends StatelessWidget {
  const LanguageSelectorBottomSheet._({
    required this.selectedLocale,
    required this.supportedLocales,
  });

  final Locale selectedLocale;
  final List<Locale> supportedLocales;

  static Future<Locale?> show(
    BuildContext context,
    Locale selectedLocale,
  ) {
    final supportedLocales = AppLocalizations.supportedLocales;
    
    return showModalBottomSheet<Locale>(
      context: context,
      builder: (_) => LanguageSelectorBottomSheet._(
        selectedLocale: selectedLocale,
        supportedLocales: supportedLocales,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;
    final ThemeFonts fonts = context.fonts;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.loc.language,
                    style: context.fonts.regular12.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Список языков
            ...supportedLocales.map((locale) {
              final isSelected = locale.languageCode == selectedLocale.languageCode &&
                                (locale.countryCode == selectedLocale.countryCode ||
                                 (locale.countryCode == null && selectedLocale.countryCode == null));

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context, locale),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: colors.grey.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Флаг
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: colors.grey.withOpacity(0.1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _getLanguageFlag(locale),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Информация о языке
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getLanguageName(context, locale),
                                style: fonts.regular16.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (locale.countryCode != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '${locale.languageCode}_${locale.countryCode}',
                                    style: fonts.regular12.copyWith(
                                      color: colors.grey,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        // Индикатор выбора
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Метод для получения флага языка
  String _getLanguageFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return '🇷🇺';
      case 'en':
        if (locale.countryCode == 'GB') return '🇬🇧';
        return '🇺🇸'; // По умолчанию US флаг
      case 'es':
        if (locale.countryCode == 'MX') return '🇲🇽';
        return '🇪🇸'; // По умолчанию ES флаг
      default:
        return '🌐'; // Глобус для других языков
    }
  }

    String _getLanguageName(BuildContext context, Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return context.loc.languageRussian;
      case 'en':
        return context.loc.languageEnglish;
      case 'es':
        return context.loc.languageSpanish;
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}

