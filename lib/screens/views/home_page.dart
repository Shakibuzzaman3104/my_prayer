import 'package:flutter/material.dart';
import 'package:my_prayer/localization/Localization.dart';

import 'package:my_prayer/screens/widgets/bottom_widget.dart';
import 'package:my_prayer/screens/widgets/settings_toogle.dart';
import 'package:my_prayer/utils/en_to_bd_number.dart';
import 'package:my_prayer/utils/language_constants.dart';
import 'package:my_prayer/viewmodel/language_provider.dart';
import 'package:my_prayer/viewmodel/viewmodel_dashboard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ViewModelDashboard model;
  double _value = 0;

  @override
  void initState() {
    model = Provider.of<ViewModelDashboard>(context, listen: false);
    model.fetchPrayers();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Consumer<LanguageProvider>(builder: (context, data, child) {
        return Consumer<ViewModelDashboard>(
          builder: (ctx, value, child) => TweenAnimationBuilder(
            duration: Duration(milliseconds: 600),
            tween: Tween<double>(
                begin: 0, end: value.prayers != null ? 40 : _value),
            curve: Curves.easeIn,
            builder: (context, size, child) => Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: size, left: 16),
                      child: Text(
                        "",
                        style: TextStyle(
                            fontSize: size,
                            color: Colors.white,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:16,right: 8),
                      child: WidgetSettingsToogle(
                      divider: false,
                      leading:
                          "${data.appLocal == Locale("bn") ? "ভাষা" : "Language"}",
                      sub: "",
                      onChanged: (value) {
                        data.changeLanguage(data.appLocal == Locale("en")
                            ? Locale("bn")
                            : Locale("en"));
                      },
                      value: data.appLocal == Locale("bn") ? true : false,
                    ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text:
                          "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size + 36,
                          fontWeight: FontWeight.w300),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "",
                          style: TextStyle(fontSize: size - 16),
                        ),
                      ],
                    ),
                  ),
                ),
                model.busy
                    ? CircularProgressIndicator()
                    : model.prayers.hasError
                        ? Expanded(
                            child: Center(
                              child: Text(
                                "${model.prayers.status}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: size + 10, color: Colors.white,),
                              ),
                            ),
                          )
                        : Container()/*WidgetPrayerList(
                            provider: data,
                            globalKey: _scaffoldKey,
                          ),*/
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).backgroundColor,
        tooltip: 'Add Alarm',
        child: WidgetBottomSheet(
          globalKey: _scaffoldKey,
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        //child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
