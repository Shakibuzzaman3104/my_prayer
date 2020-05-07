
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_prayer/provider_setup.dart';
import 'package:my_prayer/screens/views/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        backgroundColor: const Color(0xff0A74C5),
        textTheme: Theme.of(context).textTheme.copyWith(
          title: TextStyle(fontSize: 80,fontWeight: FontWeight.w500,color: Colors.white),
        )
      ),
      home: MultiProvider(
        child: HomePage(),
        providers: providers,
      ),
    );
  }
}
