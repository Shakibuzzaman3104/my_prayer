import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Widget LocationSettingsDialog()
{
 return AlertDialog(
    title: Text("Change settings"),
    content: MaterialButton(
      child: Text("Grant permission"),
      onPressed: ()async {
        await Geolocator.openAppSettings();
      },),
  );
}

Widget ShowSettingsDialog()
{
  return AlertDialog(
    title: Text("Change settings"),
    content: MaterialButton(
      child: Text("Open settings"),
      onPressed: ()async {
        await Geolocator.openLocationSettings();
      },),
  );
}