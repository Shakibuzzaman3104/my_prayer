import 'package:hive/hive.dart';

import 'Gregorian.dart';
import 'Hijri.dart';

part 'Date.g.dart';

@HiveType(typeId: 4, adapterName: 'DateAdapter')
class Date extends HiveObject{
    Date({
        this.readable,
        this.timestamp,
        this.gregorian,
        this.hijri,
    });

    @HiveField(0)
    String readable;
    @HiveField(1)
    String timestamp;
    @HiveField(2)
    Gregorian gregorian;
    @HiveField(3)
    Hijri hijri;

    factory Date.fromJson(Map<String, dynamic> json) => Date(
        readable: json["readable"],
        timestamp: json["timestamp"],
        gregorian: Gregorian.fromJson(json["gregorian"]),
        hijri: Hijri.fromJson(json["hijri"]),
    );

    Map<String, dynamic> toJson() => {
        "readable": readable,
        "timestamp": timestamp,
        "gregorian": gregorian.toJson(),
        "hijri": hijri.toJson(),
    };
}