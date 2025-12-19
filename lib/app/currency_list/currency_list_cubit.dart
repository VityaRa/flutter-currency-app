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
        super(const CurrencyListState());

  Future<void> loadCurrencies() async {
    if (state.status == CurrencyListStatus.loading) return;

    // Сначала пытаемся загрузить кэшированные данные
    try {
      final cachedCurrencies = await _repository.getCurrencyListFromCache();
      if (cachedCurrencies != null && cachedCurrencies.isNotEmpty) {
        emit(state.copyWith(
          status: CurrencyListStatus.loading,
          allCurrencies: cachedCurrencies,
          filteredCurrencies: cachedCurrencies,
        ));
      }
    } catch (e) {
      // Игнорируем ошибки при загрузке кэша
      print('Ошибка загрузки кэшированных валют: $e');
    }

    // Проверяем подключение к сети
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      // Если нет сети, но есть кэшированные данные - показываем их с ошибкой сети
      if (state.allCurrencies.isNotEmpty) {
        emit(state.copyWith(status: CurrencyListStatus.networkError));
      } else {
        // Если нет сети и нет кэша - показываем полную ошибку сети
        emit(state.copyWith(
          status: CurrencyListStatus.networkError,
          allCurrencies: [],
          filteredCurrencies: [],
        ));
      }
      return;
    }

    // Загружаем свежие данные
    try {
      final List<CurrencyModel> result = await _repository.getCurrencyList();

      // Сохраняем данные в кэш
      await _repository.saveCurrencyList(result);

      emit(state.copyWith(
        status: CurrencyListStatus.success,
        allCurrencies: result,
        filteredCurrencies: result,
        searchQuery: state.searchQuery, // Сохраняем текущий поисковый запрос
      ));

      // Если был поисковый запрос, применяем фильтрацию к новым данным
      if (state.searchQuery.isNotEmpty) {
        filterCurrencies(state.searchQuery);
      }
    } catch (e) {
      // Если произошла ошибка, но есть кэшированные данные - показываем их с ошибкой
      if (state.allCurrencies.isNotEmpty) {
        emit(state.copyWith(status: CurrencyListStatus.failure));
      } else {
        // Если нет кэша - показываем полную ошибку
        emit(state.copyWith(
          status: CurrencyListStatus.failure,
          allCurrencies: [],
          filteredCurrencies: [],
        ));
      }
    }
  }

  void filterCurrencies(String query) {
    final lowerQuery = query.toLowerCase();

    // Фильтруем от ВСЕХ валют
    final result = state.allCurrencies.where((currency) {
      return currency.name.toLowerCase().contains(lowerQuery) ||
          currency.symbol.toLowerCase().contains(lowerQuery);
    }).toList();

    // Обновляем состояние
    emit(state.copyWith(
      searchQuery: query,
      filteredCurrencies: result,
    ));
  }

  // Метод для принудительной перезагрузки (например, при пулле вниз)
  Future<void> refreshCurrencies() async {
    emit(state.copyWith(status: CurrencyListStatus.loading));
    await loadCurrencies();
  }
}