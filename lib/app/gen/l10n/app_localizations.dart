import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ru')
  ];

  /// No description provided for @login.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get logout;

  /// No description provided for @currencyRate.
  ///
  /// In ru, this message translates to:
  /// **'Курс Валют'**
  String get currencyRate;

  /// No description provided for @news.
  ///
  /// In ru, this message translates to:
  /// **'Новости'**
  String get news;

  /// No description provided for @profile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profile;

  /// No description provided for @theme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get system;

  /// No description provided for @search.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get search;

  /// Plural template for item quantity
  ///
  /// In ru, this message translates to:
  /// **'{value, plural, one{# штука} few{# штуки} many{# штук} other{# штук}}'**
  String asNominalTemplate(num value);

  /// Plural form for item quantity
  ///
  /// In ru, this message translates to:
  /// **'{value, plural, =0{0 штук}=1{1 штука}=2{2 штуки}few{# штуки}many{# штук}other{# штук}}'**
  String asNominal(num value);

  /// No description provided for @checkNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Нет подключения к интернету. Проверьте настройки сети.'**
  String get checkNetwork;

  /// No description provided for @cannotLoadCurrencies.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить курсы валют.'**
  String get cannotLoadCurrencies;

  /// No description provided for @cannotLoadNews.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить новости.'**
  String get cannotLoadNews;

  /// No description provided for @repeat.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get repeat;

  /// No description provided for @noNews.
  ///
  /// In ru, this message translates to:
  /// **'Нет новостей'**
  String get noNews;

  /// No description provided for @noData.
  ///
  /// In ru, this message translates to:
  /// **'Нет данных'**
  String get noData;

  /// Plural form for no currency data message
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Нет данных о валютах}=1{Нет данных о валюте}other{Нет данных о валютах}}'**
  String noCurrencyData(num count);

  /// No description provided for @offlineMode.
  ///
  /// In ru, this message translates to:
  /// **'Оффлайн режим'**
  String get offlineMode;

  /// No description provided for @cachedData.
  ///
  /// In ru, this message translates to:
  /// **'Кэшированные данные'**
  String get cachedData;

  /// No description provided for @updated.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено'**
  String get updated;

  /// No description provided for @clearCache.
  ///
  /// In ru, this message translates to:
  /// **'Очистка кэша'**
  String get clearCache;

  /// No description provided for @cacheCleared.
  ///
  /// In ru, this message translates to:
  /// **'Кэш успешно очищен'**
  String get cacheCleared;

  /// No description provided for @removeAllSavedData.
  ///
  /// In ru, this message translates to:
  /// **'Удалить все сохранённые данные'**
  String get removeAllSavedData;

  /// No description provided for @cacheClearError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка при очистке кэша'**
  String get cacheClearError;

  /// No description provided for @confirmClearCache.
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите очистить все сохранённые данные? При следующем запуске приложения данные будут загружены заново.'**
  String get confirmClearCache;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get clear;

  /// No description provided for @restartApp.
  ///
  /// In ru, this message translates to:
  /// **'Перезагрузка приложения'**
  String get restartApp;

  /// No description provided for @chosedDataSource.
  ///
  /// In ru, this message translates to:
  /// **'Вы выбрали источник данных'**
  String get chosedDataSource;

  /// No description provided for @restartForApply.
  ///
  /// In ru, this message translates to:
  /// **'Для применения изменений приложение необходимо перезагрузить.'**
  String get restartForApply;

  /// No description provided for @restart.
  ///
  /// In ru, this message translates to:
  /// **'Перезагрузить'**
  String get restart;

  /// No description provided for @dataSource.
  ///
  /// In ru, this message translates to:
  /// **'Источник данных'**
  String get dataSource;

  /// No description provided for @applyNewDatasource.
  ///
  /// In ru, this message translates to:
  /// **'Применяем новый источник данных'**
  String get applyNewDatasource;

  /// Информация об источнике локального хранения данных
  ///
  /// In ru, this message translates to:
  /// **'Используется {datasource} для локального хранения данных'**
  String localStorageInfo(String datasource);

  /// No description provided for @dataWillLoadedViaNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Данные будут загружаться из сети или из локального хранилища SQLite'**
  String get dataWillLoadedViaNetwork;

  /// No description provided for @returnDataScreen.
  ///
  /// In ru, this message translates to:
  /// **'Экран для возврата результата'**
  String get returnDataScreen;

  /// Text displaying passed arguments
  ///
  /// In ru, this message translates to:
  /// **'Переданы аргументы: \"{text}\" и число {number}'**
  String passedArguments(String text, int number);

  /// No description provided for @clickToReturn.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите \"Вернуть данные\", чтобы закрыть этот экран и отправить текущую дату и время.'**
  String get clickToReturn;

  /// No description provided for @returnDataButton.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть данные'**
  String get returnDataButton;

  /// Confirmation message with date and time
  ///
  /// In ru, this message translates to:
  /// **'Операция подтверждена: {datetime}'**
  String confirmationMessage(String datetime);

  /// No description provided for @noGivenData.
  ///
  /// In ru, this message translates to:
  /// **'Нет переданных данных'**
  String get noGivenData;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @dataTransferDemo.
  ///
  /// In ru, this message translates to:
  /// **'Передача данных в обоих направлениях:'**
  String get dataTransferDemo;

  /// No description provided for @navigateWithData.
  ///
  /// In ru, this message translates to:
  /// **'Перейти на result_screen и передать данные'**
  String get navigateWithData;

  /// No description provided for @advancedNavigatorMethods.
  ///
  /// In ru, this message translates to:
  /// **'Расширенные методы Navigator:'**
  String get advancedNavigatorMethods;

  /// No description provided for @pushNamedAndRemoveUntil.
  ///
  /// In ru, this message translates to:
  /// **'pushNamedAndRemoveUntil (На Главный Экран)'**
  String get pushNamedAndRemoveUntil;

  /// No description provided for @popUntil.
  ///
  /// In ru, this message translates to:
  /// **'popUntil (До Главного Экрана)'**
  String get popUntil;

  /// Maybe pop button text
  ///
  /// In ru, this message translates to:
  /// **'maybePop (Можно закрыть: {canPop})'**
  String maybePop(String canPop);

  /// No description provided for @modalElementsDemo.
  ///
  /// In ru, this message translates to:
  /// **'Модальные элементы и обработка результатов:'**
  String get modalElementsDemo;

  /// No description provided for @dialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Модальное окно'**
  String get dialogTitle;

  /// No description provided for @dialogContent.
  ///
  /// In ru, this message translates to:
  /// **'Хотите подтвердить операцию?'**
  String get dialogContent;

  /// No description provided for @cancelButton.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancelButton;

  /// No description provided for @confirmButton.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get confirmButton;

  /// No description provided for @bottomSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите опцию'**
  String get bottomSheetTitle;

  /// No description provided for @optionA.
  ///
  /// In ru, this message translates to:
  /// **'Опция A'**
  String get optionA;

  /// No description provided for @optionASelected.
  ///
  /// In ru, this message translates to:
  /// **'Опция A выбрана'**
  String get optionASelected;

  /// No description provided for @chooseDate.
  ///
  /// In ru, this message translates to:
  /// **'Выберите дату'**
  String get chooseDate;

  /// No description provided for @chooseTime.
  ///
  /// In ru, this message translates to:
  /// **'Выберите время'**
  String get chooseTime;

  /// Date selection confirmation
  ///
  /// In ru, this message translates to:
  /// **'Выбрана дата: {date}'**
  String dateSelected(String date);

  /// Time selection confirmation
  ///
  /// In ru, this message translates to:
  /// **'Выбрано время: {time}'**
  String timeSelected(String time);

  /// No description provided for @operationCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Отменено'**
  String get operationCancelled;

  /// No description provided for @operationConfirmed.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждено'**
  String get operationConfirmed;

  /// Result received confirmation
  ///
  /// In ru, this message translates to:
  /// **'✅ Результат получен: {result}'**
  String resultReceived(String result);

  /// No description provided for @noResult.
  ///
  /// In ru, this message translates to:
  /// **'⚠️ Результат не был выбран.'**
  String get noResult;

  /// Dialog result message
  ///
  /// In ru, this message translates to:
  /// **'Результат Dialog: {result}'**
  String resultDialog(String result);

  /// Bottom sheet result message
  ///
  /// In ru, this message translates to:
  /// **'Результат BottomSheet: {result}'**
  String resultBottomSheet(String result);

  /// No description provided for @modalBottomSheet.
  ///
  /// In ru, this message translates to:
  /// **'Нижнее модальное меню'**
  String get modalBottomSheet;

  /// No description provided for @details.
  ///
  /// In ru, this message translates to:
  /// **'Детали'**
  String get details;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'Английский'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In ru, this message translates to:
  /// **'Испанский'**
  String get languageSpanish;

  /// No description provided for @changedTo.
  ///
  /// In ru, this message translates to:
  /// **'изменен на'**
  String get changedTo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
