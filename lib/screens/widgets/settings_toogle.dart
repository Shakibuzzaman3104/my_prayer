import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                leading,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              children: <Widget>[
                sub != null
                    ? Text(
                        sub,
                        style: TextStyle(color: Colors.white),
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
            )
          ],
        ),
        divider ? Divider() : Container(),
      ],
    );
  }
}
