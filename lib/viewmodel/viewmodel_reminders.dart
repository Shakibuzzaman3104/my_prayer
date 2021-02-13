import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelReminder.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ViewModelReminders extends BaseViewModel {
  bool isOnline = false;
  ModelReminder _upComingReminder;
  final ReceivePort port = ReceivePort();
  static const String isolateName = 'isolate2';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;
  MySharedPreferences sharedPreferences = MySharedPreferences.getInstance();
  static SendPort uiSendPort;
  List<ModelReminder> _reminders = [];
  bool _isDark = false;

  List<bool> _apToggle = [false, true];

  //Getter
  List<bool> get apToggle => _apToggle;

  bool get isDark => _isDark;

  List<ModelReminder> get reminders => _reminders;

  ModelReminder get upComingReminder => _upComingReminder;

  bool get isAmPmSelected => _apToggle[0] ? true : false;

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  ViewModelReminders() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    AndroidAlarmManager.initialize();

    port.listen((pos) async {
      debugPrint("Port status");
      await HiveDb.getInstance().openReminderBox();
      ModelReminder reminder = HiveDb.getInstance().reminder.getAt(pos - 5000);
      debugPrint("Reminder Status: ${reminder.status}");
      await AndroidAlarmManager.cancel(pos + 5000).then((value) async {
        await HiveDb.getInstance().reminder.putAt(reminder.id, reminder);
        debugPrint(
            "${HiveDb.getInstance().reminder.getAt(reminder.id).status}");
      });
    });
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

  fetchReminders() async {
    await HiveDb.getInstance().openReminderBox();
    bool ap = await sharedPreferences.getIsAP();
    _isDark = await sharedPreferences.getIsDark();
    if (ap) {
      _apToggle[0] = true;
      _apToggle[1] = false;
    }

    _reminders = HiveDb.getInstance().reminder.values.toList();

    await upcomingReminder();
    setBusy(false);
  }

  Future upcomingReminder() async {
    DateTime dateTime = DateTime.now().subtract(Duration(days: 2000));

    for (ModelReminder element in _reminders) {
      DateTime dt = DateTime.parse(element.dateTime);
      if (dt.isAfter(DateTime.now())) {
        if (dateTime.isBefore(dt)) {
          dateTime = dt;
          _upComingReminder = element;
        }
      }
    }
    HiveDb.getInstance().reminder.close();
  }

  //Notification Block
  Future addAlarm(ModelReminder modelReminder,
      {bool shouldUpdate = false}) async {
    await HiveDb.getInstance().openReminderBox();
    int length = HiveDb.getInstance().reminder.length;

    DateTime date = DateTime.parse(modelReminder.dateTime);

    int alarmId=0;

    await HiveDb.getInstance().openAlarmsBox();
    if (shouldUpdate) {
      await HiveDb.getInstance()
          .reminder
          .putAt(modelReminder.id, modelReminder);

    } else {
      modelReminder.id = length;
      await HiveDb.getInstance().reminder.add(modelReminder);
    }

    alarmId = modelReminder.id;

    await fetchReminders();
    await HiveDb.getInstance().reminder.close();


    await AndroidAlarmManager.oneShotAt(
      date,
      // Ensure we have a unique alarm ID.
      alarmId + 5000,
      callback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    ).then((value) async {});
  }

  Future removeAlarm(ModelReminder reminder, int pos) async {
    await AndroidAlarmManager.cancel(pos + 5000).then((value) async {
      await HiveDb.getInstance().openReminderBox();
      await HiveDb.getInstance().reminder.putAt(reminder.id, reminder);
      debugPrint("$value");
    });
    await fetchReminders();
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
      playSound: true,
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    ModelReminder rem = await getReminder(id);
    await flutterLocalNotificationsPlugin.show(
        id, "Prayer Reminder", "${rem.name}", platformChannelSpecifics);

    await HiveDb.getInstance().openReminderBox();
    ModelReminder reminder = HiveDb.getInstance().reminder.getAt(id - 5000);
    reminder.status = false;

    await AndroidAlarmManager.cancel(id + 5000).then((value) async {
      await HiveDb.getInstance().reminder.putAt(reminder.id, reminder);
      debugPrint("${HiveDb.getInstance().reminder.getAt(reminder.id).status}");
    });

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(id);
  }

  static Future<ModelReminder> getReminder(int pos) async {
    await Hive.initFlutter();
    HiveDb.getInstance().init();
    await HiveDb.getInstance().openReminderBox();
    ModelReminder reminder = HiveDb.getInstance().reminder.getAt(pos - 5000);
    await HiveDb.getInstance().reminder.close();
    return reminder;
  }

  Future removeItem(int pos) async {
    await AndroidAlarmManager.cancel(pos + 5000).then((value) async {
      await HiveDb.getInstance().openReminderBox();
      await HiveDb.getInstance().reminder.deleteAt(pos);
      await HiveDb.getInstance().reminder.close();
      fetchReminders();
      debugPrint("$value");
    });
  }

  @override
  void dispose() {
    print('I have been disposed!!');
    super.dispose();
  }
}
