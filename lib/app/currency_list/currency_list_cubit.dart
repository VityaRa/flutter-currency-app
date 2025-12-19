// lib/app/currency_list/currency_list_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lr4/app/currency_list/currency_list_state.dart';
import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/service/network_service.dart';

class CurrencyListCubit extends Cubit<CurrencyListState> {
  final CurrencyRepository _repository;
  final NetworkService _networkService;

  CurrencyListCubit({
    required CurrencyRepository repository,
    required NetworkService networkService,
  })  : _repository = repository,
        _networkService = networkService,
        super(const CurrencyListState()) {
    emit(state.copyWith(
      status: CurrencyListStatus.loading,
    ));
    // Инициализируем загрузку локальных данных при создании
    _initializeFromCache();
  }

  // Асинхронная инициализация из кэша (не блокирует UI)
  Future<void> _initializeFromCache() async {
    try {
      print('_initializeFromCache: Загрузка данных из кэша');

      final cachedCurrencies = await _repository.getCurrencyListFromCache();
      print("_initializeFromCache: cachedCurrencies $cachedCurrencies");
      if (cachedCurrencies != null && cachedCurrencies.isNotEmpty) {
        print("_initializeFromCache: Отображение кэша");
        // Мгновенно показываем кэшированные данные
        emit(state.copyWith(
          status: CurrencyListStatus.cached,
          allCurrencies: cachedCurrencies,
          filteredCurrencies: cachedCurrencies,
        ));
      }
    } catch (e) {
      print('_initializeFromCache: Ошибка загрузки кэшированных валют: $e');
    }

    // Затем загружаем актуальные данные
    await loadCurrencies();
  }

  Future<void> loadCurrencies() async {
    // await Future.delayed(const Duration(seconds: 2));

    // Не прерываем загрузку, если уже грузим
    if (state.status == CurrencyListStatus.refreshing) return;

    // Проверяем подключение к сети
    final isConnected = await _networkService.isConnected();

    if (!isConnected) {
      // Если нет сети, но есть кэшированные данные - показываем их с индикатором
      if (state.allCurrencies.isNotEmpty) {
        emit(state.copyWith(
          status: CurrencyListStatus.networkError,
          lastUpdateTime: DateTime.now(),
        ));
      } else {
        // Если нет сети и нет кэша - показываем полную ошибку
        emit(state.copyWith(
          status: CurrencyListStatus.networkError,
          allCurrencies: [],
          filteredCurrencies: [],
        ));
      }
      return;
    }

    // Устанавливаем статус обновления (сохраняем текущие данные)
    emit(state.copyWith(
      status: CurrencyListStatus.refreshing,
      isRefreshing: true,
    ));

    try {
      print('Загрузка данных из сети');
      // Загружаем свежие данные
      final List<CurrencyModel> result = await _repository.getCurrencyList();

      // Сохраняем данные в кэш
      await _repository.saveCurrencyList(result);

      // Обновляем состояние с новыми данными
      final newState = state.copyWith(
        status: CurrencyListStatus.success,
        allCurrencies: result,
        filteredCurrencies: result,
        searchQuery: state.searchQuery,
        isRefreshing: false,
        lastUpdateTime: DateTime.now(),
      );

      // Если был поисковый запрос, применяем фильтрацию к новым данным
      // if (state.searchQuery.isNotEmpty) {
      //   newState.filteredCurrencies = _applyFilter(result, state.searchQuery);
      // }

      emit(newState);
    } catch (e) {
      print('Ошибка загрузки валют: $e');

      // Если произошла ошибка, но есть данные - показываем их с ошибкой
      if (state.allCurrencies.isNotEmpty) {
        emit(state.copyWith(
          status: CurrencyListStatus.failure,
          isRefreshing: false,
          lastUpdateTime: DateTime.now(),
        ));
      } else {
        // Если нет данных - показываем полную ошибку
        emit(state.copyWith(
          status: CurrencyListStatus.failure,
          allCurrencies: [],
          filteredCurrencies: [],
          isRefreshing: false,
        ));
      }
    }
  }

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
    await loadCurrencies();
  }
}
