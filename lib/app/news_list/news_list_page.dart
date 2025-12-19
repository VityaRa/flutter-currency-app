// lib/app/news_list/news_list_page.dart

import 'package:flutter/material.dart';
import 'package:lr4/app/news_list/widgets/news_card.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/repository/news_repository.dart';
import 'package:provider/provider.dart';

import 'package:lr4/app/widgets/error_view.dart'; 
import 'package:lr4/domain/service/network_service.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<NewsModel>> _newsListFuture;
  List<NewsModel>? _cachedNews; // Кэшированные локальные данные

  // Дополнительное поле для ошибки сети
  bool _isNetworkError = false;

  // КОСТЫЛИ ДЛЯ CHROME 
  // true - отсутствие сети
  static const bool _simulateNetworkError = false; 
  // true - ошибка сервера (статус 500)
  static const bool _simulateServerError = false;

  @override
  void initState() {
    super.initState();
    _loadNewsWithCacheFirst(); // Загружаем данные с кэшированием
  }

  // Метод для загрузки данных с приоритетом локальных данных
  Future<void> _loadNewsWithCacheFirst() async {
    // 1. Сначала загружаем локальные данные
    try {
      final cachedData = await context.read<NewsRepository>().getCachedNewsList();
      if (cachedData != null && cachedData.isNotEmpty) {
        print("Загружены закешированные статьи");
        setState(() {
          _cachedNews = cachedData;
        });
      }
    } catch (e) {
      // Игнорируем ошибки при загрузке кэша
      print('Ошибка загрузки кэшированных новостей: $e');
    }

    // 2. Затем пытаемся загрузить свежие данные из сети
    _fetchFreshNews();
  }

  Future<void> _fetchFreshNews() async {
    final newsRepository = context.read<NewsRepository>();
    final networkService = context.read<NetworkService>();
    
    // ИМИТАЦИЯ ОШИБКИ СЕТИ 
    final isConnected = _simulateNetworkError ? false : await networkService.isConnected();
    
    if (!isConnected) {
      setState(() {
        _isNetworkError = true;
        _newsListFuture = Future.error('Network Unavailable');
      });
      return;
    }
    
    // ИМИТАЦИЯ ОШИБКИ СЕРВЕРА
    if (_simulateServerError) {
      setState(() {
        _isNetworkError = false;
        _newsListFuture = Future.error('Server Error');
      });
      return;
    }

    // Если есть сеть и нет имитации ошибки сервера - загружаем свежие данные
    setState(() {
      _isNetworkError = false;
      _newsListFuture = _loadAndCacheNews();
    });
  }

  // Метод для загрузки и кэширования данных
  Future<List<NewsModel>> _loadAndCacheNews() async {
    try {
      // 1. Получаем данные из репозитория
      final newsList = await context.read<NewsRepository>().getNewsList();
      
      // 2. Сохраняем данные локально
      await context.read<NewsRepository>().saveNewsList(newsList);
      
      // 3. Обновляем кэш
      setState(() {
        _cachedNews = newsList;
      });
      
      // 4. Возвращаем данные для отображения
      return newsList;
    } catch (e) {
      // Если ошибка сети, но есть кэшированные данные - показываем их
      if (_cachedNews != null && _cachedNews!.isNotEmpty) {
        return _cachedNews!;
      }
      // Пробрасываем ошибку дальше для обработки в FutureBuilder
      rethrow;
    }
  }

  // Метод для обновления данных (используется в RefreshIndicator)
  Future<void> _refreshData() async {
    // Сбрасываем Future чтобы обновить данные
    setState(() {
      _newsListFuture = _loadAndCacheNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        automaticallyImplyLeading: false,
        surfaceTintColor: colors.appBarSurfaceTint, 
      ),
      body: RefreshIndicator( 
        onRefresh: _refreshData,
        child: FutureBuilder<List<NewsModel>>(
          future: _newsListFuture,
          builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
            
            if (_isNetworkError) {
              // Если нет сети, но есть кэшированные данные - показываем их
              if (_cachedNews != null && _cachedNews!.isNotEmpty) {
                return Column(
                  children: [
                    // Баннер с предупреждением об отсутствии сети
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.orange[100],
                      child: Row(
                        children: [
                          Icon(Icons.wifi_off, color: Colors.orange[800]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Нет подключения к интернету. Показаны ранее загруженные новости',
                              style: TextStyle(color: Colors.orange[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Список кэшированных новостей
                    Expanded(
                      child: _buildNewsList(_cachedNews!),
                    ),
                  ],
                );
              }
              
              // Если нет сети И нет кэша
              return ErrorView(
                message: 'Нет подключения к интернету. Проверьте настройки сети.',
                onRetry: () async {
                  setState(() {
                    _newsListFuture = _loadAndCacheNews();
                  });
                },
              );
            }

            // Показываем кэшированные данные во время загрузки
            if (snapshot.connectionState == ConnectionState.waiting) {
              if (_cachedNews != null && _cachedNews!.isNotEmpty) {
                return Column(
                  children: [
                    // Индикатор обновления поверх кэшированных данных
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.blue[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Обновление новостей...',
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                    // Список кэшированных новостей
                    Expanded(
                      child: _buildNewsList(_cachedNews!),
                    ),
                  ],
                );
              }
              
              // Если нет кэша - показываем обычный индикатор загрузки
              return const Center(child: CircularProgressIndicator());
            }

            final List<NewsModel>? freshData = snapshot.data;
            
            // Ошибка загрузки свежих данных
            if (snapshot.hasError) {
              // Если есть кэшированные данные - показываем их с ошибкой
              if (_cachedNews != null && _cachedNews!.isNotEmpty) {
                return Column(
                  children: [
                    // Баннер с ошибкой
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.red[50],
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[800]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Не удалось загрузить новые новости. Показаны ранее загруженные',
                              style: TextStyle(color: Colors.red[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Список кэшированных новостей
                    Expanded(
                      child: _buildNewsList(_cachedNews!),
                    ),
                  ],
                );
              }
              
              // Если нет кэша - показываем полноценный экран ошибки
              return ErrorView( 
                message: 'Не удалось загрузить новости. Попробуйте еще раз.',
                onRetry: () async {
                  setState(() {
                    _newsListFuture = _loadAndCacheNews();
                  });
                },
              );
            }
            
            // Успешная загрузка свежих данных
            if (freshData == null || freshData.isEmpty) {
              // Если нет свежих данных, но есть кэш - показываем кэш
              if (_cachedNews != null && _cachedNews!.isNotEmpty) {
                return _buildNewsList(_cachedNews!);
              }
              return const Center(child: Text('Новостей нет'));
            }
            
            // Показываем свежие данные
            return _buildNewsList(freshData);
          },
        ),
      ),
    );
  }

  // Вспомогательный метод для построения списка новостей
  Widget _buildNewsList(List<NewsModel> newsList) {
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (BuildContext context, int index) {
        final NewsModel news = newsList[index];

        return Padding(
          key: ValueKey(news.link),
          padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
          child: NewsCard(model: news),
        );
      },
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
    );
  }
}