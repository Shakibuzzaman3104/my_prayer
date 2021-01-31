import 'package:hive/hive.dart';

import 'Designation.dart';
import 'GregorianMonth.dart';
import 'GregorianWeekday.dart';

part 'Gregorian.g.dart';

@HiveType(typeId: 5, adapterName: 'GregorianAdapter')

class Gregorian extends HiveObject{
    Gregorian({
        this.date,
        this.format,
        this.day,
        this.weekday,
        this.month,
        this.year,
        this.designation,
    });

    @HiveField(0)
    String date;
    @HiveField(1)
    String format;
    @HiveField(2)
    String day;
    @HiveField(3)
    GregorianWeekday weekday;
    @HiveField(4)
    GregorianMonth month;
    @HiveField(5)
    String year;
    @HiveField(6)
    Designation designation;

    factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
        date: json["date"],
        format: json["format"],
        day: json["day"],
        weekday: GregorianWeekday.fromJson(json["weekday"]),
        month: GregorianMonth.fromJson(json["month"]),
        year: json["year"],
        designation: Designation.fromJson(json["designation"]),
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday.toJson(),
        "month": month.toJson(),
        "year": year,
        "designation": designation.toJson(),
    };
}