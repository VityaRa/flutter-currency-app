import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lr4/app/news_list/news_list_state.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:lr4/domain/repository/news_repository.dart';
import 'package:lr4/domain/service/network_service.dart';

class NewsListCubit extends Cubit<NewsListState> {
  final NewsRepository _repository;
  final NetworkService _networkService;

  // Флаги для имитации ошибок (можно вынести в конфиг)
  static const bool simulateNetworkError = false;
  static const bool simulateServerError = false;

  NewsListCubit({
    required NewsRepository repository,
    required NetworkService networkService,
  })  : _repository = repository,
        _networkService = networkService,
        super(const NewsListState()) {
    init();
  }

  Future<void> _tryLoadCache() async {
    final cachedNews = await _repository.getCachedNewsList();
    print("_tryLoadCache Получено: ${cachedNews.length} новостей из кэша");
    if (cachedNews.isNotEmpty) {
      print("_tryLoadCache Отображены: ${cachedNews.length} новостей из кэша");
      emit(state.copyWith(
        allNews: cachedNews,
      ));
      return;
    }

      emit(state.copyWith(
        allNews: [],
      ));

    print("_tryLoadCache кэш пустой: новости берем из сети");
  }

  Future<void> _tryLoadFromNetwork() async {
    emit(state.copyWith(
      status: NewsListStatus.loading,
    ));
    final isConnected =
        simulateNetworkError ? false : await _networkService.isConnected();
    print("_tryLoadFromNetwork состояние сети: $isConnected");
  
    if (!isConnected) {
      // Если нет сети, но есть кэшированные данные - показываем их
      if (state.allNews.isNotEmpty) {
        print("Сети нет, но был кэш");
        emit(state.copyWith(
          status: NewsListStatus.networkError,
          errorMessage: 'Нет подключения к интернету',
        ));
      } else {
        print("Сети нет и кэша тоже");
        // Если нет сети и нет кэша - показываем полную ошибку
        emit(state.copyWith(
          status: NewsListStatus.networkError,
          errorMessage:
              'Нет подключения к интернету. Проверьте настройки сети.',
        ));
      }

      await _tryLoadCache();
      return;
    }

    try {
      print("_tryLoadFromNetwork - начинается загрузка");
      final List<NewsModel> result = await _repository.getNewsList();
      if (result.isEmpty) {
        throw "Ошибка получения данных";
      }
      print("_tryLoadFromNetwork - получено ${result.length} новостей");
      await _repository.saveNewsList(result);
      print("_tryLoadFromNetwork - новости сохранены в кэш");
      emit(state.copyWith(
        status: NewsListStatus.success,
        allNews: result,
        isRefreshing: false,
        errorMessage: null,
      ));
      print("_tryLoadFromNetwork - завершно с успхеом");
    } catch (e) {
      if (state.allNews.isNotEmpty) {
        print("_tryLoadFromNetwork - ошибка при запросе, но есть кэш");
        emit(state.copyWith(
          status: NewsListStatus.failure,
          isRefreshing: false,
          lastUpdateTime: DateTime.now(),
          errorMessage: 'Не удалось обновить новости',
        ));
      } else {
        print("_tryLoadFromNetwork - ошибка при запросе, кэша нет");
        emit(state.copyWith(
          status: NewsListStatus.failure,
          isRefreshing: false,
          errorMessage: 'Не удалось загрузить новости. Попробуйте еще раз.',
        ));
      }
      await _tryLoadCache();

    }


  }

  Future<void> init() async {
    await _tryLoadCache();
    await _tryLoadFromNetwork();
  }

  Future<void> refreshNews() async {
    await _tryLoadFromNetwork();
  }
}
