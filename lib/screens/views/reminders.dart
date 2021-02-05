import 'package:flutter/material.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/reminder/WidgetBottomSheet.dart';
import 'package:my_prayer/screens/widgets/reminder/widget_reminder_list.dart';
import 'package:my_prayer/screens/widgets/widget_time.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:my_prayer/viewmodel/viewmodel_reminders.dart';
import 'package:provider/provider.dart';

class ViewReminders extends StatefulWidget {
  @override
  _ViewRemindersState createState() => _ViewRemindersState();
}

class _ViewRemindersState extends State<ViewReminders> {
  ViewModelReminders model;

  @override
  void initState() {
    model = Provider.of<ViewModelReminders>(context, listen: false);
    model.fetchReminders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModelReminders>(
      builder: (ctx, value, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 4,
                  left: SizeConfig.widthMultiplier * 3),
              child: Container(
                padding: EdgeInsets.only(left:SizeConfig.imageSizeMultiplier*5,right:SizeConfig.imageSizeMultiplier*5,top:SizeConfig.imageSizeMultiplier*5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    Text(
                      "Upcoming reminder",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: SizeConfig.textMultiplier * 2,
                          color: Theme.of(context).accentColor),
                    ),
                    model.upComingReminder != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.upComingReminder.name + ", ",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              WidgetTime(
                                isAP: model.isAmPmSelected,
                                titleSize: SizeConfig.textMultiplier * 2.5,
                                time:
                                    "${DateTime.parse(model.upComingReminder.dateTime).hour}:${DateTime.parse(model.upComingReminder.dateTime).minute}",
                                subTitleSize: SizeConfig.textMultiplier * 2,
                              ),
                            ],
                          )
                        : Text(
                            "No Upcoming reminder",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier * 2.5),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.imageSizeMultiplier*10,
            ),
            model.busy ? CircularProgressIndicator() : WidgetReminderList(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).backgroundColor,
          tooltip: 'ADD PRAYER',
          child: WidgetBottomSheet(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {},
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
