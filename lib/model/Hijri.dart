import 'package:hive/hive.dart';

import 'Designation.dart';
import 'HijriMonth.dart';
import 'HijriWeekday.dart';

part 'Hijri.g.dart';

@HiveType(typeId: 12, adapterName: 'HijriAdapter')

class Hijri extends HiveObject{
    Hijri({
        this.date,
        this.format,
        this.day,
        this.weekday,
        this.month,
        this.year,
        this.designation,
        this.holidays,
    });

    @HiveField(0)
    String date;
    @HiveField(1)
    String format;
    @HiveField(2)
    String day;
    @HiveField(3)
    HijriWeekday weekday;
    @HiveField(4)
    HijriMonth month;
    @HiveField(5)
    String year;
    @HiveField(6)
    Designation designation;
    @HiveField(7)
    List<dynamic> holidays;

    factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
        date: json["date"],
        format: json["format"],
        day: json["day"],
        weekday: HijriWeekday.fromJson(json["weekday"]),
        month: HijriMonth.fromJson(json["month"]),
        year: json["year"],
        designation: Designation.fromJson(json["designation"]),
        holidays: List<dynamic>.from(json["holidays"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday.toJson(),
        "month": month.toJson(),
        "year": year,
        "designation": designation.toJson(),
        "holidays": List<dynamic>.from(holidays.map((x) => x)),
    };
}