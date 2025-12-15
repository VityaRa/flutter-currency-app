// lib/app/news_list/widgets/news_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lr4/app/utils/url_launcher.dart'; // Из ваших материалов
import 'package:lr4/domain/model/news_model.dart'; // Из шага 2.1

// Вспомогательные константы, так как у нас нет AppConstants
abstract class _NewsConstants {
  static const String newsDateTimeFormat = 'EE. H:mm dd.MM.yy';
  static const String ruLocale = 'ru';
  static const String resource = 'cbr.ru';
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.model});

  final NewsModel model;

  @override
  Widget build(BuildContext context) {
    final DateTime? date = model.date;

    return GestureDetector(
      onTap: () => tryLaunchUrl(model.link),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (date != null)
                    Text(
                      // Необходимо убедиться, что пакет intl добавлен в pubspec.yaml
                      // Если нет, запустите: flutter pub add intl
                      DateFormat(_NewsConstants.newsDateTimeFormat, _NewsConstants.ruLocale).format(date),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF505050),
                      ),
                    ),
                  Text(
                    _NewsConstants.resource,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF505050),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lr4/app/utils/url_launcher.dart'; // Твой url_launcher
// import 'package:lr4/domain/model/news_model.dart'; //

// class NewsCard extends StatelessWidget {
//   const NewsCard({super.key, required this.model});

//   final NewsModel model;

//   @override
//   Widget build(BuildContext context) {
//     final date = model.date;
//     // Форматирование даты
//     final dateStr = date != null 
//         ? DateFormat('E HH:mm dd.MM.yy', 'ru_RU').format(date) 
//         : '';

//     return GestureDetector(
//       onTap: () => tryLaunchUrl(model.link),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               model.title,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(dateStr, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
//                 Text('cbr.ru', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:lr4/app/utils/url_launcher.dart';

// class NewsCard extends StatelessWidget {
//   const NewsCard({super.key});

//   static const String _url = 'https://flutter.dev';

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => tryLaunchUrl(_url),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(
//               'Вводятся новые правила допуска на финансовый рынок кредитных потребительских кооперативов',
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 6),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Ср. 10:47 05.02.25',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF505050),
//                     ),
//                   ),
//                   Text(
//                     'cbr.ru',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF505050),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }