import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/localization/Localization.dart';
import 'package:my_prayer/model/ModelReminder.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/utils/en_to_bd_number.dart';
import 'package:my_prayer/viewmodel/language_provider.dart';
import 'package:my_prayer/viewmodel/viewmodel_dashboard.dart';
import 'package:my_prayer/viewmodel/viewmodel_reminders.dart';
import 'package:provider/provider.dart';

import '../widget_time.dart';
import 'WidgetBottomSheet.dart';

class WidgetReminderList extends StatefulWidget {
  @override
  _WidgetReminderListState createState() => _WidgetReminderListState();
}

class _WidgetReminderListState extends State<WidgetReminderList> {
  ViewModelDashboard viewModelPrayers;

  @override
  void initState() {
    viewModelPrayers = Provider.of<ViewModelDashboard>(context, listen: false);
    viewModelPrayers.fetchPrayers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModelReminders>(
      builder: (ctx, model, child) => Expanded(
        child: ListView.builder(
            key: UniqueKey(),
            padding: EdgeInsets.only(left:SizeConfig.imageSizeMultiplier*5,right:SizeConfig.imageSizeMultiplier*5),
            itemBuilder: (con, position) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
                   padding: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(SizeConfig.imageSizeMultiplier)
                  ),
                  child: Align(
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).backgroundColor,
                      size: SizeConfig.imageSizeMultiplier*7,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
                onDismissed: (direction) {
                  model.removeItem(position).then((_) {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.widthMultiplier * 2),
                  padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4,
                  ),
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                        SizeConfig.imageSizeMultiplier * 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.reminders[position].name,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).accentColor,
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          WidgetTime(
                            isAP: model.isAmPmSelected,
                            titleSize: SizeConfig.textMultiplier * 3,
                            time:
                                "${DateTime.parse(model.reminders[position].dateTime).hour}:${DateTime.parse(model.reminders[position].dateTime).minute}",
                            subTitleSize: SizeConfig.textMultiplier * 2,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: model.reminders[position].status
                                ? Icon(
                                    Icons.access_alarm,
                                    size: SizeConfig.imageSizeMultiplier * 5,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : Icon(
                                    Icons.alarm_off,
                                    size: SizeConfig.imageSizeMultiplier * 5,
                                    color: Theme.of(context).accentColor,
                                  ),
                            onPressed: () {
                              if (model.reminders[position].status) {
                                debugPrint("RemoveAlarm Called");
                                model.reminders[position].status = !model.reminders[position].status;
                                model.removeAlarm(
                                    model.reminders[position], position);
                              } else
                                model.addAlarm(model.reminders[position],
                                    shouldUpdate: true);
                            },
                          ),
                          WidgetBottomSheet(
                            icon: Icon(
                              Icons.edit,
                              size: SizeConfig.imageSizeMultiplier * 5,
                              color: Theme.of(context).primaryColor,
                            ),
                            modelReminder: model.reminders[position],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                key: Key(model.reminders[position].id.toString()),
              );
            },
            itemCount: model.reminders == null ? 0 : model.reminders.length),
      ),
    );
  }
}
