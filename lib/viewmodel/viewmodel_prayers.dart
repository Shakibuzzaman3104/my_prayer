import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_prayer/api/api.dart';
import 'package:my_prayer/model/LocalPrayer.dart';

import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelPrayers extends BaseViewModel {
  Api _api;
  bool isOnline = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  ViewModelPrayers({this.context}) {
    initNotification();
    this._api = Api();
    _prayers = List();
  }

  var time;
  LocalPrayer nextPrayer = LocalPrayer();
  List<LocalPrayer> _prayers;

  List<LocalPrayer> get prayers {
    return _prayers;
  }

  Future fetchPrayers() async {
    await checkConnectionStatus().then((value) {
      _api.getPrayersFromServer().then((response) {
        if (response is DioError) {
          return response;
        } else if (response == null) {
          print("Already updated");
        } else {

        }
      });
    });
    await upcomingPrayer();

    setBusy(false);
  }

  Future upcomingPrayer() async {
    time = TimeOfDay.fromDateTime(DateTime.now());
    if (nextPrayer.hour != null) if (int.parse(nextPrayer.hour) > 12)
      nextPrayer.hour = (int.parse(nextPrayer.hour) - 12).toString();

    setBusy(false);
  }

  Future addPrayer(LocalPrayer prayer) async {
    //setBusy(true);
    var res = await _api.addPrayer(prayer);
    await fetchPrayers();
    return res;
  }

  LocalPrayer getNext(List<LocalPrayer> val) {
    double currentTimeParse = double.parse("${time.hour}.${time.minute}");

    double finalTime = 23.59;
    LocalPrayer prayer = LocalPrayer();
    for (var res in val) {
      print("Times: ${res.min}");
      double times = double.parse("${res.hour}.${res.min}");
      if (currentTimeParse < times) {
        if (finalTime > times) {
          finalTime = times;

          prayer = res;
        }
      }
    }

    return prayer;
  }

  Future updateStatus(int id, int status) async {
    await _api.updateStatus(id, status);
    fetchPrayers();
  }

  Future deletePrayer(int id) async {
    removeNotification(id);
    await _api.deletePrayer(id);
    fetchPrayers();
  }

  Future updatePrayer(LocalPrayer modelPrayer, int pos) async {
    await _api.updatePrayer(modelPrayer);
    // await removeNotification(modelPrayer.id);
    // addNotification(pos: pos, id: modelPrayer.id);
    fetchPrayers();
  }

  //Notification Block

  void initNotification() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
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
    print(int.parse(prayers[pos].hour));

    var time =
        Time(int.parse(prayers[pos].hour), int.parse(prayers[pos].min), 0);
    //var time = Time(13, 17, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '${id.toString()}',
        '${prayers[pos].name}',
        'Its time for ${prayers[pos].name} Salah');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        '${prayers[pos].name} prayer',
        "It's time for your prayer",
        time,
        platformChannelSpecifics);

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
