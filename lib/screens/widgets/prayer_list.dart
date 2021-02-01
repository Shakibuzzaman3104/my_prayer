import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/localization/Localization.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/model/ModelLocalPrayerParent.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/bottom_widget.dart';
import 'package:my_prayer/utils/color_constants.dart';
import 'package:my_prayer/utils/en_to_bd_number.dart';
import 'package:my_prayer/viewmodel/language_provider.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class WidgetPrayerList extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final List<ModelLocalPrayer> prayer;
  WidgetPrayerList({this.globalKey,@required this.prayer});

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
              top: SizeConfig.heightMultiplier * 3),
          itemBuilder: (con, position) {
            return Container(
              height: SizeConfig.heightMultiplier * 10,
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.widthMultiplier * 2),
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
                              color: ColorConstants.SUBTITLE,
                              fontSize: SizeConfig.textMultiplier * 2),
                        ),
                        Text(
                          widget.prayer[position].time,
                          style: TextStyle(
                              color: ColorConstants.TITLE,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textMultiplier * 3),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 3,
                        ),
                        Icon(
                          Icons.access_alarm,
                          size: SizeConfig.imageSizeMultiplier * 8,
                          color: ColorConstants.TITLE,
                        )
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
