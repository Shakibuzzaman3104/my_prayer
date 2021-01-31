import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/localization/Localization.dart';
import 'package:my_prayer/provider_setup.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/views/home.dart';
import 'package:my_prayer/screens/views/home_page.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'viewmodel/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreferences.getInstance();
  await Hive.initFlutter();
  HiveDb.getInstance().init();
  LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.fetchLocale();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      child: new MyApp(languageProvider: languageProvider),
      providers: providers,
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final LanguageProvider languageProvider;

  MyApp({this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageProvider>(
      create: (_) => languageProvider,
      child: Consumer<LanguageProvider>(
        builder: (context, model, child) => LayoutBuilder(
          builder: (context, constraints) => OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                locale: model.appLocal,
                supportedLocales: [
                  Locale('en', 'US'),
                  Locale('bn', ''),
                ],
                title: 'Flutter Demo',
                localizationsDelegates: [
                  Localization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    fontFamily: 'Quicksand',
                    backgroundColor: Colors.indigo,
                    textTheme: Theme.of(context).textTheme.copyWith(
                          title: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        )),
                home: HomePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
