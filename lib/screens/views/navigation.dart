import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/navigation/qiblah_compass.dart';
import 'package:my_prayer/utils/color_constants.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:my_prayer/viewmodel/viewmodel_navigation.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  CompassEvent _lastRead;
  DateTime _lastReadAt;
  MySharedPreferences mySharedPreferences = MySharedPreferences.getInstance();

  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  void initState() {
    ViewModelNavigation navigation =
        Provider.of<ViewModelNavigation>(context, listen: false);
    navigation.checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          if (snapshot.hasError)
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          if (snapshot.data)
            return Consumer<ViewModelNavigation>(
                builder: (context, model, child) {
              if (model.busy) {
                return Center(
                  child: Text(
                    "Loading compass....",
                    style: TextStyle(fontSize: SizeConfig.textMultiplier * 2),
                  ),
                );
              } else {
                if (model.permission == PERMISSIONS.APPROVED) {
                  return QiblahCompass();
                } else if (model.permission == PERMISSIONS.DENIED) {
                  return Center(
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text("Request Permission"),
                    ),
                  );
                } else if (model.permission == PERMISSIONS.PERMANENTLY_DENIED) {
                  return Center(
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text("Open permission settings"),
                    ),
                  );
                } else
                  return Center(
                    child: RaisedButton(
                      onPressed: () async {
                        await Geolocator.openLocationSettings();
                      },
                      child: Text("Enable location service"),
                    ),
                  );
              }
            });
          else
            return Container();
        },
      ),
    );
  }
}
