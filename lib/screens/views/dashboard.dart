import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/home/widget_circular_icon.dart';
import 'package:my_prayer/screens/widgets/home/prayer_list.dart';
import 'package:my_prayer/screens/widgets/widget_time.dart';
import 'package:my_prayer/viewmodel/language_provider.dart';
import 'package:my_prayer/viewmodel/viewmodel_dashboard.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ViewModelDashboard model;

  @override
  void initState() {
    model = Provider.of<ViewModelDashboard>(context, listen: false);
    model.fetchPrayers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, language, child) {
      return Consumer<ViewModelDashboard>(
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
                              color: Theme.of(context).accentColor),
                        ),
                        SizedBox(
                          height: SizeConfig.imageSizeMultiplier,
                        ),
                        Row(
                          children: [
                            Text(
                              viewmodel.busy
                                  ? ""
                                  : viewmodel.upComingPrayer.name + ", ",
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2.5,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            viewmodel.busy
                                ? SizedBox()
                                : WidgetTime(
                                    isAP: viewmodel.isAmPmSelected,
                                    titleSize: SizeConfig.textMultiplier * 2.5,
                                    time: viewmodel.upComingPrayer.time,
                                    subTitleSize: SizeConfig.textMultiplier * 2,
                                  ),
                          ],
                        ),
                        StreamBuilder<String>(
                            stream: model.countDownStream.stream,
                            builder: (context, snapshot) {
                              return snapshot.data == null
                                  ? Text(
                                      "00:00:00",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  : Text(
                                      "${snapshot.data}",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    );
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        viewmodel.busy
                            ? SizedBox()
                            : appBarIcons(
                                isAP: viewmodel.isAmPmSelected,
                                icon: "assets/img/sunrise.svg",
                                time: viewmodel.parentPrayer.prayers[1].time,
                                context: context),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 5,
                        ),
                        viewmodel.busy
                            ? SizedBox()
                            : appBarIcons(
                                isAP: viewmodel.isAmPmSelected,
                                icon: "assets/img/sunset.svg",
                                time: viewmodel.parentPrayer.prayers[4].time,
                                context: context),
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
                          color: Theme.of(context).primaryColor,
                          size: SizeConfig.imageSizeMultiplier * 6,
                        ),
                      ),
                      title: Text(
                        "${model.address}",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      subtitle: Text(
                        "Current location",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: SizeConfig.textMultiplier * 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: WidgetCircularItem(
                        icon: Icon(
                          Icons.date_range,
                          color: Theme.of(context).accentColor,
                          size: SizeConfig.imageSizeMultiplier * 6,
                        ),
                      ),
                      title: Text(
                        "${model.date}",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      subtitle: Text(
                        "Today's date",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: SizeConfig.textMultiplier * 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          right: SizeConfig.widthMultiplier * 4),
                      height: SizeConfig.heightMultiplier * 2.4,
                      alignment: Alignment.centerRight,
                      child: ToggleButtons(
                        selectedBorderColor: null,
                        fillColor: Theme.of(context).cardColor,
                        color: Theme.of(context).accentColor,
                        selectedColor: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.imageSizeMultiplier),
                        children: <Widget>[
                          Text(
                            " AM/PM ",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 1.2),
                          ),
                          Text(
                            "24 hr",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 1.2),
                          )
                        ],
                        onPressed: (index) => viewmodel.toggleTimeFormat(index),
                        isSelected: viewmodel.apToggle,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.heightMultiplier),
                  child: viewmodel.busy
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : WidgetPrayerList(
                          alarms: viewmodel.alarms,
                          isAmPm: viewmodel.isAmPmSelected,
                          prayer: viewmodel.parentPrayer.prayers,
                          onAlarmClick: (int pos) {
                            viewmodel.alarms[pos]
                                ? viewmodel.removeAlarm(pos, false)
                                : viewmodel.addAlarm(pos: pos);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Widget appBarIcons(
    {String icon,
    String time,
    final bool isAP,
    @required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        icon,
        height: SizeConfig.imageSizeMultiplier * 7,
        width: SizeConfig.imageSizeMultiplier * 7,
        color: Theme.of(context).primaryColor,
      ),
      WidgetTime(
        isAP: isAP,
        titleSize: SizeConfig.textMultiplier * 1.6,
        time: time,
        subTitleSize: SizeConfig.textMultiplier * 1.2,
      ),
    ],
  );
}
