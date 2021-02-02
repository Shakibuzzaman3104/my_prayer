import 'package:flutter/material.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/utils/color_constants.dart';
import 'package:my_prayer/utils/utils.dart';

class WidgetTime extends StatelessWidget {
  final String time;
  final bool isAP;
  final double titleSize;
  final double subTitleSize;

  WidgetTime(
      {@required this.isAP,
      @required this.time,
      @required this.titleSize,
      @required this.subTitleSize});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: isAP ? convertTimeToAP(time)[0] : time,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: titleSize),
          ),
          TextSpan(
            text: isAP ? convertTimeToAP(time)[1] : "",
            style: TextStyle(
                fontSize: subTitleSize,
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
