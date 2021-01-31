import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'api/api.dart';


import 'viewmodel/language_provider.dart';


List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
  ChangeNotifierProvider<ViewModelPrayers>(create: (_) => ViewModelPrayers()),
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
