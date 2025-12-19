// lib/app/currency_list/currency_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lr4/app/currency_list/currency_list_cubit.dart';
import 'package:lr4/app/currency_list/currency_list_state.dart';
import 'package:lr4/app/currency_list/widgets/currency_card.dart';
import 'package:lr4/app/currency_list/widgets/search_view.dart';
import 'package:lr4/app/app_routes.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
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
    final ThemeColors colors = context.colors;

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
            icon: Icon(Icons.settings, color: colors.black),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ),
        body: BlocConsumer<CurrencyListCubit, CurrencyListState>(
          listener: (context, state) {
            // Можно добавить обработку каких-либо событий при изменении состояния
          },
          builder: (context, state) {
            // Получаем Cubit для доступа к методам
            final cubit = context.read<CurrencyListCubit>();
            
            // Флаг, показывающий что данные были загружены ранее (есть кэш)
            final hasCachedData = state.allCurrencies.isNotEmpty;
            if (hasCachedData) {
              print("Есть кэш");
            }
            
            // 1. Ошибка сети при первой загрузке (нет кэшированных данных)
            if (state.status == CurrencyListStatus.networkError && !hasCachedData) {
               return ErrorView(
                 message: 'Нет подключения к интернету. Проверьте настройки сети.',
                 onRetry: () => _loadCurrencies(context),
               );
            }
            
            // 2. Ошибка сети, но есть кэшированные данные
            if (state.status == CurrencyListStatus.networkError && hasCachedData) {
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
                            'Нет подключения к интернету. Показаны ранее загруженные курсы',
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Поиск и список кэшированных данных
                  _buildContentWithSearch(context, state, colors, showRefresh: false),
                ],
              );
            }
            
            // 3. Ошибка сервера при первой загрузке (нет кэшированных данных)
            if (state.status == CurrencyListStatus.failure && !hasCachedData) {
               return ErrorView(
                 message: 'Не удалось загрузить курсы валют. Провробуйте еще раз.',
                 onRetry: () => _loadCurrencies(context),
               );
            }
            
            // 4. Ошибка сервера, но есть кэшированные данные
            if (state.status == CurrencyListStatus.failure && hasCachedData) {
              return Column(
                children: [
                  // Баннер с ошибкой сервера
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.red[50],
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[800]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Не удалось загрузить новые курсы. Показаны ранее загруженные',
                            style: TextStyle(color: Colors.red[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Поиск и список кэшированных данных
                  _buildContentWithSearch(context, state, colors, showRefresh: false),
                ],
              );
            }
            
            // 5. Загрузка при первой загрузке (нет кэшированных данных)
            if (state.status == CurrencyListStatus.loading && !hasCachedData) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // 6. Загрузка новых данных при наличии кэшированных
            if (state.status == CurrencyListStatus.loading && hasCachedData) {
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
                          'Обновление курсов...',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Поиск и список кэшированных данных
                  _buildContentWithSearch(context, state, colors, showRefresh: false),
                ],
              );
            }
            
            // 7. Если данных нет (даже после успешной загрузки)
            if (state.allCurrencies.isEmpty) {
              return const Center(child: Text('Список пуст'));
            }

            // 8. Успешная загрузка или отображение кэшированных данных
            return _buildContentWithSearch(context, state, colors, showRefresh: true);
          },
        ),
      ),
    );
  }
  
  // Вспомогательный метод для построения контента с поиском
  Widget _buildContentWithSearch(
    BuildContext context, 
    CurrencyListState state, 
    ThemeColors colors,
    {required bool showRefresh}
  ) {
    final cubit = context.read<CurrencyListCubit>();
    final data = state.filteredCurrencies;
    
    return Column(
      children: [
        // Поиск
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
          child: SearchView(
            onChanged: (query) => cubit.filterCurrencies(query), 
          ),
        ),
        Expanded(
          child: showRefresh 
            ? RefreshIndicator(
                onRefresh: () async {
                  // Вызываем Cubit для повторной загрузки
                  await cubit.loadCurrencies();
                },
                child: _buildCurrencyList(data, context),
              )
            : _buildCurrencyList(data, context),
        ),
      ],
    );
  }
  
  // Вспомогательный метод для построения списка валют
  Widget _buildCurrencyList(List<dynamic> data, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
    );
  }
}