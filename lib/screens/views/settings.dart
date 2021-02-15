import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/model.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/settings/location_dialog.dart';
import 'package:my_prayer/screens/widgets/settings_toogle.dart';
import 'package:my_prayer/screens/widgets/widget_location_settings_dialog.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:my_prayer/viewmodel/theme_viewmodel.dart';
import 'package:my_prayer/viewmodel/viewmodel_settings.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _nameController;
  ThemeViewModel model;
  ViewModelSettings settings;

  @override
  void initState() {
    model = Provider.of<ThemeViewModel>(context, listen: false);
    model.getIsDark();

    settings = Provider.of<ViewModelSettings>(context, listen: false);
    settings.fetchPosition();

    _nameController = TextEditingController();
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
        body: Consumer<ViewModelSettings>(builder: (context, settings, child) {
          return Container(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2,
                left: SizeConfig.widthMultiplier * 6,
                right: SizeConfig.widthMultiplier * 6),
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
                SizedBox(
                  height: SizeConfig.heightMultiplier * 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text(
                        "Server",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: SizeConfig.textMultiplier * 2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: FittedBox(
                        child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).backgroundColor,
                          value: settings.modes[settings.position],
                          items: settings.modes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (String val) {
                            settings.changeMethodAndFetchData(val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Location",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: SizeConfig.textMultiplier * 2,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${settings.location}",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: SizeConfig.textMultiplier * 1.5,
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      onPressed: () {
                        showChangeServerDialog(
                            context, _nameController, settings,
                            (Address address) async {
                          if (address == null) {
                            await settings.checkPermission().then((permission)async {
                              if (settings.permission ==
                                      PERMISSIONS.PERMANENTLY_DENIED ||
                                  settings.permission ==
                                      PERMISSIONS.PERMANENTLY_DENIED) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LocationSettingsDialog();
                                    });
                              } else if (settings.permission ==
                                  PERMISSIONS.DISABLED) {
                                showDialog(
                                    context: context,
                                    builder: (context) => ShowSettingsDialog());
                              } else {
                                showFetchingDialog();
                                await settings
                                    .changeLocationAndFetchData(address);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            });
                          } else
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Are you sure"),
                                content: Text(
                                    "You will not get accurate information"),
                                actions: [
                                  FlatButton(
                                    onPressed: () async {
                                      showFetchingDialog();
                                      await settings
                                          .changeLocationAndFetchData(address);
                                      Navigator.of(context).pop();
                                      _nameController.clear();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Yes"),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _nameController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"),
                                  ),
                                ],
                              ),
                            );
                        });
                        /*  ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Coming soon..."),
                            duration: Duration(milliseconds: 900),
                          ),
                        );*/
                      },
                      child: Text(
                        "Change",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: SizeConfig.textMultiplier * 1.5,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }),
      );
    });
  }

  showFetchingDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text("Fetching Data, please wait..."),
          );
        });
  }
}
