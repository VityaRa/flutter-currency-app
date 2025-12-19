
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