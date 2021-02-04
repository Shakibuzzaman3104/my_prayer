import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/views/navigation.dart';
import 'package:my_prayer/screens/views/reminders.dart';
import 'package:my_prayer/screens/views/settings.dart';
import 'package:my_prayer/screens/views/dashboard.dart';
import 'package:my_prayer/screens/views/tasbih.dart';
import 'package:my_prayer/server_setup/api_client.dart';
import 'package:my_prayer/utils/color_constants.dart';
import 'package:my_prayer/utils/router_path_constants.dart';
import 'package:my_prayer/viewmodel/viewmodel_home.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static List _widgetOptions = [
    Dashboard(),
    Navigation(),
    ViewReminders(),
    ViewTasbih(),
    Settings(),
  ];


  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModelHome>(builder: (context, home, child) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _widgetOptions[home.position],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/img/home.svg",
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                  color: home.position ==0 ? Theme.of(context).primaryColor: Theme.of(context).accentColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/img/compass.svg",
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                  color:home.position ==1 ? Theme.of(context).primaryColor: Theme.of(context).accentColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/img/reminder.svg",
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                  color: home.position ==2 ? Theme.of(context).primaryColor: Theme.of(context).accentColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/img/tasbih.svg",
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                  color: home.position ==3 ? Theme.of(context).primaryColor: Theme.of(context).accentColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/img/settings.svg",
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                  color: Theme.of(context).accentColor,
                ),
                label: 'Home',
              ),
            ],
            currentIndex: home.position,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withAlpha(100),
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index > -1 && index < 4) {
                home.setPosition(index);
              } else
                Navigator.of(context).pushNamed(RouterPathsConstants.SETTINGS);
              // try {

              // } on Exception catch (_) {
              //   print('never reached');
              // }
            },
          ),
        ),
      );
    });
  }
}
