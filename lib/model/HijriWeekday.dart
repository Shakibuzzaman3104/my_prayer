import 'package:hive/hive.dart';

part 'HijriWeekday.g.dart';

@HiveType(typeId: 10, adapterName: 'HijriWeekdayAdapter')
class HijriWeekday extends HiveObject{
    HijriWeekday({
        this.en,
        this.ar,
    });

    @HiveField(0)
    String en;
    @HiveField(1)
    String ar;

    factory HijriWeekday.fromJson(Map<String, dynamic> json) => HijriWeekday(
        en: json["en"],
        ar: json["ar"],
    );

    Map<String, dynamic> toJson() => {
        "en": en,
        "ar": ar,
    };
}