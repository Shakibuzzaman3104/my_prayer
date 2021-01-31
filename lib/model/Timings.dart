import 'package:hive/hive.dart';

part 'Timings.g.dart';

@HiveType(typeId: 3, adapterName: 'TimingsAdapter')
class Timings extends HiveObject {
  Timings({
    this.isActive,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
  });

  @HiveField(0)
  String fajr;
  @HiveField(1)
  String sunrise;
  @HiveField(2)
  String dhuhr;
  @HiveField(3)
  String asr;
  @HiveField(4)
  String sunset;
  @HiveField(5)
  String maghrib;
  @HiveField(6)
  String isha;
  @HiveField(7)
  String imsak;
  @HiveField(8)
  String midnight;
  @HiveField(9)
  int isActive;

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        sunset: json["Sunset"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        imsak: json["Imsak"],
        midnight: json["Midnight"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Sunset": sunset,
        "Maghrib": maghrib,
        "Isha": isha,
        "Imsak": imsak,
        "Midnight": midnight,
      };
}
