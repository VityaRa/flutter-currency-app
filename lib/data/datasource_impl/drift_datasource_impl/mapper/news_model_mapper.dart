import 'package:lr4/domain/model/news_model.dart';

extension NewsModelDriftExt on NewsModel {
  Map<String, dynamic> toMap() => {
        'title': title,
        'link': link,
        'date': date?.toIso8601String(),
      };

  static NewsModel fromMap(Map<String, dynamic> map) => NewsModel(
        title: map['title'],
        link: map['link'],
        date: map['date'] != null ? DateTime.tryParse(map['date']) : null,
      );
}
