import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';

Widget LocationSettingsDialog()
{
 return AlertDialog(
    title: Text("Change settings"),
    content: Column(

      mainAxisSize: MainAxisSize.min,
      children: [
        Text("It seems like your location setting is disabled",style: TextStyle(color: Colors.grey),),
        SizedBox(height: SizeConfig.heightMultiplier*5,),
        MaterialButton(
          color: Colors.black,
          child: Text("Enable location settings",style: TextStyle(color: Colors.white),),
          onPressed: ()async {
            await Geolocator.openLocationSettings();
          },),
      ],
    ),
  );
}

Widget ShowSettingsDialog()
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