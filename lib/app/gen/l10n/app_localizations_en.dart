// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get currencyRate => 'Currency Rates';

  @override
  String get news => 'News';

  @override
  String get profile => 'Profile';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get search => 'Search';

  @override
  String asNominal(num value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value pieces',
      one: '1 piece',
      zero: '0 pieces',
    );
    return '$_temp0';
  }

  @override
  String get checkNetwork => 'No internet connection. Check network settings.';

  @override
  String get cannotLoadCurrencies => 'Failed to load currency rates.';

  @override
  String get cannotLoadNews => 'Failed to load news.';

  @override
  String get repeat => 'Retry';

  @override
  String get noNews => 'No news';

  @override
  String get noData => 'No data';

  @override
  String noCurrencyData(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No currency data',
      one: 'No currency data',
      zero: 'No currency data',
    );
    return '$_temp0';
  }

  @override
  String get offlineMode => 'Offline mode';

  @override
  String get cachedData => 'Cached data';

  @override
  String get updated => 'Updated';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get cacheCleared => 'Cache cleared successfully';

  @override
  String get removeAllSavedData => 'Remove all saved data';

  @override
  String get cacheClearError => 'Error clearing cache';

  @override
  String get confirmClearCache =>
      'Are you sure you want to clear all saved data? The data will be reloaded on the next app launch.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get restartApp => 'App restart';

  @override
  String get chosedDataSource => 'You have selected data source';

  @override
  String get restartForApply =>
      'To apply the changes, the application needs to be restarted.';

  @override
  String get restart => 'Restart';

  @override
  String get dataSource => 'Data source';

  @override
  String get applyNewDatasource => 'Applying new data source';

  @override
  String localStorageInfo(String datasource) {
    return 'Uses $datasource for local data storage';
  }

  @override
  String get dataWillLoadedViaNetwork =>
      'Data will be loaded from the network or from local SQLite storage';

  @override
  String get returnDataScreen => 'Return Result Screen';

  @override
  String passedArguments(String text, int number) {
    return 'Arguments passed: \"$text\" and number $number';
  }

  @override
  String get clickToReturn =>
      'Click \"Return Data\" to close this screen and send the current date and time.';

  @override
  String get returnDataButton => 'Return Data';

  @override
  String confirmationMessage(String datetime) {
    return 'Operation confirmed: $datetime';
  }

  @override
  String get noGivenData => 'No data passed';

  @override
  String get settings => 'Settings';

  @override
  String get dataTransferDemo => 'Data transfer in both directions:';

  @override
  String get navigateWithData => 'Go to result_screen and pass data';

  @override
  String get advancedNavigatorMethods => 'Advanced Navigator methods:';

  @override
  String get pushNamedAndRemoveUntil =>
      'pushNamedAndRemoveUntil (To Home Screen)';

  @override
  String get popUntil => 'popUntil (To Home Screen)';

  @override
  String maybePop(String canPop) {
    return 'maybePop (Can close: $canPop)';
  }

  @override
  String get modalElementsDemo => 'Modal elements and result handling:';

  @override
  String get dialogTitle => 'Modal window';

  @override
  String get dialogContent => 'Do you want to confirm the operation?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get bottomSheetTitle => 'Select an option';

  @override
  String get optionA => 'Option A';

  @override
  String get optionASelected => 'Option A selected';

  @override
  String get chooseDate => 'Select date';

  @override
  String get chooseTime => 'Select time';

  @override
  String dateSelected(String date) {
    return 'Date selected: $date';
  }

  @override
  String timeSelected(String time) {
    return 'Time selected: $time';
  }

  @override
  String get operationCancelled => 'Cancelled';

  @override
  String get operationConfirmed => 'Confirmed';

  @override
  String resultReceived(String result) {
    return '✅ Result received: $result';
  }

  @override
  String get noResult => '⚠️ No result was selected.';

  @override
  String resultDialog(String result) {
    return 'Dialog result: $result';
  }

  @override
  String resultBottomSheet(String result) {
    return 'BottomSheet result: $result';
  }

  @override
  String get modalBottomSheet => 'Modal Bottom Sheet';

  @override
  String get details => 'Details';

  @override
  String get language => 'Language';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get changedTo => 'changed to';
}
