import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:my_prayer/localization/Localization.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelLocalPrayerParent.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/bottom_widget.dart';
import 'package:my_prayer/screens/widgets/widget_time.dart';
import 'package:my_prayer/utils/color_constants.dart';
import 'package:my_prayer/utils/en_to_bd_number.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:my_prayer/viewmodel/language_provider.dart';
import 'package:my_prayer/viewmodel/viewmodel_dashboard.dart';
import 'package:provider/provider.dart';

class WidgetPrayerList extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final List<ModelLocalPrayer> prayer;
  final Function onAlarmClick;
  final bool isAmPm;

  WidgetPrayerList(
      {this.globalKey,
      @required this.prayer,
      @required this.onAlarmClick,
      @required this.isAmPm});

  @override
  _WidgetPrayerListState createState() => _WidgetPrayerListState();
}

class _WidgetPrayerListState extends State<WidgetPrayerList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: UniqueKey(),
        padding: EdgeInsets.only(
          bottom: SizeConfig.heightMultiplier,
          left: SizeConfig.widthMultiplier * 4,
          right: SizeConfig.widthMultiplier * 4,
        ),
        itemBuilder: (con, position) {
          return Container(
            height: SizeConfig.heightMultiplier * 10,
            margin:
                EdgeInsets.symmetric(vertical: SizeConfig.widthMultiplier * 2),
            decoration: BoxDecoration(
              color: ColorConstants.CARD,
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.imageSizeMultiplier * 2)),
            ),
            child: Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4,
                  right: SizeConfig.widthMultiplier * 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prayer[position].name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.SUBTITLE,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ),
                      WidgetTime(
                        isAP: widget.isAmPm,
                        titleSize: SizeConfig.textMultiplier * 3,
                        time: widget.prayer[position].time,
                        subTitleSize: SizeConfig.textMultiplier * 2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 3,
                      ),
                      IconButton(
                        icon: widget.prayer[position].status == 1
                            ? Icon(
                                Icons.access_alarm,
                                size: SizeConfig.imageSizeMultiplier * 8,
                                color: ColorConstants.TITLE,
                              )
                            : Icon(
                                Icons.alarm_off,
                                size: SizeConfig.imageSizeMultiplier * 8,
                                color: ColorConstants.SUBTITLE,
                              ),
                        onPressed: () => widget.onAlarmClick(position),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: widget.prayer.length);
  }
}
