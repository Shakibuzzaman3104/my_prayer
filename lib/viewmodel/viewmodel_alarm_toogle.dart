import 'package:flutter/cupertino.dart';
import 'package:my_prayer/server_setup/local_database.dart';

class ViewModelAlarmToggle extends ChangeNotifier{

  List<bool> _alarms = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  List<bool> get alarms => _alarms;

  fetchAlarms() async
  {
    await HiveDb.getInstance().openAlarmsBox();
    _alarms =  HiveDb.getInstance().alarms.values.toList();
   await HiveDb.getInstance().alarms.close();
  }


  void updateStatus(int pos, bool status) {
    _alarms[pos] = status;
    notifyListeners();
  }


}