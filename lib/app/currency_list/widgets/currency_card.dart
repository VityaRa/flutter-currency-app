import 'package:flutter/material.dart';
import 'package:lr4/app/currency_detail/currency_detail_page.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/domain/model/currency_model.dart'; //

// Вспомогательный enum для определения роста/падения
enum PriceChange { up, down, stable }

extension on CurrencyModel {
  PriceChange get asPriceChange {
    if (value > previousValue) return PriceChange.up;
    if (value < previousValue) return PriceChange.down;
    return PriceChange.stable;
  }
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    super.key,
    required this.model,
    this.isFavorite = false,
  });

  final CurrencyModel model;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final priceChange = model.asPriceChange;
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;
    // Цвета и иконки по логике модели
    final rateColor = priceChange == PriceChange.up
        ? colors.greenWrasse
        : (priceChange == PriceChange.down
            ? colors.red
            : colors.stormyGrey);

    final arrowAsset = priceChange == PriceChange.up
        ? 'assets/icons/arrow_up.png'
        : 'assets/icons/arrow_down.png';


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return CurrencyDetailPage(
                title: model.name,
                currencyId: model.id,
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final curve = CurveTween(curve: Curves.easeOut);
              final tween = Tween(begin: begin, end: end).chain(curve);
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Card(
        color: colors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Кружочек с символом
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    model.symbol,
                    style: fonts.semiBold12.copyWith(color: colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        model.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${model.nominal} шт.',
                        style: fonts.regular12.copyWith(fontSize: 11, color: colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.value.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: rateColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              if (priceChange != PriceChange.stable)
                Image.asset(arrowAsset, width: 10, height: 10),

              // Звездочка
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  size: 20,
                  color: isFavorite
                      ? colors.favourite
                      : colors.stormyGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}