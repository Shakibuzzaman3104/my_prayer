import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelLocalPrayerParent.dart';
import 'package:my_prayer/model/ModelPrayer.dart';
import 'package:my_prayer/repository/repository.dart';
import 'package:my_prayer/server_setup/local_database.dart';

import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelPrayers extends BaseViewModel {
  PrayerRepository _repository;
  bool isOnline = false;
  ModelLocalPrayerParent _parentPrayer;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  ViewModelPrayers({this.context}) {
    initNotification();
    this._repository = PrayerRepository();
    _prayers = ModelPrayer();
    _parentPrayer = ModelLocalPrayerParent();
  }

  var time;
  ModelLocalPrayer nextPrayer = ModelLocalPrayer();
  ModelPrayer _prayers;

  ModelPrayer get prayers => _prayers;

  ModelLocalPrayerParent get parentPrayer => _parentPrayer;

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
    getDataFromDB();
  }

  getDataFromDB() async {
    await HiveDb.getInstance().openPrayerBox();
    await HiveDb.getInstance().openLocalPrayerParentBox();
    await HiveDb.getInstance().openLocalPrayerBox();
    if (HiveDb.getInstance().prayerBox.isNotEmpty) {
      _prayers = HiveDb.getInstance().prayerBox.get(0);
    }
    if (HiveDb.getInstance().localPrayerParentBox.isNotEmpty) {
      _parentPrayer = HiveDb.getInstance().localPrayerParentBox.values.last;
      debugPrint(
          "ViewModel ${_parentPrayer.prayers.length}");
      /**/

    } else
      debugPrint("Not Found");

    HiveDb.getInstance().prayerBox.close();
    HiveDb.getInstance().localPrayerParentBox.close();

    setBusy(false);
  }

  Future upcomingPrayer() async {
    time = TimeOfDay.fromDateTime(DateTime.now());

    setBusy(false);
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

/*  Future addNotification({int pos, int id}) async {
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
  }*/

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
