// lib/app/news_list/news_list_page.dart

import 'package:flutter/material.dart';
import 'package:lr4/app/news_list/widgets/news_card.dart';
import 'package:lr4/domain/model/news_model.dart';
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

  // Future<void> _fetchNews() async {
    
  //   final networkService = context.read<NetworkService>();
  //   final isConnected = await networkService.isConnected();
    
  //   if (!isConnected) {
  //     setState(() {
  //       _isNetworkError = true;
  //       _newsListFuture = Future.error('Network Unavailable'); // Задаем Future с ошибкой
  //     });
  //     return;
  //   }

  //   // Если есть сеть, сбрасываем ошибку сети и делаем запрос
  //   setState(() {
  //     _isNetworkError = false;
  //     _newsListFuture = context.read<NewsRepository>().getNewsList();
  //   });
    
  // }

  Future<void> _fetchNews() async {
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
      _newsListFuture = context.read<NewsRepository>().getNewsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent, 
      ),
      body: RefreshIndicator( 
        onRefresh: _fetchNews,
        child: FutureBuilder<List<NewsModel>>(
          future: _newsListFuture,
          builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
            
            if (_isNetworkError) {
              return ErrorView(
                message: 'Нет подключения к интернету. Проверьте настройки сети.',
                onRetry: _fetchNews,
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
                onRetry: _fetchNews,
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























// // lib/app/news_list/news_list_page.dart

// import 'package:flutter/material.dart';
// import 'package:lr4/app/news_list/widgets/news_card.dart';
// import 'package:lr4/domain/model/news_model.dart';
// import 'package:lr4/domain/repository/news_repository.dart';
// import 'package:provider/provider.dart';

// class NewsListPage extends StatefulWidget {
//   const NewsListPage({super.key});

//   @override
//   State<NewsListPage> createState() => _NewsListPageState();
// }

// class _NewsListPageState extends State<NewsListPage> {
//   // 1. Объявляем Future
//   late Future<List<NewsModel>> _newsListFuture;

//   @override
//   void initState() {
//     super.initState();
//     // 2. Инициализируем Future, используя репозиторий
//     _newsListFuture = context.read<NewsRepository>().getNewsList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Новости'),
//         automaticallyImplyLeading: false,
//         surfaceTintColor: Colors.transparent, // Для красоты (из вашего кода)
//       ),
//       // 3. Используем FutureBuilder для отображения состояния загрузки
//       body: FutureBuilder<List<NewsModel>>(
//         future: _newsListFuture,
//         builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
//           // Загрузка
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final List<NewsModel>? data = snapshot.data;

//           // Ошибка или пустой список
//           if (snapshot.hasError || data == null || data.isEmpty) {
//             return Center(
//                 child: Text(snapshot.hasError ? 'Ошибка загрузки новостей' : 'Новостей нет'));
//           }
          
//           // Успешная загрузка
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (BuildContext context, int index) {
//               final NewsModel news = data[index];

//               return Padding(
//                 key: ValueKey(news.link), // Ключ для оптимизации (из вашего кода)
//                 padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
//                 child: NewsCard(model: news),
//               );
//             },
//             padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:lr4/app/news_list/widgets/news_card.dart';
// import 'package:lr4/domain/model/news_model.dart';
// import 'package:lr4/domain/repository/news_repository.dart'; //
// import 'package:provider/provider.dart';

// class NewsListPage extends StatefulWidget {
//   const NewsListPage({super.key});

//   @override
//   State<NewsListPage> createState() => _NewsListPageState();
// }

// class _NewsListPageState extends State<NewsListPage> {
//   late Future<List<NewsModel>> _newsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _newsFuture = context.read<NewsRepository>().getNewsList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Новости'), automaticallyImplyLeading: false),
//       body: FutureBuilder<List<NewsModel>>(
//         future: _newsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//              return const Center(child: Text('Новостей нет'));
//           }
          
//           final newsList = snapshot.data!;
//           return ListView.separated(
//              padding: const EdgeInsets.all(22),
//              itemCount: newsList.length,
//              separatorBuilder: (_, __) => const SizedBox(height: 16),
//              itemBuilder: (context, index) => NewsCard(model: newsList[index]),
//           );
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:lr4/app/news_list/widgets/news_card.dart';

// class NewsListPage extends StatelessWidget {
//   const NewsListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Новости'),
//         automaticallyImplyLeading: false,
//       ),
//       // Используем ListView.separated
//       body: ListView.separated(
//         // Добавляем отступы вокруг всего списка
//         padding: const EdgeInsets.fromLTRB(22, 16, 22, 16), 
//         // Определяем, сколько элементов в списке
//         itemCount: 5, 
//         // Определяем разделитель (отступ между элементами)
//         separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
//         // Определяем, как строить каждый элемент
//         itemBuilder: (BuildContext context, int index) {
//           return const NewsCard();
//         },
//       ),
//     );
//   }
// }