// lib/app/currency_list/currency_list_state.dart

import 'package:equatable/equatable.dart';
import 'package:lr4/domain/model/currency_model.dart';

enum CurrencyListStatus {
  initial,      // Начальное состояние
  cached,       // Показаны кэшированные данные
  loading,      // Загрузка (без данных)
  refreshing,   // Обновление данных (есть кэшированные)
  success,      // Успешная загрузка
  failure,      // Ошибка загрузки
  networkError, // Ошибка сети
}

class CurrencyListState extends Equatable {
  final CurrencyListStatus status;
  final List<CurrencyModel> allCurrencies;
  final List<CurrencyModel> filteredCurrencies;
  final String searchQuery;
  final bool isRefreshing;
  final DateTime? lastUpdateTime;

  const CurrencyListState({
    this.status = CurrencyListStatus.initial,
    this.allCurrencies = const [],
    this.filteredCurrencies = const [],
    this.searchQuery = '',
    this.isRefreshing = false,
    this.lastUpdateTime,
  });

  CurrencyListState copyWith({
    CurrencyListStatus? status,
    List<CurrencyModel>? allCurrencies,
    List<CurrencyModel>? filteredCurrencies,
    String? searchQuery,
    bool? isRefreshing,
    DateTime? lastUpdateTime,
  }) {
    return CurrencyListState(
      status: status ?? this.status,
      allCurrencies: allCurrencies ?? this.allCurrencies,
      filteredCurrencies: filteredCurrencies ?? this.filteredCurrencies,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allCurrencies,
    filteredCurrencies,
    searchQuery,
    isRefreshing,
    lastUpdateTime,
  ];
}