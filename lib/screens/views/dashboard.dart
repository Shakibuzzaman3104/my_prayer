import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/home/widget_circular_icon.dart';
import 'package:my_prayer/screens/widgets/prayer_list.dart';
import 'package:my_prayer/utils/color_constants.dart';
import 'package:my_prayer/viewmodel/language_provider.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ViewModelPrayers model;

  @override
  void initState() {
    model = Provider.of<ViewModelPrayers>(context, listen: false);
    model.fetchPrayers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, language, child) {
      return Consumer<ViewModelPrayers>(
        builder: (context, viewmodel, child) => Container(
          padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3,
            top: SizeConfig.heightMultiplier * 4,
            right: SizeConfig.widthMultiplier * 2,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                        Text(
                          "Upcoming prayer",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: SizeConfig.textMultiplier * 2,
                              color: ColorConstants.SUBTITLE),
                        ),
                        Text(
                          "Isha, 4:05 PM",
                          style: TextStyle(
                              color: ColorConstants.TITLE,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textMultiplier * 3),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        appBarIcons(
                            icon: "assets/img/sunrise.svg", time: "6:15 AM"),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 5,
                        ),
                        appBarIcons(
                            icon: "assets/img/sunset.svg", time: "6:35 PM"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: WidgetCircularItem(
                        icon: Icon(
                          Icons.location_on,
                          color: ColorConstants.ICON,
                          size: SizeConfig.imageSizeMultiplier * 6,
                        ),
                      ),
                      title: Text(
                        "Dhaka, Bangladesh",
                        style: TextStyle(color: ColorConstants.TITLE),
                      ),
                      subtitle: Text(
                        "Current location",
                        style: TextStyle(
                            color: ColorConstants.SUBTITLE,
                            fontSize: SizeConfig.textMultiplier * 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: WidgetCircularItem(
                        icon: Icon(
                          Icons.date_range,
                          color: ColorConstants.ICON,
                          size: SizeConfig.imageSizeMultiplier * 6,
                        ),
                      ),
                      title: Text(
                        "03 Jumail Awal 1440 H",
                        style: TextStyle(color: ColorConstants.TITLE),
                      ),
                      subtitle: Text(
                        "Today's date",
                        style: TextStyle(
                            color: ColorConstants.SUBTITLE,
                            fontSize: SizeConfig.textMultiplier * 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: WidgetPrayerList(
                  prayer: viewmodel.parentPrayer.prayers,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Widget appBarIcons({String icon, String time}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        icon,
        height: SizeConfig.imageSizeMultiplier * 7,
        width: SizeConfig.imageSizeMultiplier * 7,
        color: ColorConstants.ICON,
      ),
      Text(
        time,
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.5,
          color: ColorConstants.TITLE,
        ),
      ),
    ],
  );
}
