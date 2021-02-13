import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_prayer/model/Hijri.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelLocalPrayerParent.dart';
import 'package:my_prayer/model/ModelPrayer.dart';
import 'package:my_prayer/repository/repository.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

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
  String _address = "";
  String _date = "";
  PERMISSIONS _permission = PERMISSIONS.APPROVED;

  final _countDownStream = StreamController<String>.broadcast();

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

  StreamController<String> get countDownStream => _countDownStream;

  //Getter
  List<bool> get apToggle => _apToggle;

  PERMISSIONS get permission => _permission;



  ModelPrayer get prayers => _prayers;

  String get address => _address;

  String get date => _date;

  ModelLocalPrayerParent get parentPrayer => _parentPrayer;

  ModelLocalPrayer get upComingPrayer => _upComingPrayer;

  bool get isAmPmSelected => _apToggle[0] ? true : false;

  void connectionChanged(dynamic hasConnection) {
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  ViewModelDashboard({this.context}) {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    AndroidAlarmManager.initialize();

    port.listen((pos) async {
      //Reschedule Alarm for nextDay
      await HiveDb.getInstance().openLocalPrayerParentBox();
      ModelLocalPrayer prayer = HiveDb.getInstance()
          .localPrayerParentBox
          .getAt(DateTime.now().day)
          .prayers[pos];

      List<String> time = prayer.time.split(":");

      var date = DateTime.now().add(Duration(days: 1));

      var newDate = new DateTime(date.year, date.month, date.day,
          int.parse(time[0]), int.parse(time[1]), 0);

      await AndroidAlarmManager.oneShotAt(
        newDate,
        // Ensure we have a unique alarm ID.
        pos,
        callback,
        alarmClock: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );
    });
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

    _address = await sharedPreferences.getAddress();

    bool ap = await sharedPreferences.getIsAP();

    if (ap) {
      _apToggle[0] = true;
      _apToggle[1] = false;
    }

    if (HiveDb.getInstance().prayerBox.isNotEmpty) {
      _prayers = HiveDb.getInstance().prayerBox.get(0);
      int dd = DateTime.now().day - 1;
      Hijri hj = _prayers.data[dd].date.hijri;
      _date = "${hj.weekday.en}, ${hj.month.en}, ${hj.year}";
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
        isFound = true;
        _upComingPrayer = element;
        break;
      }
    }

    var date = DateTime.now();
    if (!isFound) {
      _upComingPrayer = HiveDb.getInstance()
          .localPrayerParentBox
          .get(DateTime.now().day)
          .prayers[0];

      date = date.add(Duration(days: 1));
    }

    List<String> splits = _upComingPrayer.time.split(":");

    countDownTimer(
      DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(splits[0]),
          int.parse(
            splits[1],
          ),
          0),
    );

    HiveDb.getInstance().prayerBox.close();
    HiveDb.getInstance().localPrayerParentBox.close();
    HiveDb.getInstance().alarms.close();
  }

  countDownTimer(DateTime dateTime) {
    DateTime localDate = DateTime.now();

    Duration diff = dateTime.difference(localDate);

    Timer.periodic(Duration(seconds: 1), (timer) {
      _countDownStream.add(printDuration(diff.inSeconds - timer.tick));
    });
  }

  String printDuration(int sec) {
    Duration duration = Duration(seconds: sec);

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "00:$twoDigitMinutes:$twoDigitSeconds";
  }

  //Notification Block
  Future addAlarm({int pos}) async {
    List<String> time = _parentPrayer.prayers[pos].time.split(":");
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(_parentPrayer.date) * 1000);

    DateTime newDate = new DateTime(date.year, date.month, date.day,
        int.parse(time[0]), int.parse(time[1]), 0);

    var dateTime = DateTime.now();
    if (date.isBefore(dateTime)) {
      dateTime = dateTime.add(
        Duration(days: 1),
      );
      newDate = new DateTime(dateTime.year, dateTime.month, dateTime.day,
          int.parse(time[0]), int.parse(time[1]), 0);
    }

    await AndroidAlarmManager.oneShotAt(
      newDate,
      // Ensure we have a unique alarm ID.
      pos,
      callback,
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    ).then((value) async => {
          if (value)
            {
              await HiveDb.getInstance().openAlarmsBox(),
              await HiveDb.getInstance().alarms.putAt(pos, true),
              debugPrint("$value")
            }
        });
  }

  static Future<void> callback(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('ic_stat_access_alarms');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (pay) {
      return null;
    });
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$id',
      'Hello',
      'Value is',
      sound: RawResourceAndroidNotificationSound("azan"),
      playSound: true,
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(id, "Prayer Reminder",
        "It's time for ${await getPrayerName(id)}", platformChannelSpecifics);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(id);
  }

  static Future<String> getPrayerName(int pos) async {
    await Hive.initFlutter();
    HiveDb.getInstance().init();
    await HiveDb.getInstance().openLocalPrayerBox();
    String name = HiveDb.getInstance().localPrayerBox.getAt(pos).name;
    await HiveDb.getInstance().localPrayerBox.close();
    return name;
  }

  Future removeAlarm(int pos, bool status) async {
    await AndroidAlarmManager.cancel(pos).then((value) async {
      await HiveDb.getInstance().openAlarmsBox();
      await HiveDb.getInstance().alarms.putAt(pos, false);
      debugPrint("$value");
    });
  }

  @override
  void dispose() {
    print('I have been disposed!!');
    super.dispose();
  }


}
