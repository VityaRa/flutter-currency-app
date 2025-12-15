import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Состояние: индекс выбранной вкладки
class HomeState extends Equatable {
  final int selectedIndex;
  
  const HomeState(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(0)); // Начальная вкладка - 0

  void selectTab(int index) {
    if (index != state.selectedIndex) {
      emit(HomeState(index));
    }
  }
}