import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  ConnectivityService._internal();

  static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  ConnectivityResult _lastResult = ConnectivityResult.none;

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> isConnectedToNetwork() async {
    final result = await _connectivity.checkConnectivity();
    return result.firstWhereOrNull(
            (element) => element != ConnectivityResult.none) !=
        null;
  }

  Future<bool> hasInternetAccess() async {
    final isConnected = await isConnectedToNetwork();
    if (!isConnected) return false;

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  ConnectivityResult get lastResult => _lastResult;

  void initializeListener() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _lastResult = result.first;
    });
  }
}
