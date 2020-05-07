import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_prayer/models/model_prayer.dart';
import 'package:my_prayer/services/api.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelPrayers extends BaseViewModel {
  Api _api;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;


  ViewModelPrayers({this.context, @required Api api}) {
    initNotification();
    this._api = api;
  }

  var time = TimeOfDay.fromDateTime(DateTime.now());
  ModelPrayer nextPrayer = ModelPrayer();
  List<ModelPrayer> prayers;

  Future fetchPrayers() async {
    setBusy(true);
    this.prayers = await _api.getPrayers();
    setBusy(false);
  }

  Future upcomingPrayer() async {
    setBusy(true);
    await _api.getPrayers().then((val) => {nextPrayer = getNext(val)});

    if (int.parse(nextPrayer.hour) > 12)
      nextPrayer.hour = (int.parse(nextPrayer.hour) - 12).toString();

    setBusy(false);
  }

  Future addPrayer(ModelPrayer prayer) async {
    setBusy(true);
    await _api.addPrayer(prayer);
    fetchPrayers();
  }

  ModelPrayer getNext(List<ModelPrayer> val) {
    double currentTimeParse = double.parse("${time.hour}.${time.minute}");
    double lastPrayerTime =
        double.parse("${val[val.length - 1].hour}.${val[val.length - 1].min}");

    print(lastPrayerTime);
    return currentTimeParse > lastPrayerTime
        ? val[0]
        : val.firstWhere((res) {
            double times = double.parse("${res.hour}.${res.min}");
            return currentTimeParse < times;
          });
  }


  Future updateStatus(int id, int status) async {
    await _api.updateStatus(id, status);
    fetchPrayers();
  }

  Future updatePrayer(ModelPrayer modelPrayer) async {
    await _api.updatePrayer(modelPrayer);
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

  void addNotification({int pos, int id}) async {
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
    notifyListeners();
  }

  @override
  void dispose() {
    print('I have been disposed!!');
    super.dispose();
  }
}
