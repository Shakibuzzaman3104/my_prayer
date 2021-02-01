
import 'package:hive/hive.dart';
import 'package:my_prayer/model/LocalPrayer.dart';

part 'ModelLocalPrayerParent.g.dart';

@HiveType(typeId: 19, adapterName: 'ModelLocalPrayerParentAdapter')
class ModelLocalPrayerParent{
    @HiveField(0)
    String date;
    @HiveField(1)
    HiveList<ModelLocalPrayer> prayers;

    ModelLocalPrayerParent({this.date, this.prayers});

}