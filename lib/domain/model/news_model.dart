// lib/domain/model/news_model.dart


class NewsModel {
  final String title;
  final String link;
  final DateTime? date;

  const NewsModel({
    required this.title,
    required this.link,
    this.date,
  });
}

