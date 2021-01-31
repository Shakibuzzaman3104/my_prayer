import 'package:hive/hive.dart';

import 'Method.dart';

part 'Meta.g.dart';

@HiveType(typeId: 16, adapterName: 'MetaAdapter')
class Meta {
    Meta({
        this.latitude,
        this.longitude,
        this.timezone,
        this.method,
        this.latitudeAdjustmentMethod,
        this.midnightMode,
        this.school,
        this.offset,
    });

    @HiveField(0)
    double latitude;
    @HiveField(1)
    double longitude;
    @HiveField(2)
    String timezone;
    @HiveField(3)
    Method method;
    @HiveField(4)
    String latitudeAdjustmentMethod;
    @HiveField(5)
    String midnightMode;
    @HiveField(6)
    String school;
    @HiveField(7)
    Map<String, int> offset;

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        timezone: json["timezone"],
        method: Method.fromJson(json["method"]),
        latitudeAdjustmentMethod: json["latitudeAdjustmentMethod"],
        midnightMode: json["midnightMode"],
        school: json["school"],
        offset: Map.from(json["offset"]).map((k, v) => MapEntry<String, int>(k, v)),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "method": method.toJson(),
        "latitudeAdjustmentMethod": latitudeAdjustmentMethod,
        "midnightMode": midnightMode,
        "school": school,
        "offset": Map.from(offset).map((k, v) => MapEntry<String, dynamic>(k, v)),
    };
}