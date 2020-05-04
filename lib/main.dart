import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_prayer/provider_setup.dart';
import 'package:my_prayer/screens/views/home_page.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        backgroundColor: const Color(0xff0A74C5),
      ),
      home: MultiProvider(
        child: HomePage(),
        providers: providers,
      ),
    );
  }
}
