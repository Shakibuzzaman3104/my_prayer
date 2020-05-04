import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_prayer/utils/router_path_constants.dart';

import 'screens/views/add_prayer.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterPathsConstants.ADD_PRAYER:
        return MaterialPageRoute(builder: (_) => AddPrayer());
    /*  case RoutePaths.CHECKLIST_DETAILS:
        return MaterialPageRoute(builder: (_) => ChecklistDetailsView());
      case RoutePaths.NOTES_DETAILS:
       // var post = settings.arguments as Post;
        return MaterialPageRoute(builder: (_) => NotesDetailsView());*/
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
