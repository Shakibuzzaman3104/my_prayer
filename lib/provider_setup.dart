import 'package:my_prayer/viewmodel/viewmodel_home.dart';
import 'package:my_prayer/viewmodel/viewmodel_navigation.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
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
  ChangeNotifierProvider<ViewModelPrayers>(create: (_) => ViewModelPrayers()),
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
