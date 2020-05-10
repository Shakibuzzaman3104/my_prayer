
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_prayer/provider_setup.dart';
import 'package:my_prayer/screens/views/home_page.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

void main()=>runApp(MultiProvider(child: new MyApp(), providers: providers,));


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModelPrayers>(
      create: (_)=>ViewModelPrayers(api: Provider.of(context)),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Quicksand',
          backgroundColor: const Color(0xff4844FF),
          textTheme: Theme.of(context).textTheme.copyWith(
            title: TextStyle(fontSize: 80,fontWeight: FontWeight.w300,color: Colors.white),
          )
        ),
        home: HomePage(),
      ),
    );
  }
}
