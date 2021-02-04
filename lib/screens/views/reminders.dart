import 'package:flutter/material.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/reminder/WidgetBottomSheet.dart';
import 'package:my_prayer/screens/widgets/reminder/widget_reminder_list.dart';
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
        body: Padding(
          padding:  EdgeInsets.all(SizeConfig.imageSizeMultiplier*3),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 48.0, left: 12),
                child: Text(
                  "${model.upComingReminder == null ? "No Upcoming reminder" : model.upComingReminder.name}",
                  style: TextStyle(
                      fontSize: 40,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.w200),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text:
                        "${model.upComingReminder == null ? "" : "${model.upComingReminder.dateTime}"}",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    children: <TextSpan>[],
                  ),
                ),
              ),
              model.busy
                  ? CircularProgressIndicator()
                  : WidgetReminderList(provider: null),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).backgroundColor,
          tooltip: 'Add Alarm',
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
