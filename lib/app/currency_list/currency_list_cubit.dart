import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:lr4/app/currency_list/currency_list_state.dart';
import 'package:lr4/domain/datasource/preference_datasource.dart';
import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/service/logger_service.dart';
import 'package:lr4/domain/service/network_service.dart';

class CurrencyListCubit extends Cubit<CurrencyListState> {
  final CurrencyRepository _repository;
  final NetworkService _networkService;
  final PreferenceDatasource _preferenceDatasource;
  static final Logger _logger = LoggerService.getCubitLogger('CurrencyList');

  CurrencyListCubit({
    required CurrencyRepository repository,
    required NetworkService networkService,
    required PreferenceDatasource preferenceDatasource,
  })  : _repository = repository,
        _networkService = networkService,
        _preferenceDatasource = preferenceDatasource,
        super(const CurrencyListState()) {
    emit(state.copyWith(
      status: CurrencyListStatus.loading,
    ));
    init();
  }

  Future<void> init() async {
    await _tryLoadCache();
    await _tryLoadFromNetwork();
  }

  Future<void> _tryLoadCache() async {
    final cachedCurrencies = await _repository.getCurrencyListFromCache();
    _logger.info(
        "_tryLoadCache Получено: ${cachedCurrencies.length} валют из кэша");
    if (cachedCurrencies.isNotEmpty) {
      final lastUpdated = await _repository.getLastUpdate();
      _logger.info(
          "_tryLoadCache Отображены: ${cachedCurrencies.length} валют из кэша");

      _logger.info("_tryLoadCache lastUpdated: $lastUpdated");
      emit(state.copyWith(
        allCurrencies: cachedCurrencies,
        lastUpdateTime: lastUpdated,
        filteredCurrencies: cachedCurrencies,
      ));
      return;
    }

    emit(state.copyWith(
      allCurrencies: [],
      filteredCurrencies: cachedCurrencies,
    ));

    _logger.info("_tryLoadCache кэш пустой: новости берем из сети");
  }

  Future<void> _tryLoadFromNetwork() async {
    if (_preferenceDatasource.selectedDatasource == DataSource.drift ||
        _preferenceDatasource.selectedDatasource == DataSource.sqfLite) {
      return;
    }

    emit(state.copyWith(
      status: CurrencyListStatus.loading,
    ));
    final isConnected = await _networkService.isConnected();
    _logger.info("_tryLoadFromNetwork состояние сети: $isConnected");

    if (!isConnected) {
      if (state.allCurrencies.isNotEmpty) {
        _logger.info("Сети нет, но был кэш");
        emit(state.copyWith(
          status: CurrencyListStatus.networkError,
          errorMessage: 'Нет подключения к интернету',
        ));
      } else {
        _logger.info("Сети нет и кэша тоже");
        // Если нет сети и нет кэша - показываем полную ошибку
        emit(state.copyWith(
          status: CurrencyListStatus.networkError,
          errorMessage:
              'Нет подключения к интернету. Проверьте настройки сети.',
        ));
      }

      await _tryLoadCache();
      return;
    }

    try {
      _logger.info("_tryLoadFromNetwork - начинается загрузка");
      final List<CurrencyModel> result = await _repository.getCurrencyList();
      if (result.isEmpty) {
        throw "Ошибка получения данных";
      }
      _logger.info("_tryLoadFromNetwork - получено ${result.length} валют");
      await _repository.saveCurrencyList(result);
      _logger.info("_tryLoadFromNetwork - валюты сохранены в кэш");
      emit(state.copyWith(
        status: CurrencyListStatus.success,
        allCurrencies: result,
        filteredCurrencies: result,
        isRefreshing: false,
        errorMessage: null,
        lastUpdateTime: null,
      ));
      _logger.info("_tryLoadFromNetwork - завершно с успхеом");
    } catch (e) {
      if (state.allCurrencies.isNotEmpty) {
        _logger.info("_tryLoadFromNetwork - ошибка при запросе, но есть кэш");
        emit(state.copyWith(
          status: CurrencyListStatus.failure,
          isRefreshing: false,
          errorMessage: 'Не удалось обновить новости',
        ));
      } else {
        _logger.info("_tryLoadFromNetwork - ошибка при запросе, кэша нет");
        emit(state.copyWith(
          status: CurrencyListStatus.failure,
          isRefreshing: false,
          errorMessage: 'Не удалось загрузить новости. Попробуйте еще раз.',
        ));
      }
      await _tryLoadCache();
    }
  }

