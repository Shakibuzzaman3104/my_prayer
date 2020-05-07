import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'local_database/sqf_database.dart';
import 'services/api.dart';


List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: DBHelper())
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<DBHelper, Api>(
    update: (context, helper, api) =>
        Api(dbHelper: helper),
  ),

  ProxyProvider<Api, ViewModelPrayers>(
    update: (context, api, prayer) =>
        ViewModelPrayers(api: api),
  ),

];

/*List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
  )
];*/
