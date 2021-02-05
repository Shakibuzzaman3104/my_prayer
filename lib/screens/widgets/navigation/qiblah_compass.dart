import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/utils/color_constants.dart';

class QiblahCompass extends StatefulWidget {
  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {

  @override
  void initState() {
    super.initState();
  }

  final _compassSvg = SvgPicture.asset(
    'assets/img/compass_back.svg',
    height: SizeConfig.imageSizeMultiplier * 90,
    width: SizeConfig.imageSizeMultiplier * 90,
  );
  final _needleSvg = SvgPicture.asset(
    'assets/img/compass_arrow.svg',
    fit: BoxFit.contain,
    height: SizeConfig.imageSizeMultiplier * 70,
    alignment: Alignment.center,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child:  StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(
            child: Text(
              "Loading compass....",
              style: TextStyle(fontSize: SizeConfig.textMultiplier * 2),
            ),
          );

        final qiblahDirection = snapshot.data;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "QIBLAH",
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 3,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Transform.rotate(
                  angle: ((qiblahDirection.direction ?? 0) * (pi / 180) * -1),
                  child: _compassSvg,
                ),
                Transform.rotate(
                  angle: ((qiblahDirection.qiblah ?? 0) * (pi / 180) * -1),
                  alignment: Alignment.center,
                  child: _needleSvg,
                ),
              ],
            ),
            Text(
              "Direction: ${qiblahDirection.offset.toStringAsFixed(3)}°",
              style: TextStyle(fontSize: SizeConfig.textMultiplier * 2,color: Theme.of(context).accentColor),
            ),
          ],
        );
      },
    )
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterQiblah().dispose();
  }
}


