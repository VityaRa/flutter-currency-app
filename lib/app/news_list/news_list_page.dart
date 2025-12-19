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

  // Дополнительное поле для ошибки сети
  bool _isNetworkError = false;

  //  КОСТЫЛИ ДЛЯ CHROME 
  // true - отсутствие сети
  static const bool _simulateNetworkError = false; 
  // true - ошибка сервера (статус 500)
  static const bool _simulateServerError = false;

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Выделяем инициализацию в отдельный метод
  }

  Future<void> _fetchNews() async {
    final newsRepository = context.read<NewsRepository>();
    // 1. Имитация задержки
    await Future.delayed(const Duration(seconds: 1)); // Имитируем задержку в 1 секунду

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

    // Если есть сеть и нет имитации ошибки сервера - настоящий запрос
    setState(() {
      _isNetworkError = false;
      _newsListFuture = newsRepository.getNewsList();
    });
  }

    // Метод для обработки успешно загруженных данных
  Future<List<NewsModel>> _loadNewsWithSave() async {
    try {
      // Получаем данные из репозитория
      final newsList = await context.read<NewsRepository>().getNewsList();
      
      // Сохраняем данные локально
      await context.read<NewsRepository>().saveNewsList(newsList);
      
      // Возвращаем данные для отображения
      return newsList;
    } catch (e) {
      // Пробрасываем ошибку дальше для обработки в FutureBuilder
      rethrow;
    }
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
        onRefresh: _fetchNews,
        child: FutureBuilder<List<NewsModel>>(
          future: _newsListFuture,
          builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
            
            if (_isNetworkError) {
              return ErrorView(
                message: 'Нет подключения к интернету. Проверьте настройки сети.',
                onRetry: () async {
                  // При повторе также используем метод с сохранением
                  setState(() {
                    _newsListFuture = _loadNewsWithSave();
                  });
                },
              );
            }

            // Загрузка
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<NewsModel>? data = snapshot.data;
            
            // Ошибка
            if (snapshot.hasError) {
              return ErrorView( 
                message: 'Не удалось загрузить новости. Попробуйте еще раз.',
                onRetry: () async {
                  // При повторе также используем метод с сохранением
                  setState(() {
                    _newsListFuture = _loadNewsWithSave();
                  });
                },
              );
            }
            
            // Пустой список
            if (data == null || data.isEmpty) {
              return const Center(child: Text('Новостей нет'));
            }
            
            // Успешная загрузка
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final NewsModel news = data[index];

                return Padding(
                  key: ValueKey(news.link),
                  padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
                  child: NewsCard(model: news),
                );
              },
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
            );
          },
        ),
      ),
    );
  }
}