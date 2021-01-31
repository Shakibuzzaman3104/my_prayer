import 'package:hive/hive.dart';

part 'GregorianWeekday.g.dart';

@HiveType(typeId: 6, adapterName: 'GregorianWeekdayAdapter')
class GregorianWeekday extends HiveObject {
  GregorianWeekday({
    this.en,
  });

  @HiveField(0)
  String en;

  factory GregorianWeekday.fromJson(Map<String, dynamic> json) =>
      GregorianWeekday(
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
      };
}
