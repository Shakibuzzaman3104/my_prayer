import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';
import 'package:vector_math/vector_math.dart';

class ViewModelNavigation extends BaseViewModel {
  bool isOnline = false;

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  double _offset = 0.0;

  double get offset => _offset;

  ViewModelNavigation() {
    initConnection(connectionChanged);
  }

  Future getOffsetFromNorth() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    double currentLatitude = position.latitude;
    double currentLongitude = position.longitude;
    double targetLatitude = 21.42251500000001;
    double targetLongitude = 39.826201;

    var la_rad = radians(currentLatitude);
    var lo_rad = radians(currentLongitude);

    var de_la = radians(targetLatitude);
    var de_lo = radians(targetLongitude);

    var toDegrees = degrees(atan(sin(de_lo - lo_rad) /
        ((cos(la_rad) * tan(de_la)) - (sin(la_rad) * cos(de_lo - lo_rad)))));
    if (la_rad > de_la) {
      if ((lo_rad > de_lo || lo_rad < radians(-180.0) + de_lo) &&
          toDegrees > 0.0 &&
          toDegrees <= 90.0) {
        toDegrees += 180.0;
      } else if (lo_rad <= de_lo &&
          lo_rad >= radians(-180.0) + de_lo &&
          toDegrees > -90.0 &&
          toDegrees < 0.0) {
        toDegrees += 180.0;
      }
    }
    if (la_rad < de_la) {
      if ((lo_rad > de_lo || lo_rad < radians(-180.0) + de_lo) &&
          toDegrees > 0.0 &&
          toDegrees < 90.0) {
        toDegrees += 180.0;
      }
      if (lo_rad <= de_lo &&
          lo_rad >= radians(-180.0) + de_lo &&
          toDegrees > -90.0 &&
          toDegrees <= 0.0) {
        toDegrees += 180.0;
      }
    }
    return toDegrees;
  }
}
