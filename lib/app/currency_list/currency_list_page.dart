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
      ),
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
            if (state.allCurrencies.isNotEmpty) {
              return _buildContent(context, state, colors);
            }
            // Обработка различных состояний
            if (state.status == CurrencyListStatus.networkError) {
              return ErrorView(
                message:
                    'Нет подключения к интернету. Проверьте настройки сети.',
                onRetry: () => _loadCurrencies(context),
              );
            }

            if (state.status == CurrencyListStatus.failure &&
                state.allCurrencies.isEmpty) {
              return ErrorView(
                message: 'Не удалось загрузить курсы валют.',
                onRetry: () => _loadCurrencies(context),
              );
            }

            // Показываем кэшированные данные сразу
            if (state.allCurrencies.isNotEmpty) {
              return _buildContent(context, state, colors);
            }

            // Если данных нет и идет загрузка
            if (state.status == CurrencyListStatus.loading) {
              // return const Center(child: CircularProgressIndicator());
            }

            // Если данных вообще нет
            if (state.allCurrencies.isEmpty &&
                state.status != CurrencyListStatus.loading &&
                state.status != CurrencyListStatus.refreshing) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Нет данных о валютах',
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _loadCurrencies(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Повторить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
            // Если данных вообще нет
            return const Center(child: Text('Нет данных о валютах'));
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, CurrencyListState state, ThemeColors colors) {
    return Column(
      children: [
        // Заголовок с индикатором обновления
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
          child: Row(
            children: [
              Expanded(
                child: SearchView(
                  onChanged: (query) =>
                      context.read<CurrencyListCubit>().filterCurrencies(query),
                ),
              ),
              // if (state.isRefreshing)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 8.0),
              //     child: SizedBox(
              //       width: 24,
              //       height: 24,
              //       child: CircularProgressIndicator(
              //         strokeWidth: 2,
              //         color: colors.primary,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),

        // Информация о последнем обновлении
        if (state.lastUpdateTime != null &&
            state.status != CurrencyListStatus.cached)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Обновлено: ${_formatTime(state.lastUpdateTime!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.grey,
                ),
              ),
            ),
          ),

        if (state.status == CurrencyListStatus.cached)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.wifi_off, size: 14, color: colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Кэшированные данные',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.grey,
                  ),
                ),
              ],
            ),
          ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<CurrencyListCubit>().refreshCurrencies();
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final data = state.filteredCurrencies;
                final isWide = constraints.maxWidth > 500;

                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      'Ничего не найдено',
                      style: TextStyle(color: colors.grey),
                    ),
                  );
                }

                if (isWide) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) => CurrencyCard(
                      model: data[index],
                    ),
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return CurrencyCard(
                      model: data[index],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'только что';
    if (difference.inMinutes < 60) return '${difference.inMinutes} мин назад';
    if (difference.inHours < 24) return '${difference.inHours} ч назад';
    return '${difference.inDays} дн назад';
  }
}
