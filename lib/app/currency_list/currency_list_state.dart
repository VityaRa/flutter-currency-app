// lib/app/currency_list/currency_list_state.dart


import 'package:equatable/equatable.dart';
import 'package:lr4/domain/model/currency_model.dart';

enum CurrencyListStatus { initial, loading, success, failure, networkError }

class CurrencyListState extends Equatable {
  final CurrencyListStatus status;
  final List<CurrencyModel> allCurrencies;
  final List<CurrencyModel> filteredCurrencies;
  final String searchQuery;

  const CurrencyListState({
    this.status = CurrencyListStatus.initial,
    this.allCurrencies = const [],
    this.filteredCurrencies = const [],
    this.searchQuery = '',
  });

  CurrencyListState copyWith({
    CurrencyListStatus? status,
    List<CurrencyModel>? allCurrencies,
    List<CurrencyModel>? filteredCurrencies,
    String? searchQuery,
  }) {
    return CurrencyListState(
      status: status ?? this.status,
      allCurrencies: allCurrencies ?? this.allCurrencies,
      filteredCurrencies: filteredCurrencies ?? this.filteredCurrencies,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [status, allCurrencies, filteredCurrencies, searchQuery];
}