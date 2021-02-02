import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_prayer/screens/widgets/settings_toogle.dart';
import 'package:my_prayer/viewmodel/theme_viewmodel.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeViewModel model;
  @override
  void initState() {
    model = Provider.of<ThemeViewModel>(context,listen: false);
    model.getIsDark();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (context, theme, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            "Settings",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          child: Column(
            children: [
              WidgetSettingsToogle(
                divider: false,
                leading: "Theme",
                sub: "",
                onChanged: (value) {
                  theme.setTheme(value);
                },
                value: theme.theme,
              ),
            ],
          ),
        ),
      );
    });
  }
}
