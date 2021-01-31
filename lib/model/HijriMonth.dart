import 'package:hive/hive.dart';

part 'HijriMonth.g.dart';

@HiveType(typeId: 11, adapterName: 'HijriMonthAdapter')
class HijriMonth {
    HijriMonth({
        this.number,
        this.en,
        this.ar,
    });

    @HiveField(0)
    int number;
    @HiveField(1)
    String en;
    @HiveField(2)
    String ar;

    factory HijriMonth.fromJson(Map<String, dynamic> json) => HijriMonth(
        number: json["number"],
        en: json["en"],
        ar: json["ar"],
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "en": en,
        "ar": ar,
    };
}
