import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_prayer/utils/network_manager.dart';

class BaseViewModel extends ChangeNotifier {
  bool _busy = true;
  bool get busy => _busy;

  void initConnection(Function connectionChanged) {
    ConnectionStatusChecker connectionStatus =
        ConnectionStatusChecker.getInstance();
    connectionStatus.connectionChange.listen((connection) {
      connectionChanged(connection);
    });
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  Future<bool> checkConnectionStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
