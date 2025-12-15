
// lib/app/currency_list/currency_list_page.dart


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lr4/app/currency_list/currency_list_cubit.dart';
import 'package:lr4/app/currency_list/currency_list_state.dart';
import 'package:lr4/app/currency_list/widgets/currency_card.dart';
import 'package:lr4/app/currency_list/widgets/search_view.dart';
import 'package:lr4/app/app_routes.dart';
import 'package:lr4/domain/repository/currency_repository.dart';

import 'package:lr4/app/widgets/error_view.dart'; 
import 'package:lr4/domain/service/network_service.dart';


class CurrencyListPage extends StatelessWidget {
  const CurrencyListPage({super.key});

  // Вспомогательный метод для удобства
  void _loadCurrencies(BuildContext context) {
    context.read<CurrencyListCubit>().loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrencyListCubit(
        repository: context.read<CurrencyRepository>(),
        networkService: context.read<NetworkService>(),
      )..loadCurrencies(), // Запускаем загрузку сразу
      
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Курс Валют'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ),
        body: BlocBuilder<CurrencyListCubit, CurrencyListState>(
          builder: (context, state) {
            if (state.status == CurrencyListStatus.networkError) {
               return ErrorView(
                 message: 'Нет подключения к интернету. Проверьте настройки сети.',
                 onRetry: () => _loadCurrencies(context),
               );
            }
            
            // 1. Если произошла ошибка и нет данных для отображения (первая загрузка)
            if (state.status == CurrencyListStatus.failure && state.allCurrencies.isEmpty) {
               return ErrorView(
                 message: 'Не удалось загрузить курсы валют. Проверьте подключение.',
                 onRetry: () => _loadCurrencies(context),
               );
            }
            // 2. Если данные еще грузятся и нет данных
            if (state.status == CurrencyListStatus.loading && state.allCurrencies.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            // 3. Если данных нет
            if (state.allCurrencies.isEmpty) {
                return const Center(child: Text('Список пуст'));
            }

            // 4. Успешная загрузка или идет обновление (state.allCurrencies.isNotEmpty)
            return Column(
              children: [
                // Поиск
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
                  child: SearchView(
                    onChanged: (query) => context.read<CurrencyListCubit>().filterCurrencies(query), 
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Вызываем Cubit для повторной загрузки
                      await context.read<CurrencyListCubit>().loadCurrencies();
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final data = state.filteredCurrencies;
                        final isWide = constraints.maxWidth > 500;
                        
                        if (isWide) {
                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: data.length,
                              itemBuilder: (context, index) => CurrencyCard(model: data[index]),
                            );
                        }
                        
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          itemCount: data.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                              return CurrencyCard(model: data[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

























// // lib/app/currency_list/currency_list_page.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // <--- НОВЫЙ ИМПОРТ
// import 'package:lr4/app/currency_list/currency_list_cubit.dart'; // <--- НОВЫЙ ИМПОРТ
// import 'package:lr4/app/currency_list/currency_list_state.dart'; // <--- НОВЫЙ ИМПОРТ
// import 'package:lr4/app/currency_list/widgets/currency_card.dart';
// import 'package:lr4/app/currency_list/widgets/search_view.dart';
// import 'package:lr4/app/app_routes.dart';
// import 'package:lr4/domain/repository/currency_repository.dart'; //

// class CurrencyListPage extends StatelessWidget {
//   const CurrencyListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Внедряем Cubit локально, если он не внедрен выше
//     // Это использует CurrencyRepository, который уже должен быть доступен
//     return BlocProvider(
//       create: (context) => CurrencyListCubit(
//         repository: context.read<CurrencyRepository>(),
//       )..loadCurrencies(), // Запускаем загрузку сразу после создания Cubit
      
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Курс Валют'),
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
//           ),
//         ),
//         // Заменяем FutureBuilder и ValueListenableBuilder на BlocBuilder
//         body: BlocBuilder<CurrencyListCubit, CurrencyListState>(
//           builder: (context, state) {
//             // 1. Если данные еще грузятся
//             if (state.status == CurrencyListStatus.loading && state.allCurrencies.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             // 2. Если произошла ошибка
//             if (state.status == CurrencyListStatus.failure) {
//                return const Center(child: Text('Ошибка загрузки данных'));
//             }
//             // 3. Если данных нет или список пуст
//             if (state.allCurrencies.isEmpty) {
//                 return const Center(child: Text('Список пуст'));
//             }

//             // 4. Успешная загрузка - показываем контент
//             return Column(
//               children: [
//                 // Поиск
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
//                   child: SearchView(
//                     // Вызываем метод Cubit для фильтрации
//                     onChanged: (query) => context.read<CurrencyListCubit>().filterCurrencies(query), 
//                   ),
//                 ),
//                 Expanded(
//                   // Используем отфильтрованный список из состояния
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       final data = state.filteredCurrencies;
//                       final isWide = constraints.maxWidth > 500;
                      
//                       if (isWide) {
//                           return GridView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//                             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               childAspectRatio: 2.5,
//                               mainAxisSpacing: 10,
//                               crossAxisSpacing: 10,
//                             ),
//                             itemCount: data.length,
//                             itemBuilder: (context, index) => CurrencyCard(model: data[index]),
//                           );
//                       }
                      
//                       return ListView.separated(
//                         padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//                         itemCount: data.length,
//                         separatorBuilder: (_, __) => const SizedBox(height: 10),
//                         itemBuilder: (context, index) {
//                             return CurrencyCard(model: data[index]);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


















// import 'package:flutter/material.dart';
// import 'package:lr4/app/currency_list/widgets/currency_card.dart';
// import 'package:lr4/app/currency_list/widgets/search_view.dart';
// import 'package:lr4/app/app_routes.dart';
// import 'package:lr4/domain/model/currency_model.dart'; //
// import 'package:lr4/domain/repository/currency_repository.dart'; //
// import 'package:provider/provider.dart';

// class CurrencyListPage extends StatefulWidget {
//   const CurrencyListPage({super.key});

//   @override
//   State<CurrencyListPage> createState() => _CurrencyListPageState();
// }

// class _CurrencyListPageState extends State<CurrencyListPage> {
//   // Для поиска
//   late final ValueNotifier<List<CurrencyModel>> _filteredCurrencies;
//   // Для загрузки данных
//   late Future<List<CurrencyModel>> _currencyListFuture;
  
//   List<CurrencyModel> _allCurrencies = [];

//   @override
//   void initState() {
//     super.initState();
//     // Инициализация загрузки
//     _initData();
//   }

//   void _initData() {
//     // Получаем репозиторий через context и вызываем метод загрузки
//     _currencyListFuture = context.read<CurrencyRepository>().getCurrencyList().then((value) {
//       _allCurrencies = value;
//       // Изначально отфильтрованный список равен полному списку
//       _filteredCurrencies = ValueNotifier(value);
//       return value;
//     });
//   }
  
//   // Логика поиска
//   void _filterCurrencies(String query) {
//     final lowerQuery = query.toLowerCase();
//     final result = _allCurrencies.where((currency) {
//       return currency.name.toLowerCase().contains(lowerQuery) || 
//              currency.symbol.toLowerCase().contains(lowerQuery);
//     }).toList();
    
//     _filteredCurrencies.value = result;
//   }

//   @override
//   void dispose() {
//     _filteredCurrencies.dispose(); // Не забываем очищать
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Курс Валют'),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.settings, color: Colors.black),
//           onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
//         ),
//       ),
//       body: FutureBuilder<List<CurrencyModel>>(
//         future: _currencyListFuture,
//         builder: (context, snapshot) {
//           // 1. Если данные еще грузятся
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           // 2. Если произошла ошибка
//           if (snapshot.hasError) {
//              return Center(child: Text('Ошибка: ${snapshot.error}'));
//           }
//           // 3. Если данных нет или список пуст
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//              return const Center(child: Text('Список пуст'));
//           }

//           // 4. Успешная загрузка - показываем контент
//           return Column(
//             children: [
//               // Поиск
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
//                 child: SearchView(onChanged: _filterCurrencies), // Обнови SearchView (ниже код)
//               ),
//               Expanded(
//                 child: ValueListenableBuilder<List<CurrencyModel>>(
//                   valueListenable: _filteredCurrencies,
//                   builder: (context, data, _) {
//                     // Используем GridView для широких экранов и List для узких (твоя логика)
//                     return LayoutBuilder(
//                       builder: (context, constraints) {
//                         final isWide = constraints.maxWidth > 500;
                        
//                         if (isWide) {
//                            return GridView.builder(
//                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                crossAxisCount: 2,
//                                childAspectRatio: 2.5,
//                                mainAxisSpacing: 10,
//                                crossAxisSpacing: 10,
//                              ),
//                              itemCount: data.length,
//                              itemBuilder: (context, index) => CurrencyCard(model: data[index]),
//                            );
//                         }
                        
//                         return ListView.separated(
//                           padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//                           itemCount: data.length,
//                           separatorBuilder: (_, __) => const SizedBox(height: 10),
//                           itemBuilder: (context, index) {
//                              return CurrencyCard(model: data[index]);
//                           },
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:lr4/app/currency_list/widgets/currency_card.dart';
// import 'package:lr4/app/currency_list/widgets/search_view.dart';
// import 'package:lr4/app/app_routes.dart';

// class CurrencyListPage extends StatelessWidget {
//   const CurrencyListPage({super.key});

//   // 20 уникальных названий валют
//   final List<Map<String, dynamic>> _uniqueData = const [
//     {'title': 'Доллар США', 'rate': '90.25', 'isGrowing': false, 'subtitle': '1 USD'},
//     {'title': 'Евро', 'rate': '98.50', 'isGrowing': true, 'subtitle': '1 EUR'},
//     {'title': 'Японская Йена', 'rate': '0.625', 'isGrowing': true, 'subtitle': '100 JPY'},
//     {'title': 'Фунт стерлингов', 'rate': '110.62', 'isGrowing': true, 'subtitle': '1 GBP'},
//     {'title': 'Швейцарский франк', 'rate': '102.15', 'isGrowing': true, 'subtitle': '1 CHF'},
//     {'title': 'Китайский юань', 'rate': '12.45', 'isGrowing': true, 'subtitle': '1 CNY'},
//     {'title': 'Индийская рупия', 'rate': '1.08', 'isGrowing': true, 'subtitle': '10 INR'},
//     {'title': 'Австралийский доллар', 'rate': '60.99', 'isGrowing': true, 'subtitle': '1 AUD'},
//     {'title': 'Канадский доллар', 'rate': '65.80', 'isGrowing': false, 'subtitle': '1 CAD'},
//     {'title': 'Польский злотый очен длиииииииииный текст для провверки работы программного кода из 3 строк ', 'rate': '23.85', 'isGrowing': true, 'subtitle': '1 PLN'},
//     {'title': 'Бразильский реал', 'rate': '17.50', 'isGrowing': true, 'subtitle': '1 BRL'},
//     {'title': 'Шведская крона', 'rate': '8.55', 'isGrowing': true, 'subtitle': '1 SEK'},
//     {'title': 'Норвежская крона', 'rate': '8.22', 'isGrowing': true, 'subtitle': '1 NOK'},
//     {'title': 'Мексиканское песо', 'rate': '4.88', 'isGrowing': true, 'subtitle': '10 MXN'},
//     {'title': 'Южнокорейская вона', 'rate': '0.065', 'isGrowing': true, 'subtitle': '100 KRW'},
//     {'title': 'Сингапурский доллар', 'rate': '67.40', 'isGrowing': false, 'subtitle': '1 SGD'},
//     {'title': 'Гонконгский доллар', 'rate': '11.60', 'isGrowing': true, 'subtitle': '1 HKD'},
//     {'title': 'Турецкая лира', 'rate': '2.95', 'isGrowing': true, 'subtitle': '10 TRY'},
//     {'title': 'Южноафриканский рэнд', 'rate': '4.80', 'isGrowing': true, 'subtitle': '10 ZAR'},
//     {'title': 'Новозеландский доллар', 'rate': '57.10', 'isGrowing': false, 'subtitle': '1 NZD'},
//     {'title': 'Польский злотый', 'rate': '23.85', 'isGrowing': true, 'subtitle': '1 PLN'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Генерация списка из 20 элементов
//     final int targetCount = _uniqueData.length;
//     final List<Map<String, dynamic>> currencyData = List.generate(targetCount, (index) {
//       final base = _uniqueData[index];

//       bool newIsGrowing = index % 3 != 0;
//       final List<int> selectedIndices = [0, 1, 4, 7, 8, 10, 12, 14, 16, 18, 19, 20];
//       String? newSubtitle = selectedIndices.contains(index) ? base['subtitle'] as String? : null;

//       return {
//         'currencyCode': (base['subtitle'] as String).split(' ').last, 
//         'title': base['title'] as String,
//         // Вариация курса
//         'rate': (double.parse(base['rate'] as String) + (index % 5) * 0.05).toStringAsFixed(3).substring(0, 5),
//         'isGrowing': newIsGrowing,
//         'subtitle': newSubtitle,
//       };
//     });

//     return Scaffold(
//       appBar: AppBar(title: const Text('Курс Валют'),
//       automaticallyImplyLeading: false,
//       leading: IconButton(
//           icon: const Icon(Icons.settings, color: Colors.black),
//           onPressed: () {
//             Navigator.pushNamed(context, AppRoutes.settings);
//           },
//         ),
//       actions: [],
//       ),

//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final bool isWideScreen = constraints.maxWidth > 500;
//           double childAspectRatio = 2.5; // Базовое значение для ширины 500-700
//           if (constraints.maxWidth > 700) {
//             childAspectRatio = 4; // Увеличиваем для ширины >700, карточки ниже 
//           }
//           return Column(
//             children: [
//               // Поле поиска с горизонтальными отступами
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
//                 child: const SearchView(),
//               ),
//               // Устранение ошибки переполнения
//               Expanded(
//                 child: Scrollbar(
//                   child: isWideScreen
//                     ? GridView.builder(
//                         // Отступы только для содержимого (горизонтальные для карточек, вертикальные для прокрутки)
//                         padding: const EdgeInsets.symmetric(horizontal: 22).copyWith(bottom: 40),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           mainAxisSpacing: 10,
//                           crossAxisSpacing: 10,
//                           childAspectRatio: childAspectRatio, // Динамическое значение в зависимости от ширины
//                         ),
//                         itemCount: currencyData.length,
//                         itemBuilder: (context, i) {
//                           final data = currencyData[i];
//                           // Логика "Избранное": четный индекс - закрашенная звезда
//                           final bool isFavorite = i % 2 == 0;

//                           return CurrencyCard(
//                             currencyCode: data['currencyCode'] as String,
//                             title: data['title'] as String,
//                             rate: data['rate'] as String,
//                             isGrowing: data['isGrowing'] as bool,
//                             subtitle: data['subtitle'] as String?,
//                             isFavorite: isFavorite,
//                           );
//                         },
//                       )
//                     : ListView.builder(
//                         // Отступы только для содержимого (горизонтальные для карточек, вертикальные для прокрутки)
//                         padding: const EdgeInsets.symmetric(horizontal: 22).copyWith(bottom: 40),
//                         itemCount: currencyData.length,
//                         itemBuilder: (context, i) {
//                           final data = currencyData[i];
//                           // Логика "Избранное": четный индекс - закрашенная звезда
//                           final bool isFavorite = i % 2 == 0;

//                           return Padding(
//                             // Отступ между карточками
//                             padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
//                             child: CurrencyCard(
//                               currencyCode: data['currencyCode'] as String,
//                               title: data['title'] as String,
//                               rate: data['rate'] as String,
//                               isGrowing: data['isGrowing'] as bool,
//                               subtitle: data['subtitle'] as String?,
//                               isFavorite: isFavorite,
//                             ),
//                           );
//                         },
//                       ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }