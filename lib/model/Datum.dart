import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';

import 'Date.dart';
import 'Meta.dart';
import 'Timings.dart';

part 'Datum.g.dart';

@HiveType(typeId: 2, adapterName: 'DatumAdapter')

class Datum extends HiveObject{
    Datum({
        this.timings,
        this.date,
        this.meta,
    });
    @HiveField(0)
    Timings timings;
    @HiveField(1)
    Date date;
    @HiveField(2)
    Meta meta;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        timings: Timings.fromJson(json["timings"]),
        date: Date.fromJson(json["date"]),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "timings": timings.toJson(),
        "date": date.toJson(),
        "meta": meta.toJson(),
    };
}
