// lib/domain/service/network_service.dart


import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  // Проверка, есть ли активное соединение
  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // Результат не является 'none' или 'unavailable'
    return connectivityResult.contains(ConnectivityResult.mobile) || 
           connectivityResult.contains(ConnectivityResult.wifi) ||
           connectivityResult.contains(ConnectivityResult.ethernet);
  }
}