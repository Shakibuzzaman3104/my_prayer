import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/model/Datum.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelPrayer.dart';
import 'package:my_prayer/server_setup/api_client.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/utils/utils.dart';

class Api {
  Future<int> addPrayer(LocalPrayer prayer) async {}

  Future<void> deletePrayer(int id) async {}

  Future getPrayersFromServer() async {
    MySharedPreferences mySharedPreferences = MySharedPreferences.getInstance();
    await mySharedPreferences.createPref();

    Response response;

    int month = await mySharedPreferences.getPreviousMonth();
    Position lastPosition = await Geolocator.getLastKnownPosition();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    if (month != DateTime.now().month ||
        lastPosition.longitude != position.longitude ||
        lastPosition.latitude != position.latitude) {
      await determinePosition().then((_) async {
        int method = await mySharedPreferences.getMethod();
        ApiClient apiClient = ApiClient.getInstance();
        response = await apiClient.fetchData(
            endPoint:
                "latitude=${position.latitude}&longitude=${position.longitude}&method=$method&month=${position.timestamp.month}&year=${position.timestamp.year}}");

        mySharedPreferences.setPreviousMonth(DateTime.now().month);
        insertIntoDb(ModelPrayer.fromJson(response.data));
      }).catchError((error) {
        response = error;
      });
    } else {
      response = null;
    }

    return response;
  }

  insertIntoDb(ModelPrayer prayer) async {
    await HiveDb.getInstance().openDatumBox();
    await HiveDb.getInstance().openPrayerBox();

    await HiveDb.getInstance().datumBox.clear();
    await HiveDb.getInstance().prayerBox.clear();

/*    for (Datum data in prayer.data) {
      await HiveDb.getInstance()
          .gregorianWeekdayBox
          .add(data.date.gregorian.weekday);
      await HiveDb.getInstance().gregorianMonthBox.add(data.date.gregorian.month);
    }*/

    await HiveDb.getInstance().datumBox.addAll(prayer.data);
    HiveList<Datum> datum = HiveList(HiveDb.getInstance().datumBox);
    datum.addAll(prayer.data);

    await HiveDb.getInstance().prayerBox.add(prayer);

  }

  Future updateStatus(int id, int status) async {}

  Future updatePrayer(LocalPrayer modelPrayer) async {}
}
