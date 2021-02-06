import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/model/Datum.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelLocalPrayerParent.dart';
import 'package:my_prayer/model/ModelPrayer.dart';
import 'package:my_prayer/server_setup/api_client.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/utils/utils.dart';

class PrayerRepository {
  Future<int> addPrayer(ModelLocalPrayer prayer) async {}

  Future<void> deletePrayer(int id) async {}

  Future getPrayersFromServer() async {
    MySharedPreferences mySharedPreferences = MySharedPreferences.getInstance();

    Response response;

    int month = await mySharedPreferences.getPreviousMonth();
    Position lastPosition = await Geolocator.getLastKnownPosition();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    if (month != DateTime.now().month ||
        lastPosition.longitude != position.longitude ||
        lastPosition.latitude != position.latitude) {
      response = await fetchAndInsertData(position);
    } else {
      response = null;
    }

    return response;
  }

  Future fetchAndInsertData(Position position) async {
    Response response;
    MySharedPreferences mySharedPreferences = MySharedPreferences.getInstance();

    int method = await mySharedPreferences.getMethod();
    ApiClient apiClient = ApiClient.getInstance();

    double lat = position.latitude;
    double ln = position.longitude;

    if(await mySharedPreferences.getIsCustomLocation())
      {
         lat = await mySharedPreferences.getLatitude();
         ln = await mySharedPreferences.getLongitude();
      }

    response = await apiClient.fetchData(
        endPoint:
        "latitude=$lat&longitude=$ln&method=$method&month=${position.timestamp.month}&year=${position.timestamp.year}");
    await mySharedPreferences.setPreviousMonth(DateTime.now().month);
    await insertIntoDb(ModelPrayer.fromJson(response.data));

    final coordinates =
    new Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    await mySharedPreferences
        .setAddress("${first.locality}, ${first.countryName}")
        .then((value) => debugPrint("$value"));

    return response;
  }

  Future insertIntoDb(ModelPrayer prayer) async {
    await HiveDb.getInstance().openPrayerBox();
    await HiveDb.getInstance().openAlarmsBox();
    await HiveDb.getInstance().openLocalPrayerBox();
    await HiveDb.getInstance().openLocalPrayerParentBox();

    await HiveDb.getInstance().localPrayerParentBox.clear();
    await HiveDb.getInstance().prayerBox.clear();
    await HiveDb.getInstance().alarms.clear();
    await HiveDb.getInstance().localPrayerBox.clear();

    int id = 0;
    for (Datum data in prayer.data) {
      List<ModelLocalPrayer> localPrayer = [];
      localPrayer.add(ModelLocalPrayer(
          id: id++, name: "Fajr", time: data.timings.fajr.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++,
          name: "Sunrise",
          time: data.timings.sunrise.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++, name: "Dhuhr", time: data.timings.dhuhr.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++, name: "Asr", time: data.timings.asr.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++, name: "Sunset", time: data.timings.sunset.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++,
          name: "Maghrib",
          time: data.timings.maghrib.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++, name: "Isha", time: data.timings.isha.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++, name: "Imsak", time: data.timings.imsak.split(" (")[0]));
      localPrayer.add(ModelLocalPrayer(
          id: id++,
          name: "Midnight",
          time: data.timings.midnight.split(" (")[0]));

      await HiveDb.getInstance().localPrayerBox.addAll(localPrayer);

      HiveList<ModelLocalPrayer> atby =
          HiveList(HiveDb.getInstance().localPrayerBox);

      atby.addAll(localPrayer);

      await HiveDb.getInstance().localPrayerParentBox.add(
          ModelLocalPrayerParent(date: data.date.timestamp, prayers: atby));
    }

    for (int i = 0; i < 9; i++) {
      await HiveDb.getInstance().alarms.add(false);
    }

    await HiveDb.getInstance().prayerBox.add(prayer);
    
    await HiveDb.getInstance().prayerBox.close();
    await HiveDb.getInstance().alarms.close();
    await HiveDb.getInstance().localPrayerBox.close();
    await HiveDb.getInstance().localPrayerParentBox.close();
  }

  Future updatePrayer(ModelLocalPrayer modelPrayer) async {}
}