  // Future<void> loadCurrencies() async {
  //   // await Future.delayed(const Duration(seconds: 2));

  //   // Не прерываем загрузку, если уже грузим
  //   if (state.status == CurrencyListStatus.refreshing) return;

  //   // Проверяем подключение к сети
  //   final isConnected = await _networkService.isConnected();

  //   if (!isConnected) {
  //     // Если нет сети, но есть кэшированные данные - показываем их с индикатором
  //     if (state.allCurrencies.isNotEmpty) {
  //       emit(state.copyWith(
  //         status: CurrencyListStatus.networkError,
  //         lastUpdateTime: DateTime.now(),
  //       ));
  //     } else {
  //       // Если нет сети и нет кэша - показываем полную ошибку
  //       emit(state.copyWith(
  //         status: CurrencyListStatus.networkError,
  //         allCurrencies: [],
  //         filteredCurrencies: [],
  //       ));
  //     }
  //     return;
  //   }

  //   // Устанавливаем статус обновления (сохраняем текущие данные)
  //   emit(state.copyWith(
  //     status: CurrencyListStatus.refreshing,
  //     isRefreshing: true,
  //   ));

  //   try {
  //     print('Загрузка данных из сети');
  //     // Загружаем свежие данные
  //     final List<CurrencyModel> result = await _repository.getCurrencyList();

  //     // Сохраняем данные в кэш
  //     await _repository.saveCurrencyList(result);

  //     // Обновляем состояние с новыми данными
  //     final newState = state.copyWith(
  //       status: CurrencyListStatus.success,
  //       allCurrencies: result,
  //       filteredCurrencies: result,
  //       searchQuery: state.searchQuery,
  //       isRefreshing: false,
  //       lastUpdateTime: DateTime.now(),
  //     );

  //     // Если был поисковый запрос, применяем фильтрацию к новым данным
  //     // if (state.searchQuery.isNotEmpty) {
  //     //   newState.filteredCurrencies = _applyFilter(result, state.searchQuery);
  //     // }

  //     emit(newState);
  //   } catch (e) {
  //     print('Ошибка загрузки валют: $e');

  //     // Если произошла ошибка, но есть данные - показываем их с ошибкой
  //     if (state.allCurrencies.isNotEmpty) {
  //       emit(state.copyWith(
  //         status: CurrencyListStatus.failure,
  //         isRefreshing: false,
  //         lastUpdateTime: DateTime.now(),
  //       ));
  //     } else {
  //       // Если нет данных - показываем полную ошибку
  //       emit(state.copyWith(
  //         status: CurrencyListStatus.failure,
  //         allCurrencies: [],
  //         filteredCurrencies: [],
  //         isRefreshing: false,
  //       ));
  //     }
  //   }
  // }

  void filterCurrencies(String query) {
    final result = _applyFilter(state.allCurrencies, query);

    emit(state.copyWith(
      searchQuery: query,
      filteredCurrencies: result,
    ));
  }

  List<CurrencyModel> _applyFilter(
      List<CurrencyModel> currencies, String query) {
    if (query.isEmpty) return currencies;

    final lowerQuery = query.toLowerCase();
    return currencies.where((currency) {
      return currency.name.toLowerCase().contains(lowerQuery) ||
          currency.symbol.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Метод для принудительной перезагрузки (при пулле вниз)
  Future<void> refreshCurrencies() async {
    await _tryLoadCache();
    await _tryLoadFromNetwork();
  }
}
