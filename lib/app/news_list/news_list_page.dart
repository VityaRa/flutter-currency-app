// lib/app/news_list/news_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:lr4/app/news_list/news_list_cubit.dart';
import 'package:lr4/app/news_list/news_list_state.dart';
import 'package:lr4/app/news_list/widgets/news_card.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/domain/datasource/preference_datasource.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:lr4/domain/repository/news_repository.dart';
import 'package:lr4/app/widgets/error_view.dart';
import 'package:lr4/domain/service/logger_service.dart';
import 'package:lr4/domain/service/network_service.dart';

abstract class _NewsListConstants {
  static const String timeFormat = 'EE. H:mm dd.MM.yy';
  static const String ruLocale = 'ru';
}

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});
  static final Logger _logger = LoggerService.getUILogger('NewsList');

  void _loadNews(BuildContext context) {
    context.read<NewsListCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;
    return BlocProvider(
      create: (context) => NewsListCubit(
        repository: context.read<NewsRepository>(),
        networkService: context.read<NetworkService>(),
        preferenceDatasource: context.read<PreferenceDatasource>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Новости'),
          automaticallyImplyLeading: false,
          surfaceTintColor: colors.appBarSurfaceTint,
        ),
        body: BlocBuilder<NewsListCubit, NewsListState>(
          builder: (context, state) {
           _logger.info("lastUpdateTime ${state.lastUpdateTime}");
            // Если есть кэшированные данные, показываем их (даже при ошибке сети)
            if (state.allNews.isNotEmpty) {
              return _buildContent(context, state, colors);
            }

            // Обработка ошибок только если нет кэшированных данных
            if (state.status == NewsListStatus.networkError) {
              return ErrorView(
                message: state.errorMessage ??
                    'Нет подключения к интернету. Проверьте настройки сети.',
                onRetry: () => _loadNews(context),
              );
            }

            if (state.status == NewsListStatus.failure) {
              return ErrorView(
                message: state.errorMessage ?? 'Не удалось загрузить новости.',
                onRetry: () => _loadNews(context),
              );
            }

            // Если данных нет и идет загрузка
            if (state.status == NewsListStatus.loading ||
                state.status == NewsListStatus.refreshing) {
              return const Center(child: CircularProgressIndicator());
            }

            // Если данных вообще нет
            if (state.allNews.isEmpty &&
                state.status != NewsListStatus.loading &&
                state.status != NewsListStatus.refreshing) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Нет новостей',
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _loadNews(context),
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

            return const Center(child: Text('Нет данных'));
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, NewsListState state, ThemeColors colors) {
    _logger.info("lastUpdateTime ${state.lastUpdateTime}");

    return Column(
      children: [
        // Объединенная строка с информацией о статусе и времени обновления
        if (state.lastUpdateTime != null ||
            state.status == NewsListStatus.cached ||
            state.status == NewsListStatus.networkError ||
            state.status == NewsListStatus.failure)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
            child: Row(
              children: [
                // Иконка и текст статуса
                if (state.status == NewsListStatus.cached ||
                    state.status == NewsListStatus.networkError ||
                    state.status == NewsListStatus.failure)
                  Row(
                    children: [
                      Icon(
                        state.status == NewsListStatus.networkError
                            ? Icons.wifi_off
                            : Icons.cached,
                        size: 14,
                        color: colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        state.status == NewsListStatus.networkError
                            ? 'Оффлайн режим'
                            : 'Кэшированные данные',
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
                      'Обновлено: ${DateFormat(_NewsListConstants.timeFormat, _NewsListConstants.ruLocale).format(state.lastUpdateTime!)}',
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
              print("RefreshIndicator::onRefresh");
              await context.read<NewsListCubit>().refreshNews();
            },
            child: _buildNewsList(context, state.allNews),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList(BuildContext context, List<NewsModel> newsList) {
    final ThemeFonts fonts = context.fonts;

    if (newsList.isEmpty) {
      return Center(
        child: Text(
          'Новостей нет',
          style: fonts.regular12,
        ),
      );
    }

    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (BuildContext context, int index) {
        final NewsModel news = newsList[index];

        return Padding(
          key: ValueKey(news.link),
          padding:
              index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
          child: NewsCard(model: news),
        );
      },
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
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