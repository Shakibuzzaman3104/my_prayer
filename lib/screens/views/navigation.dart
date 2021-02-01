import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
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

  ViewModelNavigation navigation;

  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  @override
  void initState() {
    navigation = Provider.of<ViewModelNavigation>(context,listen: false);
    navigation.getOffsetFromNorth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorConstants.BACKGROUND,
        appBar: AppBar(
          title: const Text('Flutter Compass'),
        ),
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
              return QiblahCompass();
            else
              return Container();
          },
        ),

      ),
    );
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          RaisedButton(
            child: Text('Read Value'),
            onPressed: () async {
              final CompassEvent tmp = await FlutterCompass.events.first;
              setState(() {
                _lastRead = tmp;
                _lastReadAt = DateTime.now();
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$_lastRead',
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption,
                  ),
                  Text(
                    '$_lastReadAt',
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return Consumer<ViewModelNavigation>(
      builder: (context,nav,child)=>StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error reading heading: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          double direction = snapshot.data.heading;

          // if direction is null, then device does not support this sensor
          // show error message
          if (direction == null)
            return Center(
              child: Text("Device does not have sensors !"),
            );

          return Material(
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Transform.rotate(
                angle:((pi / 180) * -1) * direction??0,
                child: SvgPicture.asset('assets/img/compass.svg',color: ColorConstants.TITLE,),
              ),
            ),
          );
        },
      ),
    );
  }



/*  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          RaisedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              Permiss().requestPermissions(
                  [PermissionGroup.locationWhenInUse]).then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              PermissionHandler().openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }*/

/*  void _fetchPermissionStatus() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }*/

}
