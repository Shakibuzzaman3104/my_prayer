import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }
}

List<String> convertTimeToAP(String time) {
  List<String> split = time.split(":");
  int hour = int.parse(split[0]);
  int min = int.parse(split[1]);

  TimeOfDay noonTime = TimeOfDay(hour: hour, minute: min); // 3:00 PM

  if (noonTime.period == DayPeriod.am)
    return [time, " AM"];
  else
    return [
      "${noonTime.hourOfPeriod == 0 ? 12 : noonTime.hourOfPeriod < 10 ? "0${noonTime.hourOfPeriod}" : noonTime.hourOfPeriod}:${min < 10 ? "0$min" : min}",
      " PM"
    ];
}
