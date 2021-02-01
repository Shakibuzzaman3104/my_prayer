import 'package:hive/hive.dart';

import 'Datum.dart';

part 'ModelPrayer.g.dart';

@HiveType(typeId: 1, adapterName: 'ModelPrayerAdapter')
class ModelPrayer {
  ModelPrayer({this.code, this.status, this.data, this.hasError=false});

  @HiveField(0)
  int code;
  @HiveField(1)
  String status;
  @HiveField(2)
  List<Datum> data;
  bool hasError;

  factory ModelPrayer.fromJson(Map<String, dynamic> json) => ModelPrayer(
        code: json["code"],
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
