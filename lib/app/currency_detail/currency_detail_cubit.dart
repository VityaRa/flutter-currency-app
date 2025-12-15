import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lr4/domain/model/currency_history_model.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/service/network_service.dart';

// Состояния
abstract class CurrencyDetailState {}
class CurrencyDetailLoading extends CurrencyDetailState {}
class CurrencyDetailError extends CurrencyDetailState { final String message; CurrencyDetailError(this.message); }
class CurrencyDetailLoaded extends CurrencyDetailState {
  final List<CurrencyHistoryModel> history;
  CurrencyDetailLoaded(this.history);
}

class CurrencyDetailCubit extends Cubit<CurrencyDetailState> {
  final CurrencyRepository _repository;
  final NetworkService _networkService;
  final String currencyId;

  CurrencyDetailCubit({
    required CurrencyRepository repository,
    required NetworkService networkService,
    required this.currencyId,
  }) : _repository = repository,
       _networkService = networkService,
       super(CurrencyDetailLoading());

  Future<void> loadHistory() async {
    print('🔄 CURRENCY CUBIT DEBUG: Загрузка истории для ID: $currencyId');
    emit(CurrencyDetailLoading());

    // Проверка сети
    if (!await _networkService.isConnected()) {
      print('⚠️ CURRENCY CUBIT DEBUG: Сеть недоступна.');
      emit(CurrencyDetailError('Нет сети'));
      return;
    }

    try {
      // Берем данные за последний месяц
      final now = DateTime.now();
      final monthAgo = now.subtract(const Duration(days: 30));

      final history = await _repository.getCurrencyHistory(currencyId, monthAgo, now);
      
      if (history.isEmpty) {
        print('❌ CURRENCY CUBIT DEBUG: Получен пустой список данных.');
        emit(CurrencyDetailError('Нет данных за этот период'));
      } else {
         // Сортируем по дате
         history.sort((a, b) => b.date.compareTo(a.date)); // От новых к старым
         print('✅ CURRENCY CUBIT DEBUG: Загружено ${history.length} записей.');
         emit(CurrencyDetailLoaded(history));
      }
    } catch (e) {
      print('CURRENCY CUBIT DEBUG: Непредвиденная ошибка: $e');
      emit(CurrencyDetailError('Ошибка загрузки: $e'));
    }
  }
}