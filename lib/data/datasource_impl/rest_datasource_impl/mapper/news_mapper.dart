// lib/data/datasource_impl/rest_datasource_impl/mapper/news_mapper.dart


import 'package:intl/intl.dart'; // ДЛЯ DateFormat
import 'package:lr4/domain/model/news_model.dart';
import 'package:rss_dart/domain/rss_item.dart';

// Константа формата даты для парсинга RSS
abstract class RssDateFormat {
  // Стандартный формат даты в RSS
  static const String rssDateTimeFormat = 'EEE, dd MMM yyyy HH:mm:ss Z';
}

extension RssItemMapper on RssItem {
  NewsModel get asNewsModel {
    final String? pubDateStr = pubDate; // Тип String?
    
    DateTime? parsedDate;

    if (pubDateStr != null) {
      try {
        // Парсим строку в DateTime, используя явный формат
        parsedDate = DateFormat(RssDateFormat.rssDateTimeFormat).parse(pubDateStr);
      } catch (e) {
        // Если парсинг не удался, оставляем null
        parsedDate = null;
      }
    }

    return NewsModel(
      title: title ?? 'Новость без заголовка',
      link: link ?? '',
      date: parsedDate, // Тип DateTime?
    );
  }
}











// import 'package:intl/intl.dart';
// import 'package:lr4/domain/model/news_model.dart';
// import 'package:rss_dart/domain/rss_item.dart';

// // В задании есть RestConstants, добавим его сюда или прямо в код
// abstract class RestConstants {
//   static const String newsDateTimeFormat = 'EEE, dd MMM yyyy HH:mm:ss Z';
// }

// extension NewsItemMapper on RssItem {
//   NewsModel get asNewsModel {
//     final String? pubDate = this.pubDate;
//     return NewsModel(
//       title: title ?? '',
//       link: link ?? '',
//       date: pubDate == null ? null : DateFormat(RestConstants.newsDateTimeFormat).parse(pubDate),
//     );
//   }
// }