import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelNavigation extends BaseViewModel {
  bool isOnline = false;
  PERMISSIONS _permission = PERMISSIONS.APPROVED;

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  double _offset = 0.0;

  PERMISSIONS get permission => _permission;

  double get offset => _offset;

  ViewModelNavigation() {
    initConnection(connectionChanged);
  }

  Future checkPermission() async {
    _permission = await determinePermission();
    setBusy(false);
  }
}
