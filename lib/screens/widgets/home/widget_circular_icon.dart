import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/utils/color_constants.dart';

class WidgetCircularItem extends StatelessWidget {

  final Function onClick;
  final Icon icon;

  WidgetCircularItem({@required this.icon,this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.imageSizeMultiplier*10,
        width: SizeConfig.imageSizeMultiplier*10,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle
        ),
      child: icon,
    );
  }
}
