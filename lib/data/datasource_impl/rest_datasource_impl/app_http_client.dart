import 'dart:convert';
import 'package:http/http.dart' as http;

class AppHttpClient {
  final http.Client _client = http.Client();

  // 1. Метод для получения JSON
  Future<String?> getDecodedResponse(String url) async {
    return _getStringResponse(url, headers: {'Accept': 'application/json'});
  }

  // 2. Метод для получения XML (RSS)
  Future<String?> getXmlResponse(String url) async {
    // Для RSS/XML устанавливаем заголовок Accept, 
    return _getStringResponse(url, headers: {'Accept': 'application/xml'});
  }
  
// Приватный общий метод для выполнения запроса
  Future<String?> _getStringResponse(String url, {Map<String, String>? headers}) async {
    try {
      final http.Response response = await _client.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        // Успех
        return utf8.decode(response.bodyBytes);
      } else {
        // Ошибка 1: Сервер вернул код ошибки 404, 500
        print('❌ HTTP CLIENT ERROR: Запрос не удался для $url. Код статуса: ${response.statusCode}'); 
        return null;
      }
    } catch (e) {
      // Ошибка 2: Исключение на уровне сети
      print('❌ HTTP CLIENT EXCEPTION: Ошибка при получении $url. Исключение: $e');
      return null;
    }
  }

  void dispose() => _client.close();
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AppHttpClient {
//   final http.Client _client = http.Client();

//   Future<String?> getDecodedResponse(String url) async {
//     try {
//       final http.Response response = await _client.get(Uri.parse(url));
//       // Возвращаем данные только если сервер ответил "ОК" (200)
//       return response.statusCode == 200 ? utf8.decode(response.bodyBytes) : null;
//     } catch (e) {
//       // Здесь можно добавить логирование ошибки
//       return null;
//     }
//   }

//   void dispose() => _client.close();
// }