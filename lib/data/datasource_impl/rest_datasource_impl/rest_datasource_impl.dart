import 'dart:convert';
import 'package:lr4/data/datasource_impl/rest_datasource_impl/app_http_client.dart';
// import 'package:lr4/data/datasource_impl/rest_datasource_impl/mapper/currency_mapper.dart';
import 'package:lr4/data/datasource_impl/rest_datasource_impl/mapper/news_mapper.dart';
import 'package:lr4/data/datasource_impl/model/currency_dto.dart';
import 'package:lr4/data/datasource_impl/rest_datasource_impl/rest_path.dart';
import 'package:lr4/domain/datasource/rest_datasource.dart';
import 'package:lr4/domain/model/currency_model.dart';
import 'package:lr4/domain/model/news_model.dart';
import 'package:rss_dart/dart_rss.dart';

import 'package:lr4/data/datasource_impl/rest_datasource_impl/mapper/currency_history_mapper.dart';
import 'package:lr4/domain/model/currency_history_model.dart';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class RestDatasourceImpl implements RestDatasource {
  final AppHttpClient _httpClient = AppHttpClient();

@override
  Future<List<CurrencyModel>> getCurrencyList() async {
    final String? response = await _httpClient.getDecodedResponse(RestPath.dailyExchangeRateUrl);
    if (response == null) return const <CurrencyModel>[];

    final Map<String, dynamic> json = jsonDecode(response);
    return CurrencyListResponseDto.fromJson(json)
        .valute
        .values
        .map((e) => e.model)
        .toList(growable: false);
  }


  @override
  Future<List<NewsModel>> getNewsList() async {
    final String? response = await _httpClient.getXmlResponse(RestPath.newsUrl);
    
    if (response == null) {
      print('❌ RSS DEBUG: Не удалось получить ответ по сети (response == null). Проверьте URL и AppHttpClient.');
      return const <NewsModel>[];
    }
    if (response.isEmpty) {
      print('❌ RSS DEBUG: Ответ пустой, но не null. Проверьте URL (RestPath.newsUrl).');
      return const <NewsModel>[];
    }

    try {
      final RssFeed feed = RssFeed.parse(response);
      print('✅ RSS DEBUG: XML успешно распарсен. Найдено новостей: ${feed.items.length}');

      return feed.items.map((e) => e.asNewsModel).toList(growable: false);
    } catch (e) {
       print('❌ RSS DEBUG: Ошибка при парсинге XML/RSS: $e');
       return const <NewsModel>[];
    }
  }


@override
  Future<List<CurrencyHistoryModel>> getCurrencyHistory(String id, DateTime date1, DateTime date2) async {
    final f = DateFormat('dd/MM/yyyy');
    final d1 = f.format(date1);
    final d2 = f.format(date2);

    // 1. Собираем ЧИСТЫЙ URL Центрального Банка 
    final targetUrl = '${RestPath.cbrDynamicsUrl}?date_req1=$d1&date_req2=$d2&VAL_NM_RQ=$id';
    
    // 2. Кодируем targetUrl и оборачиваем его в прокси-сервис
    final encodedTargetUrl = Uri.encodeComponent(targetUrl);
    final url = '${RestPath.proxyUrl}$encodedTargetUrl';

    print('CBR HISTORY DEBUG: Target URL (ЦБ): $targetUrl');
    print('CBR HISTORY DEBUG: Запрос URL (Proxy): $url'); // Логируем конечный URL

    final String? response = await _httpClient.getXmlResponse(targetUrl);

    if (response == null || response.isEmpty) {
      print('❌ CBR HISTORY DEBUG: Ответ пустой или null. Возможно, запрос не удался.');
      return const [];
    }

    try {
      if (response.trim().startsWith('<html') || response.trim().startsWith('<!DOCTYPE html>')) {
        print('❌ CBR HISTORY DEBUG: Ответ, похоже, является HTML страницей, а не XML. Полный ответ:');
        print(response.substring(0, response.length > 500 ? 500 : response.length));
        return const [];
      }
      // Парсим XML документ
      final document = XmlDocument.parse(response);

      final records = document.findAllElements('Record').toList();
      print('✅ CBR HISTORY DEBUG: XML успешно распарсен. Найдено записей <Record>: ${records.length}');

      if (records.isNotEmpty) {
          records.take(3).forEach((record) {
              final date = record.getAttribute('Date');
              final value = record.findElements('Value').firstOrNull?.innerText;
              print('   -> Record: Date=$date, Value=$value');
          });
      }
      
      // Ищем все элементы <Record> и мапим их
      return document
          .findAllElements('Record')
          .map((element) => element.asHistoryModel)
          .toList();
    } catch (e) {
      print('Error parsing XML dynamic: $e');
      print('❌ CBR HISTORY DEBUG: Ошибка при парсинге или обработке: $e'); 
      print('❌ CBR HISTORY DEBUG: Пришедший текст (начало): ${response.substring(0, response.length > 500 ? 500 : response.length)}');
      return const [];
    }
  }


}
