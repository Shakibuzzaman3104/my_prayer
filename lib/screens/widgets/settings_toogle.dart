import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';

class WidgetSettingsToogle extends StatelessWidget {
  final String leading;
  final String sub;
  final Function onChanged;
  final bool divider;
  final bool value;

  WidgetSettingsToogle(
      {this.leading, this.divider, this.onChanged, this.sub, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              leading,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: SizeConfig.textMultiplier * 2,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                sub != null
                    ? Text(
                        sub,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    : Container(),
                Transform.scale(
                  scale: .6,
                  child: CupertinoSwitch(
                    onChanged: (bool value) {
                      onChanged(value);
                    },
                    value: value,
                  ),
                ),
              ],
            ),
          ],
        ),
        divider ? Divider() : Container(),
      ],
    );
  }
}
