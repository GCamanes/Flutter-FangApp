import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

enum ConnectivityStatus { Online, Offline }

class ConnectivityService extends ChangeNotifier {
  bool _connectivityStatus = false;
  bool get connectivityStatus => _connectivityStatus;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityService() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  void _updateConnectivityStatus(ConnectivityResult status) {
    _connectivityStatus = status == ConnectivityResult.mobile || status == ConnectivityResult.wifi;
    notifyListeners();
  }
}