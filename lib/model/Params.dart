import 'package:hive/hive.dart';

part 'Params.g.dart';

@HiveType(typeId: 14, adapterName: 'ParamsAdapter')
class Params extends HiveObject{
  Params({
    this.fajr,
    this.isha,
  });

  @HiveField(0)
  int fajr;
  @HiveField(1)
  int isha;

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        fajr: json["Fajr"],
        isha: json["Isha"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Isha": isha,
      };
}
