// lib/app/news_list/widgets/news_card.dart

import 'package:flutter/material.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/formatters.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/app/utils/url_launcher.dart'; // Из ваших материалов
import 'package:lr4/domain/model/news_model.dart'; // Из шага 2.1

// Вспомогательные константы, так как у нас нет AppConstants
abstract class _NewsConstants {
  static const String resource = 'cbr.ru';
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.model});

  final NewsModel model;

  @override
  Widget build(BuildContext context) {
    final DateTime? date = model.date;
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;

    return GestureDetector(
      onTap: () => tryLaunchUrl(model.link),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: colors.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.title,
              style: fonts.semiBold12,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (date != null)
                    Text(
                        IntlFormatters.formatFullDate(context.loc.localeName, date),
                        style: fonts.regular12.copyWith(color: colors.tin)),
                  Text(_NewsConstants.resource,
                      style: fonts.regular12.copyWith(color: colors.tin)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
