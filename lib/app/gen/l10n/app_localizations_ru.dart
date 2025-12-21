// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get currencyRate => 'Курс Валют';

  @override
  String get news => 'Новости';

  @override
  String get profile => 'Профиль';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get system => 'Системная';

  @override
  String get search => 'Поиск';

  @override
  String asNominal(num value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value штук',
      many: '$value штук',
      few: '$value штуки',
      one: '$value штука',
      two: '2 штуки',
      zero: '0 штук',
    );
    return '$_temp0';
  }

  @override
  String get checkNetwork =>
      'Нет подключения к интернету. Проверьте настройки сети.';

  @override
  String get cannotLoadCurrencies => 'Не удалось загрузить курсы валют.';

  @override
  String get cannotLoadNews => 'Не удалось загрузить новости.';

  @override
  String get repeat => 'Повторить';

  @override
  String get noNews => 'Нет новостей';

  @override
  String get noData => 'Нет данных';

  @override
  String noCurrencyData(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нет данных о валютах',
      one: 'Нет данных о валюте',
      zero: 'Нет данных о валютах',
    );
    return '$_temp0';
  }

  @override
  String get offlineMode => 'Оффлайн режим';

  @override
  String get cachedData => 'Кэшированные данные';

  @override
  String get updated => 'Обновлено';

  @override
  String get clearCache => 'Очистка кэша';

  @override
  String get cacheCleared => 'Кэш успешно очищен';

  @override
  String get removeAllSavedData => 'Удалить все сохранённые данные';

  @override
  String get cacheClearError => 'Ошибка при очистке кэша';

  @override
  String get confirmClearCache =>
      'Вы уверены, что хотите очистить все сохранённые данные? При следующем запуске приложения данные будут загружены заново.';

  @override
  String get cancel => 'Отмена';

  @override
  String get clear => 'Очистить';

  @override
  String get restartApp => 'Перезагрузка приложения';

  @override
  String get chosedDataSource => 'Вы выбрали источник данных';

  @override
  String get restartForApply =>
      'Для применения изменений приложение необходимо перезагрузить.';

  @override
  String get restart => 'Перезагрузить';

  @override
  String get dataSource => 'Источник данных';

  @override
  String get applyNewDatasource => 'Применяем новый источник данных';

  @override
  String localStorageInfo(String datasource) {
    return 'Используется $datasource для локального хранения данных';
  }

  @override
  String get dataWillLoadedViaNetwork =>
      'Данные будут загружаться из сети или из локального хранилища SQLite';

  @override
  String get returnDataScreen => 'Экран для возврата результата';

  @override
  String passedArguments(String text, int number) {
    return 'Переданы аргументы: \"$text\" и число $number';
  }

  @override
  String get clickToReturn =>
      'Нажмите \"Вернуть данные\", чтобы закрыть этот экран и отправить текущую дату и время.';

  @override
  String get returnDataButton => 'Вернуть данные';

  @override
  String confirmationMessage(String datetime) {
    return 'Операция подтверждена: $datetime';
  }

  @override
  String get noGivenData => 'Нет переданных данных';

  @override
  String get settings => 'Настройки';

  @override
  String get dataTransferDemo => 'Передача данных в обоих направлениях:';

  @override
  String get navigateWithData => 'Перейти на result_screen и передать данные';

  @override
  String get advancedNavigatorMethods => 'Расширенные методы Navigator:';

  @override
  String get pushNamedAndRemoveUntil =>
      'pushNamedAndRemoveUntil (На Главный Экран)';

  @override
  String get popUntil => 'popUntil (До Главного Экрана)';

  @override
  String maybePop(String canPop) {
    return 'maybePop (Можно закрыть: $canPop)';
  }

  @override
  String get modalElementsDemo => 'Модальные элементы и обработка результатов:';

  @override
  String get dialogTitle => 'Модальное окно';

  @override
  String get dialogContent => 'Хотите подтвердить операцию?';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get confirmButton => 'Подтвердить';

  @override
  String get bottomSheetTitle => 'Выберите опцию';

  @override
  String get optionA => 'Опция A';

  @override
  String get optionASelected => 'Опция A выбрана';

  @override
  String get chooseDate => 'Выберите дату';

  @override
  String get chooseTime => 'Выберите время';

  @override
  String dateSelected(String date) {
    return 'Выбрана дата: $date';
  }

  @override
  String timeSelected(String time) {
    return 'Выбрано время: $time';
  }

  @override
  String get operationCancelled => 'Отменено';

  @override
  String get operationConfirmed => 'Подтверждено';

  @override
  String resultReceived(String result) {
    return '✅ Результат получен: $result';
  }

  @override
  String get noResult => '⚠️ Результат не был выбран.';

  @override
  String resultDialog(String result) {
    return 'Результат Dialog: $result';
  }

  @override
  String resultBottomSheet(String result) {
    return 'Результат BottomSheet: $result';
  }

  @override
  String get modalBottomSheet => 'Нижнее модальное меню';

  @override
  String get details => 'Детали';

  @override
  String get language => 'Язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageSpanish => 'Испанский';

  @override
  String get changedTo => 'изменен на';
}
