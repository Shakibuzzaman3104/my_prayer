import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/models/model_prayer.dart';
import 'package:my_prayer/services/api.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelPrayers extends BaseViewModel {
  Api _api;

  ViewModelPrayers({
    @required Api api,
  }) : _api = api;

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
    setBusy(false);
  }

  ModelPrayer getNext(List<ModelPrayer> val) {
    double currentTimeParse = double.parse("${time.hour}.${time.minute}");
    double lastPrayerTime =
        double.parse("${val[val.length - 1].hour}.${val[val.length - 1].min}");

    return currentTimeParse > lastPrayerTime
        ? true
        : val.firstWhere((res) {
            double times = double.parse("${res.hour}.${res.min}");
            return currentTimeParse < times;
          });
  }

  Future<int> addNote(ModelPrayer prayer) async {
    var response = await _api.addPrayer(prayer);
    fetchPrayers();
    return response;
  }

  @override
  void dispose() {
    print('I have been disposed!!');
    super.dispose();
  }
}
