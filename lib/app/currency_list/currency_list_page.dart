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

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;

    return BlocProvider(
      create: (context) => CurrencyListCubit(
        repository: context.read<CurrencyRepository>(),
        networkService: context.read<NetworkService>(),
      )..loadCurrencies(),
      
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Курс Валют'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.settings, color: colors.black),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ),
        body: _CurrencyListBody(),
      ),
    );
  }
}

class _CurrencyListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrencyListCubit, CurrencyListState>(
      listener: (context, state) {
        // Можно добавить обработку событий если нужно
      },
      builder: (context, state) {
        final hasCachedData = state.allCurrencies.isNotEmpty;

        // 1. Ошибка сети при первой загрузке (нет кэшированных данных)
        if (state.status == CurrencyListStatus.networkError && !hasCachedData) {
          print("Ошибка сети при первой загрузке (нет кэшированных данных)");
          return ErrorView(
            message: 'Нет подключения к интернету. Проверьте настройки сети.',
            onRetry: () => context.read<CurrencyListCubit>().loadCurrencies(),
          );
        }
        
        // 2. Ошибка сети, но есть кэшированные данные
        if (state.status == CurrencyListStatus.networkError && hasCachedData) {
          print(" Ошибка сети, но есть кэшированные данные");
          return Column(
            children: [
              _buildNetworkErrorBanner(),
              const SizedBox(height: 16),
              _buildContentWithSearch(
                context: context,
                state: state,
                showRefresh: false,
              ),
            ],
          );
        }
        
        // 3. Ошибка сервера при первой загрузке (нет кэшированных данных)
        if (state.status == CurrencyListStatus.failure && !hasCachedData) {
          print("Ошибка сервера при первой загрузке (нет кэшированных данных)");
          return ErrorView(
            message: 'Не удалось загрузить курсы валют. Попробуйте еще раз.',
            onRetry: () => context.read<CurrencyListCubit>().loadCurrencies(),
          );
        }
        
        // 4. Ошибка сервера, но есть кэшированные данные
        if (state.status == CurrencyListStatus.failure && hasCachedData) {
          print("Ошибка сервера, но есть кэшированные данные");
          return Column(
            children: [
              _buildServerErrorBanner(),
              const SizedBox(height: 16),
              _buildContentWithSearch(
                context: context,
                state: state,
                showRefresh: false,
              ),
            ],
          );
        }
        
        // 5. Загрузка при первой загрузке (нет кэшированных данных)
        if (state.status == CurrencyListStatus.loading && !hasCachedData) {
          print("5. Загрузка при первой загрузке (нет кэшированных данных)");
          return const Center(child: CircularProgressIndicator());
        }
        
        // 6. Загрузка новых данных при наличии кэшированных
        if (state.status == CurrencyListStatus.loading && hasCachedData) {
          print("Загрузка новых данных при наличии кэшированных");
          return Column(
            children: [
              _buildLoadingBanner(),
              const SizedBox(height: 16),
              _buildContentWithSearch(
                context: context,
                state: state,
                showRefresh: false,
              ),
            ],
          );
        }
        
        // 7. Если данных нет
        if (state.allCurrencies.isEmpty) {
          return const Center(child: Text('Список пуст'));
        }

          print("8. Успешная загрузка или отображение кэшированных данных");

        // 8. Успешная загрузка или отображение кэшированных данных
        return _buildContentWithSearch(
          context: context,
          state: state,
          showRefresh: true,
        );
      },
    );
  }

  Widget _buildContentWithSearch({
    required BuildContext context,
    required CurrencyListState state,
    required bool showRefresh,
  }) {
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
          child: showRefresh 
            ? RefreshIndicator(
                onRefresh: () async {
                  await context.read<CurrencyListCubit>().loadCurrencies();
                },
                child: _buildCurrencyList(state.filteredCurrencies),
              )
            : _buildCurrencyList(state.filteredCurrencies),
        ),
      ],
    );
  }

  Widget _buildCurrencyList(List<dynamic> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        
        if (isWide) {
          return GridView.builder(
            key: const PageStorageKey<String>('currency_grid'),
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
          key: const PageStorageKey<String>('currency_list'),
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

  Widget _buildNetworkErrorBanner() {
    return Container(
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
    );
  }

  Widget _buildServerErrorBanner() {
    return Container(
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
    );
  }

  Widget _buildLoadingBanner() {
    return Container(
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
    );
  }
}