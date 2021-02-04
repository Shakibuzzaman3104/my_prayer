import 'package:flutter/material.dart';
import 'package:my_prayer/screens/widgets/tasbih/tajbih_list.dart';
import 'package:my_prayer/viewmodel/theme_viewmodel.dart';
import 'package:provider/provider.dart';

class ViewTasbihHistory extends StatefulWidget {
  @override
  _ViewTasbihHistoryState createState() => _ViewTasbihHistoryState();
}

class _ViewTasbihHistoryState extends State<ViewTasbihHistory> {


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (context, th, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            "Tasbih History",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          child: WidgetTajbihList(),
        ),
      );
    });
  }
}
