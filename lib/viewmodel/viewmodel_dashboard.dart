import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
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
  ModelPrayer _prayers;
  final ReceivePort port = ReceivePort();
  static const String isolateName = 'isolate';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;
  MySharedPreferences sharedPreferences = MySharedPreferences.getInstance();
  static SendPort uiSendPort;

  List<bool> _apToggle = [false, true];
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

  //Getter
  List<bool> get apToggle => _apToggle;

  List<bool> get alarms => _alarms;

  ModelPrayer get prayers => _prayers;

  ModelLocalPrayerParent get parentPrayer => _parentPrayer;

  ModelLocalPrayer get upComingPrayer => _upComingPrayer;

  bool get isAmPmSelected => _apToggle[0] ? true : false;

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  ViewModelDashboard({this.context}) {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    AndroidAlarmManager.initialize();
    port.listen((_) async => {});
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
    await HiveDb.getInstance().openAlarmsBox();

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

      _alarms = HiveDb.getInstance().alarms.values.toList();
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
      _upComingPrayer = HiveDb.getInstance()
          .localPrayerParentBox
          .get(DateTime.now().day)
          .prayers[0];
    }

    HiveDb.getInstance().prayerBox.close();
    HiveDb.getInstance().localPrayerParentBox.close();
    HiveDb.getInstance().alarms.close();
  }

  //Notification Block
  Future addAlarm({int pos, int id, String name}) async {
   /* List<String> time = _parentPrayer.prayers[pos].time.split(":");
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(_parentPrayer.date) * 1000);

    var newDate = new DateTime(date.year, date.month, date.day,
        int.parse(time[0]), int.parse(time[1]), 0);*/

    await AndroidAlarmManager.oneShotAt(
      DateTime.now().add(Duration(minutes: 1)),
      // Ensure we have a unique alarm ID.
      pos,
      callback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    ).then((value) async => {
          if (value)
            {
              await HiveDb.getInstance().openAlarmsBox(),
              await HiveDb.getInstance().alarms.putAt(pos, true),
              _alarms[pos]=true,
              notifyListeners(),
              debugPrint("$value")
            }
        });

/*
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        '${prayers[pos].name} prayer',
        "It's time for your prayer",
        time,
        platformChannelSpecifics);
*/
    //updateStatus(id, 1,name);
  }

  static Future<void> callback() async {
    print('Alarm fired!');

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (pay) {
      return null;
    });
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('0', 'Hello', 'Value is');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, "Prayer", "It's your prayer time", platformChannelSpecifics);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  Future removeNotification(int id, String name) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    // updateStatus(id, 0, name);
  }

  @override
  void dispose() {
    print('I have been disposed!!');
    super.dispose();
  }
}
