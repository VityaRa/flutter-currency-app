import 'package:equatable/equatable.dart';
import 'package:lr4/domain/model/news_model.dart';

enum NewsListStatus {
  initial, // Начальное состояние
  cached, // Показаны кэшированные данные
  loading, // Загрузка (без данных)
  refreshing, // Обновление данных (есть кэшированные)
  success, // Успешная загрузка
  failure, // Ошибка загрузки
  networkError, // Ошибка сети
}

class NewsListState extends Equatable {
  final NewsListStatus status;
  final List<NewsModel> allNews;
  final bool isRefreshing;
  final DateTime? lastUpdateTime;
  final String? errorMessage;

  const NewsListState({
    this.status = NewsListStatus.initial,
    this.allNews = const [],
    this.isRefreshing = false,
    this.lastUpdateTime,
    this.errorMessage,
  });

  NewsListState copyWith({
    NewsListStatus? status,
    List<NewsModel>? allNews,
    bool? isRefreshing,
    DateTime? lastUpdateTime,
    String? errorMessage,
  }) {
    return NewsListState(
      status: status ?? this.status,
      allNews: allNews ?? this.allNews,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  NewsListState setLastUpdateTime(DateTime? time) {
    return NewsListState(
      status: status,
      allNews: allNews,
      isRefreshing: isRefreshing,
      errorMessage: errorMessage,
      lastUpdateTime: time,
    );
  }

  NewsListState clearLastUpdateTime() {
    return setLastUpdateTime(null);
  }

  @override
  List<Object?> get props => [
        status,
        allNews,
        isRefreshing,
        lastUpdateTime,
        errorMessage,
      ];
}
