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
  })

      : _repository = repository,
      _networkService = networkService,
        super(const CurrencyListState());

  Future<void> loadCurrencies() async {
    if (state.status == CurrencyListStatus.loading) return;

    emit(state.copyWith(status: CurrencyListStatus.loading));

    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      emit(state.copyWith(status: CurrencyListStatus.networkError));
      return;
    }

    try {
      final List<CurrencyModel> result = await _repository.getCurrencyList();

      emit(state.copyWith(
        status: CurrencyListStatus.success,
        allCurrencies: result,
        filteredCurrencies: result, // Изначально фильтрованный список равен полному
      ));
    } catch (e) {
      // Здесь можно логировать ошибку
      emit(state.copyWith(status: CurrencyListStatus.failure));
    }
  }

  void filterCurrencies(String query) {
    final lowerQuery = query.toLowerCase();

    // 1. Фильтруем от ВСЕХ валют, а не от уже отфильтрованных
    final result = state.allCurrencies.where((currency) {
      return currency.name.toLowerCase().contains(lowerQuery) ||
          currency.symbol.toLowerCase().contains(lowerQuery);
    }).toList();

    // 2. Обновляем состояние: сохраняем текст поиска и новый отфильтрованный список
    emit(state.copyWith(
      searchQuery: query,
      filteredCurrencies: result,
    ));
  }
}