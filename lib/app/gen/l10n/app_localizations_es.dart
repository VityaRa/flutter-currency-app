// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get currencyRate => 'Tasas de cambio';

  @override
  String get news => 'Noticias';

  @override
  String get profile => 'Perfil';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get search => 'Buscar';

  @override
  String asNominal(num value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value piezas',
      one: '1 pieza',
      zero: '0 piezas',
    );
    return '$_temp0';
  }

  @override
  String get checkNetwork =>
      'No hay conexión a Internet. Verifique la configuración de red.';

  @override
  String get cannotLoadCurrencies =>
      'No se pudieron cargar las tasas de cambio.';

  @override
  String get cannotLoadNews => 'No se pudieron cargar las noticias.';

  @override
  String get repeat => 'Reintentar';

  @override
  String get noNews => 'No hay noticias';

  @override
  String get noData => 'No hay datos';

  @override
  String noCurrencyData(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No hay datos sobre divisas',
      one: 'No hay datos sobre la divisa',
      zero: 'No hay datos sobre divisas',
    );
    return '$_temp0';
  }

  @override
  String get offlineMode => 'Modo sin conexión';

  @override
  String get cachedData => 'Datos en caché';

  @override
  String get updated => 'Actualizado';

  @override
  String get clearCache => 'Limpiar caché';

  @override
  String get cacheCleared => 'Caché limpiado exitosamente';

  @override
  String get removeAllSavedData => 'Eliminar todos los datos guardados';

  @override
  String get cacheClearError => 'Error al limpiar el caché';

  @override
  String get confirmClearCache =>
      '¿Está seguro de que desea eliminar todos los datos guardados? Los datos se volverán a cargar en el próximo inicio de la aplicación.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clear => 'Limpiar';

  @override
  String get restartApp => 'Reiniciar aplicación';

  @override
  String get chosedDataSource => 'Ha seleccionado la fuente de datos';

  @override
  String get restartForApply =>
      'Para aplicar los cambios, es necesario reiniciar la aplicación.';

  @override
  String get restart => 'Reiniciar';

  @override
  String get dataSource => 'Fuente de datos';

  @override
  String get applyNewDatasource => 'Aplicando nueva fuente de datos';

  @override
  String localStorageInfo(String datasource) {
    return 'Se utiliza $datasource para almacenamiento local de datos';
  }

  @override
  String get dataWillLoadedViaNetwork =>
      'Los datos se cargarán desde la red o desde el almacenamiento local SQLite';

  @override
  String get returnDataScreen => 'Pantalla para devolver resultado';

  @override
  String passedArguments(String text, int number) {
    return 'Argumentos pasados: \"$text\" y número $number';
  }

  @override
  String get clickToReturn =>
      'Haga clic en \"Devolver datos\" para cerrar esta pantalla y enviar la fecha y hora actuales.';

  @override
  String get returnDataButton => 'Devolver datos';

  @override
  String confirmationMessage(String datetime) {
    return 'Operación confirmada: $datetime';
  }

  @override
  String get noGivenData => 'No hay datos pasados';

  @override
  String get settings => 'Configuración';

  @override
  String get dataTransferDemo => 'Transferencia de datos en ambas direcciones:';

  @override
  String get navigateWithData => 'Ir a result_screen y pasar datos';

  @override
  String get advancedNavigatorMethods => 'Métodos avanzados de Navigator:';

  @override
  String get pushNamedAndRemoveUntil =>
      'pushNamedAndRemoveUntil (A Pantalla Principal)';

  @override
  String get popUntil => 'popUntil (Hasta Pantalla Principal)';

  @override
  String maybePop(String canPop) {
    return 'maybePop (Se puede cerrar: $canPop)';
  }

  @override
  String get modalElementsDemo => 'Elementos modales y manejo de resultados:';

  @override
  String get dialogTitle => 'Ventana modal';

  @override
  String get dialogContent => '¿Desea confirmar la operación?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get confirmButton => 'Confirmar';

  @override
  String get bottomSheetTitle => 'Seleccione una opción';

  @override
  String get optionA => 'Opción A';

  @override
  String get optionASelected => 'Opción A seleccionada';

  @override
  String get chooseDate => 'Seleccionar fecha';

  @override
  String get chooseTime => 'Seleccionar hora';

  @override
  String dateSelected(String date) {
    return 'Fecha seleccionada: $date';
  }

  @override
  String timeSelected(String time) {
    return 'Hora seleccionada: $time';
  }

  @override
  String get operationCancelled => 'Cancelado';

  @override
  String get operationConfirmed => 'Confirmado';

  @override
  String resultReceived(String result) {
    return '✅ Resultado recibido: $result';
  }

  @override
  String get noResult => '⚠️ No se seleccionó ningún resultado.';

  @override
  String resultDialog(String result) {
    return 'Resultado del diálogo: $result';
  }

  @override
  String resultBottomSheet(String result) {
    return 'Resultado del BottomSheet: $result';
  }

  @override
  String get modalBottomSheet => 'Menú modal inferior';

  @override
  String get details => 'Detalles';

  @override
  String get language => 'Idioma';

  @override
  String get languageRussian => 'Ruso';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get changedTo => 'cambiado a';
}
