
import 'package:hive/hive.dart';

part 'GregorianMonth.g.dart';

@HiveType(typeId: 8, adapterName: 'GregorianMonthAdapter')
class GregorianMonth extends HiveObject{
    GregorianMonth({
        this.number,
        this.en,
    });

    @HiveField(0)
    int number;
    @HiveField(1)
    String en;

    factory GregorianMonth.fromJson(Map<String, dynamic> json) => GregorianMonth(
        number: json["number"],
        en: json["en"],
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "en": en,
    };
}