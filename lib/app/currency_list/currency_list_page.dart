// lib/app/currency_list/currency_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:lr4/app/currency_list/currency_list_cubit.dart';
import 'package:lr4/app/currency_list/currency_list_state.dart';
import 'package:lr4/app/currency_list/widgets/currency_card.dart';
import 'package:lr4/app/currency_list/widgets/search_view.dart';
import 'package:lr4/app/app_routes.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/domain/datasource/preference_datasource.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/app/widgets/error_view.dart';
import 'package:lr4/domain/service/logger_service.dart';
import 'package:lr4/domain/service/network_service.dart';

abstract class _CurrencyListConstants {
  static const String timeFormat = 'EE. H:mm dd.MM.yy';
  static const String ruLocale = 'ru';
}

class CurrencyListPage extends StatelessWidget {
  const CurrencyListPage({super.key});
  static final Logger _logger = LoggerService.getUILogger('CurrencyList');

  void _loadCurrencies(BuildContext context) {
    context.read<CurrencyListCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;

    return BlocProvider(
      create: (context) => CurrencyListCubit(
        repository: context.read<CurrencyRepository>(),
        networkService: context.read<NetworkService>(),
        preferenceDatasource: context.read<PreferenceDatasource>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.currencyRate),
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
                    context.loc.checkNetwork,
                onRetry: () => _loadCurrencies(context),
              );
            }

            if (state.status == CurrencyListStatus.failure &&
                state.allCurrencies.isEmpty) {
              return ErrorView(
                message: context.loc.cannotLoadCurrencies,
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
                      context.loc.noCurrencyData(0),
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _loadCurrencies(context),
                      icon: const Icon(Icons.refresh),
                      label: Text(context.loc.repeat),
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
            return Center(child: Text(context.loc.noCurrencyData(0)));
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, CurrencyListState state, ThemeColors colors) {
    _logger.info("lastUpdateTime ${state.lastUpdateTime}");
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

        // Объединенная строка с информацией о статусе и времени обновления
        if (state.lastUpdateTime != null ||
            state.status == CurrencyListStatus.cached ||
            state.status == CurrencyListStatus.networkError ||
            state.status == CurrencyListStatus.failure)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
            child: Row(
              children: [
                // Иконка статуса
                if (state.status == CurrencyListStatus.cached ||
                    state.status == CurrencyListStatus.networkError ||
                    state.status == CurrencyListStatus.failure)
                  Row(
                    children: [
                      Icon(
                        state.status == CurrencyListStatus.networkError
                            ? Icons.wifi_off
                            : Icons.cached,
                        size: 14,
                        color: colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        state.status == CurrencyListStatus.networkError
                            ? context.loc.offlineMode
                            : context.loc.cachedData,
                        style: context.fonts.regular12.copyWith(fontSize: 10, color: colors.grey),
                      ),
                      const SizedBox(width: 12), // Отступ между частями
                    ],
                  ),
                
                // Время обновления (выравнивается по правому краю)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${context.loc.updated}: ${DateFormat(_CurrencyListConstants.timeFormat, _CurrencyListConstants.ruLocale).format(state.lastUpdateTime!)}',
                        style: context.fonts.regular12.copyWith(fontSize: 10, color: colors.grey),

                    ),
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
                      context.loc.noData,
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
}