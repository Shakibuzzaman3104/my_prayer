import 'package:my_prayer/viewmodel/viewmodel_home.dart';
import 'package:my_prayer/viewmodel/viewmodel_navigation.dart';
import 'package:my_prayer/viewmodel/viewmodel_dashboard.dart';
import 'package:my_prayer/viewmodel/viewmodel_reminders.dart';
import 'package:my_prayer/viewmodel/viewmodel_settings.dart';
import 'package:my_prayer/viewmodel/viewmodel_tasbih.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'viewmodel/language_provider.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
  ChangeNotifierProvider<ViewModelHome>(create: (_) => ViewModelHome()),
  ChangeNotifierProvider<ViewModelDashboard>(create: (_) => ViewModelDashboard()),
  ChangeNotifierProvider<ViewModelReminders>(create: (_) => ViewModelReminders()),
  ChangeNotifierProvider<ViewmodelTasbih>(create: (_) => ViewmodelTasbih()),
  ChangeNotifierProvider<ViewModelSettings>(create: (_) => ViewModelSettings()),
  ChangeNotifierProvider<ViewModelNavigation>(
      create: (_) => ViewModelNavigation()),
];

List<SingleChildWidget> dependentServices = [
  /*ProxyProvider<Api, ViewModelPrayers>(
    update: (context, api, prayer) =>
        ViewModelPrayers(api: api),
  ),*/
];

/*List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
  )
];*/
