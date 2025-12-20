import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:lr4/app/news_list/news_list_state.dart';
import 'package:lr4/domain/datasource/preference_datasource.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:lr4/domain/repository/news_repository.dart';
import 'package:lr4/domain/service/logger_service.dart';
import 'package:lr4/domain/service/network_service.dart';

class NewsListCubit extends Cubit<NewsListState> {
  final NewsRepository _repository;
  final NetworkService _networkService;
  final PreferenceDatasource _preferenceDatasource;
  static final Logger _logger = LoggerService.getCubitLogger('NewsList');

  // Флаги для имитации ошибок (можно вынести в конфиг)
  static const bool simulateNetworkError = false;
  static const bool simulateServerError = false;

  NewsListCubit({
    required NewsRepository repository,
    required NetworkService networkService,
    required PreferenceDatasource preferenceDatasource,
  })  : _repository = repository,
        _networkService = networkService,
        _preferenceDatasource = preferenceDatasource,
        super(const NewsListState()) {
    init();
  }

  Future<void> _tryLoadCache() async {
    final cachedNews = await _repository.getCachedNewsList();
    _logger
        .info("_tryLoadCache Получено: ${cachedNews.length} новостей из кэша");
    if (cachedNews.isNotEmpty) {
      final lastUpdated = await _repository.getLastUpdate();
      _logger.info(
          "_tryLoadCache Отображены: ${cachedNews.length} новостей из кэша");
      emit(state.copyWith(
        allNews: cachedNews,
        lastUpdateTime: lastUpdated,
      ));
      return;
    }

    emit(state.copyWith(
      allNews: [],
    ));
    emit(state.clearLastUpdateTime());

    _logger.info("_tryLoadCache кэш пустой: новости берем из сети");
  }

  Future<void> _tryLoadFromNetwork() async {
    if (_preferenceDatasource.selectedDatasource == DataSource.drift ||
        _preferenceDatasource.selectedDatasource == DataSource.sqfLite) {
      return;
    }

    emit(state.copyWith(
      status: NewsListStatus.loading,
    ));
    final isConnected =
        simulateNetworkError ? false : await _networkService.isConnected();
    _logger.info("_tryLoadFromNetwork состояние сети: $isConnected");

    if (!isConnected) {
      // Если нет сети, но есть кэшированные данные - показываем их
      if (state.allNews.isNotEmpty) {
        _logger.info("Сети нет, но был кэш");
        emit(state.copyWith(
          status: NewsListStatus.networkError,
          errorMessage: 'Нет подключения к интернету',
        ));
      } else {
        _logger.info("Сети нет и кэша тоже");
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
      _logger.info("_tryLoadFromNetwork - начинается загрузка");
      final List<NewsModel> result = await _repository.getNewsList();
      if (result.isEmpty) {
        throw "Ошибка получения данных";
      }
      _logger.info("_tryLoadFromNetwork - получено ${result.length} новостей");
      await _repository.saveNewsList(result);
      _logger.info("_tryLoadFromNetwork - новости сохранены в кэш");
      emit(state.copyWith(
        status: NewsListStatus.success,
        allNews: result,
        isRefreshing: false,
        errorMessage: null,
      ));
      emit(state.clearLastUpdateTime());

      _logger.info("_tryLoadFromNetwork - завершно с успхеом");
    } catch (e) {
      if (state.allNews.isNotEmpty) {
        _logger.info("_tryLoadFromNetwork - ошибка при запросе, но есть кэш");
        emit(state.copyWith(
          status: NewsListStatus.failure,
          isRefreshing: false,
          errorMessage: 'Не удалось обновить новости',
        ));
      } else {
        _logger.info("_tryLoadFromNetwork - ошибка при запросе, кэша нет");
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
    await _tryLoadCache();
    await _tryLoadFromNetwork();
  }
}
