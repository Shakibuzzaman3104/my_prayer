import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/model/Date.dart';

import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelLocalPrayerParent.dart';
import 'package:my_prayer/model/ModelPrayer.dart';
import 'package:my_prayer/repository/repository.dart';
import 'package:my_prayer/server_setup/local_database.dart';

import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelDashboard extends BaseViewModel {
  PrayerRepository _repository;
  bool isOnline = false;
  ModelLocalPrayerParent _parentPrayer;
  ModelLocalPrayer _upComingPrayer;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;
  MySharedPreferences sharedPreferences = MySharedPreferences.getInstance();

  List<bool> _apToggle = [false, true];

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  ViewModelDashboard({this.context}) {
    initNotification();
    this._repository = PrayerRepository();
    _prayers = ModelPrayer();
    _parentPrayer = ModelLocalPrayerParent();
    _upComingPrayer = ModelLocalPrayer();
  }

  toggleTimeFormat(int pos) async {
    if (pos == 0) {
      _apToggle[1] = false;
    } else
      _apToggle[0] = false;
    _apToggle[pos] = !_apToggle[0];

    await sharedPreferences.setIsAP(_apToggle[0]);
    notifyListeners();
  }

  List<bool> get apToggle => _apToggle;

  bool get isAmPmSelected {
    if (_apToggle[0]) return true;
    return false;
  }

  var time;
  ModelLocalPrayer nextPrayer = ModelLocalPrayer();
  ModelPrayer _prayers;

  ModelPrayer get prayers => _prayers;

  ModelLocalPrayerParent get parentPrayer => _parentPrayer;

  ModelLocalPrayer get upComingPrayer => _upComingPrayer;

  fetchPrayers() async {
    await checkConnectionStatus().then((value) async {
      await _repository
          .getPrayersFromServer()
          .then((response) {
            if (response is DioError) {
              print(response.message);
              _prayers.hasError = true;
              _prayers.status = response.message;
            } else if (response == null) {
              print("Already updated");
            }
          })
          .catchError((error) async =>
              {_prayers.status = error.toString(), _prayers.hasError = true})
          .catchError((e) {});
    });
    //await upcomingPrayer();
   await getDataFromDB();
  }

  getDataFromDB() async {
    await HiveDb.getInstance().openPrayerBox();
    await HiveDb.getInstance().openLocalPrayerParentBox();
    await HiveDb.getInstance().openLocalPrayerBox();

    bool ap = await sharedPreferences.getIsAP();

    if (ap) {
      _apToggle[0] = true;
      _apToggle[1] = false;
    }

    if (HiveDb.getInstance().prayerBox.isNotEmpty) {
      _prayers = HiveDb.getInstance().prayerBox.get(0);
    }
    if (HiveDb.getInstance().localPrayerParentBox.isNotEmpty) {
      _parentPrayer = HiveDb.getInstance()
          .localPrayerParentBox
          .values
          .firstWhere((element) {
        int timestamp = int.parse(element.date);
        var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        return date.day == DateTime.now().day;
      });
      debugPrint("ViewModel ${_parentPrayer.prayers.length}");
      /**/

    } else
      debugPrint("Not Found");
    await upcomingPrayer();
    setBusy(false);
  }

  Future upcomingPrayer() async {
    TimeOfDay currentTime = TimeOfDay.fromDateTime(DateTime.now());
    int t_hour = currentTime.hour;
    int t_min = currentTime.minute;
    double finalTime = t_hour + t_min / 60.0;
    double time;

    bool isFound = false;

    for (ModelLocalPrayer element in _parentPrayer.prayers) {
      List<String> split = element.time.split(":");
      int hour = int.parse(split[0]);
      int min = int.parse(split[1]);
      time = hour + min / 60.0;

      if (element.name == "Sunrise" ||
          element.name == "Sunset" ||
          element.name == "Midnight" ||
          element.name == "Imsak") {
        continue;
      }
      if (time > finalTime) {
        debugPrint("Found Prayer");
        isFound = true;
        _upComingPrayer = element;
        break;
      }
    }
    if (!isFound) {
      debugPrint("Not Found");
      _upComingPrayer =
           HiveDb.getInstance().localPrayerParentBox.get(DateTime.now().day).prayers[0];
    }

    HiveDb.getInstance().prayerBox.close();
    HiveDb.getInstance().localPrayerParentBox.close();
  }

  DateTime getCurrentDate() {}

  Future addPrayer(ModelLocalPrayer prayer) async {
    //setBusy(true);
    var res = await _repository.addPrayer(prayer);
    await fetchPrayers();
    return res;
  }

  ModelLocalPrayer getNext(List<ModelLocalPrayer> val) {
    return ModelLocalPrayer();
  }

  Future updateStatus(int id, int status) async {
    await _repository.updateStatus(id, status);
    fetchPrayers();
  }

  Future deletePrayer(int id) async {
    removeNotification(id);
    await _repository.deletePrayer(id);
    fetchPrayers();
  }

  Future updatePrayer(ModelLocalPrayer modelPrayer, int pos) async {
    await _repository.updatePrayer(modelPrayer);
    // await removeNotification(modelPrayer.id);
    // addNotification(pos: pos, id: modelPrayer.id);
    fetchPrayers();
  }

  //Notification Block

  void initNotification() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(
          'Notification',
          style: TextStyle(color: Colors.black),
        ),
        content: new Text(
          payload,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Future addNotification({int pos, int id}) async {
    List<String> time = _parentPrayer.prayers[pos].time.split(":");
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(_parentPrayer.date) * 1000);

    var newDate = new DateTime(date.year, date.month, date.day,
        int.parse(time[0]), int.parse(time[1]), 0);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '${id.toString()}',
        '${_parentPrayer.prayers[pos].name}',
        'Its time for ${_parentPrayer.prayers[pos].name} Salah');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "${_parentPrayer.prayers[pos].name} prayer",
        "It's time for your prayer",
        newDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime);

/*
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        '${prayers[pos].name} prayer',
        "It's time for your prayer",
        time,
        platformChannelSpecifics);
*/
    updateStatus(id, 1);
  }

  Future removeNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    updateStatus(id, 0);
  }

  @override
  void dispose() {
    print('I have been disposed!!');
    super.dispose();
  }
}
