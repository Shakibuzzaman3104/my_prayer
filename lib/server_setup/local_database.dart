import 'package:hive/hive.dart';
import 'package:my_prayer/model/Date.dart';
import 'package:my_prayer/model/Datum.dart';
import 'package:my_prayer/model/Designation.dart';
import 'package:my_prayer/model/Gregorian.dart';
import 'package:my_prayer/model/GregorianMonth.dart';
import 'package:my_prayer/model/GregorianWeekday.dart';
import 'package:my_prayer/model/Hijri.dart';
import 'package:my_prayer/model/HijriMonth.dart';
import 'package:my_prayer/model/HijriWeekday.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/Meta.dart';
import 'package:my_prayer/model/Method.dart';
import 'package:my_prayer/model/ModelLocalPrayerParent.dart';
import 'package:my_prayer/model/ModelPrayer.dart';
import 'package:my_prayer/model/ModelReminder.dart';
import 'package:my_prayer/model/ModelTasbih.dart';
import 'package:my_prayer/model/Timings.dart';
import 'package:my_prayer/utils/LocalDbConstants.dart';
import 'package:path_provider/path_provider.dart';

class HiveDb {
  HiveDb._();

  static HiveDb _instance;

  static HiveDb getInstance() {
    if (_instance == null) _instance = HiveDb._();
    return _instance;
  }

  Box<ModelPrayer> prayerBox;
  Box<ModelLocalPrayer> localPrayerBox;
  Box<ModelLocalPrayerParent> localPrayerParentBox;
  Box<Datum> datumBox;
  Box<Timings> timingsBox;
  Box<Date> dateBox;
  Box<Meta> metaBox;
  Box<Gregorian> gregorianBox;
  Box<Hijri> hijriBox;
  Box<GregorianWeekday> gregorianWeekdayBox;
  Box<GregorianMonth> gregorianMonthBox;
  Box<Designation> designationBox;
  Box<HijriWeekday> hijriWeekdayBox;
  Box<HijriMonth> hijriMonthBox;
  Box<Method> methodBox;
  Box<bool> alarms;
  Box<ModelReminder> reminder;
  Box<ModelTasbih> tasbih;

  Future init() async {
    var _directory = await getApplicationDocumentsDirectory();

    Hive
      ..init(_directory.path)
      ..registerAdapter(ModelPrayerAdapter())
      ..registerAdapter(DatumAdapter())
      ..registerAdapter(DateAdapter())
      ..registerAdapter(DesignationAdapter())
      ..registerAdapter(GregorianAdapter())
      ..registerAdapter(GregorianMonthAdapter())
      ..registerAdapter(GregorianWeekdayAdapter())
      ..registerAdapter(HijriAdapter())
      ..registerAdapter(HijriMonthAdapter())
      ..registerAdapter(HijriWeekdayAdapter())
      ..registerAdapter(MetaAdapter())
      ..registerAdapter(MethodAdapter())
      ..registerAdapter(LocalPrayerAdapter())
      ..registerAdapter(ModelLocalPrayerParentAdapter())
      ..registerAdapter(ModelReminderAdapter())
      ..registerAdapter(ModelTasbihAdapter())
      ..registerAdapter(TimingsAdapter());
  }

  Future openPrayerBox() async {
    prayerBox = await Hive.openBox(LocalDbConstants.PRAYER);
  }

  Future openDatumBox() async =>
      datumBox = await Hive.openBox(LocalDbConstants.DATUM);

  Future openDateBox() async =>
      dateBox = await Hive.openBox(LocalDbConstants.DATE);

  Future openDesignationBox() async =>
      designationBox = await Hive.openBox(LocalDbConstants.DESIGNATION);

  Future openGregorianBox() async =>
      gregorianBox = await Hive.openBox(LocalDbConstants.GREGORIAN);

  Future openGregorianMonthBox() async =>
      gregorianMonthBox = await Hive.openBox(LocalDbConstants.GREGORIANMONTH);

  Future openGregorianWeekBox() async =>
      gregorianWeekdayBox = await Hive.openBox(LocalDbConstants.GREGORIANWEEK);

  Future openHijriBox() async =>
      hijriBox = await Hive.openBox(LocalDbConstants.HIJRI);

  Future openHijriMonthBox() async =>
      hijriMonthBox = await Hive.openBox(LocalDbConstants.HIJRIMONTH);

  Future openHijriWeekBox() async =>
      hijriWeekdayBox = await Hive.openBox(LocalDbConstants.HIJRIWEEK);

  Future openMetaBox() async =>
      metaBox = await Hive.openBox(LocalDbConstants.META);


  Future openTimingsBox() async =>
      timingsBox = await Hive.openBox(LocalDbConstants.TIMINGS);

  Future openMethodBox() async =>
      methodBox = await Hive.openBox(LocalDbConstants.METHOD);

  Future openLocalPrayerBox() async =>
      localPrayerBox = await Hive.openBox(LocalDbConstants.LOCAL_PRAYER);

  Future openLocalPrayerParentBox() async => localPrayerParentBox =
      await Hive.openBox(LocalDbConstants.LOCAL_PRAYER_PARENT);

  Future openAlarmsBox() async =>
      alarms = await Hive.openBox(LocalDbConstants.ALARMS);

  Future openReminderBox() async =>
      reminder = await Hive.openBox(LocalDbConstants.REMINDER);

  Future openTashbihBox() async =>
      tasbih = await Hive.openBox(LocalDbConstants.TASBIH);

  close(String name) => Hive.box(name).close();
}
