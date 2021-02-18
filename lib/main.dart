import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/localization/Localization.dart';
import 'package:my_prayer/provider_setup.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/router.dart';
import 'package:my_prayer/screens/views/home.dart';
import 'package:my_prayer/screens/views/onboarding_view.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/viewmodel/theme_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'utils/themeData.dart';
import 'viewmodel/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var instance = MySharedPreferences.getInstance();
  await instance.createPref();
  bool darkModeOn = await instance.getIsDark();
  bool isFirstBoot = await instance.getIsFirstBoot();
  await Hive.initFlutter();
  HiveDb.getInstance().init();
  LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.fetchLocale();
  runApp(
    MultiProvider(
      child: ChangeNotifierProvider<ThemeViewModel>(
        create: (_) => ThemeViewModel(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(
          languageProvider: languageProvider,isFirstBoot:isFirstBoot
        ),
      ),
      providers: providers,
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final LanguageProvider languageProvider;
  final bool isFirstBoot;

  MyApp({this.languageProvider,this.isFirstBoot});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final themeViewModel = Provider.of<ThemeViewModel>(context);
    themeViewModel.getIsDark();
    return ChangeNotifierProvider<LanguageProvider>(
      create: (_) => languageProvider,
      child: Consumer<LanguageProvider>(
        builder: (context, model, child) => LayoutBuilder(
          builder: (context, constraints) => OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                onGenerateRoute: PathRouter.generateRoute,
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
                theme: themeViewModel.getTheme(),
                darkTheme: darkTheme,
                home: Consumer<ThemeViewModel>(
                  builder: (context, themeModel, child) {
                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        // transparent status bar
                        systemNavigationBarColor:
                            themeViewModel.theme ? Colors.white : Colors.black,
                        // navigation bar color
                        statusBarIconBrightness:
                        themeViewModel.theme  ? Brightness.light : Brightness.dark,
                        // status bar icons' color
                        systemNavigationBarIconBrightness: themeViewModel.theme
                            ? Brightness.light
                            : Brightness.dark, //navigation bar icons' color
                      ),
                      child:isFirstBoot?OnBoardingPage():HomeView(),
                    );
                  }
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
