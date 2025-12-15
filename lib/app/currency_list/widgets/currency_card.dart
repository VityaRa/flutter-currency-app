import 'package:flutter/material.dart';
import 'package:lr4/app/currency_detail/currency_detail_page.dart';
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
    
    // Цвета и иконки по логике модели
    final rateColor = priceChange == PriceChange.up 
        ? const Color(0xFF1FD522) 
        : (priceChange == PriceChange.down ? const Color(0xFFD51F1F) : Colors.grey);
        
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
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
        color: Colors.white,
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
                width: 40, height: 40,
                decoration: BoxDecoration(
                   color: Theme.of(context).primaryColor,
                   shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    model.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
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
              if(priceChange != PriceChange.stable)
                 Image.asset(arrowAsset, width: 10, height: 10),
              
              // Звездочка
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  size: 20,
                  color: isFavorite ? const Color(0xFFFFC700) : const Color(0xFF7C7B7B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart'; 
// import 'package:lr4/app/currency_detail/currency_detail_page.dart';
// // import 'package:lr3/app/app_routes.dart';

// class CurrencyCard extends StatelessWidget {
//   const CurrencyCard({
//     super.key,
//     required this.currencyCode,
//     required this.title,
//     required this.rate,
//     required this.isGrowing,
//     required this.isFavorite,
//     this.subtitle,
//   });

//   final String currencyCode;
//   final String title;
//   final String rate;
//   final bool isGrowing;
//   final bool isFavorite;
//   final String? subtitle;

//   @override
//   Widget build(BuildContext context) {
//     // Логика цвета для курса
//     final rateColor = isGrowing ? const Color(0xFF1FD522) : const Color(0xFFD51F1F);
//     final arrowAsset = isGrowing ? 'assets/icons/arrow_up.png' : 'assets/icons/arrow_down.png';

//     // Проверка наличия подзаголовка
//     final shouldShowSubtitle = subtitle != null && subtitle!.isNotEmpty;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             // 1. Указываем экран, на который переходим
//             pageBuilder: (context, animation, secondaryAnimation) {
//               return CurrencyDetailPage(title: title);
//             },
//             // 2. Определяем длительность анимации
//             transitionDuration: const Duration(milliseconds: 400),
//             reverseTransitionDuration: const Duration(milliseconds: 400),
            
//             // 3. Создаем саму анимацию (Transition)
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               // Анимация смещения (slide) снизу вверх
//               const begin = Offset(0.0, 1.0); // Начинается снизу (y=1.0)
//               const end = Offset.zero;      // Заканчивается в нормальном положении (y=0.0)
              
//               // Создаем анимацию для перехода
//               final curve = CurveTween(curve: Curves.easeOut); 
              
//               // Комбинируем смещение и кривую
//               final tween = Tween(begin: begin, end: end).chain(curve); 
              
//               // Применяем SlideTransition к дочернему виджету (экрану)
//               return SlideTransition(
//                 position: animation.drive(tween),
//                 child: child,
//               );
//             },
//           ),
//         );


//       //  Navigator.pushNamed(
//       //     context,
//       //     AppRoutes.currencyDetail,
//       //     arguments: {'title': title},
//       //   );
//       },
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 0,
//         margin: EdgeInsets.zero,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CurrencyIcon(title: currencyCode),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     // Центрирование заголовка при отсутствии подзаголовка
//                     mainAxisAlignment: shouldShowSubtitle ? MainAxisAlignment.start : MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         title,
//                         maxLines: 3, // Ограничение тремя строками
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),
//                       if (shouldShowSubtitle)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4), // Увеличен отступ для subtitle
//                           child: Text(
//                             subtitle!,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontFamily: 'Inter',
//                               fontSize: 10,
//                               fontWeight: FontWeight.w400,
//                               color: Color(0xFF7C7B7B),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 6),
//                 child: Text(
//                   rate,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: rateColor,
//                   ),
//                 ),
//               ),
//               Image.asset(
//                 arrowAsset,
//                 width: 10,
//                 height: 10,
//               ),
//               // Иконка избранного с желтым цветом
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Icon(
//                   isFavorite ? Icons.star : Icons.star_border,
//                   size: 20,
//                   // Желтый цвет для избранного
//                   color: isFavorite ? const Color(0xFFFFC700) : const Color(0xFF7C7B7B),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CurrencyIcon extends StatelessWidget {
//   const CurrencyIcon({super.key, required this.title});
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: 20,
//       backgroundColor: Theme.of(context).primaryColor,
//       child: Center(
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontFamily: 'InterTight',
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }