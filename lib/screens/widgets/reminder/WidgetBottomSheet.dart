import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/model/ModelReminder.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/viewmodel/viewmodel_reminders.dart';
import 'package:provider/provider.dart';

class WidgetBottomSheet extends StatefulWidget {
  final ModelReminder _modelReminder;
  final Icon icon;

  WidgetBottomSheet({ModelReminder modelReminder, @required this.icon})
      : _modelReminder = modelReminder;

  @override
  _WidgetBottomSheetState createState() => _WidgetBottomSheetState();
}

class _WidgetBottomSheetState extends State<WidgetBottomSheet> {
  TextEditingController _editingController;

  DateTime time;

  @override
  void initState() {
    _editingController = TextEditingController(
        text:
            "${widget._modelReminder == null ? "" : widget._modelReminder.name}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.icon,
      onPressed: () => showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.imageSizeMultiplier * 4),
              topRight: Radius.circular(SizeConfig.imageSizeMultiplier * 4)),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        context: context,
        builder: (_) => Consumer<ViewModelReminders>(
          builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 6,
                    right: SizeConfig.widthMultiplier * 6),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    Text(
                      "${widget._modelReminder == null ? "ADD REMINDER" : "EDIT REMINDER"}",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 3,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    Divider(
                      color: Theme.of(context).cardColor,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        labelText: "Title",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      controller: _editingController,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: SizeConfig.heightMultiplier * 30,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              fontSize: SizeConfig.textMultiplier*2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),

                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.dateAndTime,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (DateTime newDateTime) {
                            time = newDateTime;
                            debugPrint("$time");
                          },
                          use24hFormat: !value.isAmPmSelected,
                          minuteInterval: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier,
                    ),
                    MaterialButton(
                        height: SizeConfig.heightMultiplier * 5,
                        minWidth: double.infinity,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          "${widget._modelReminder == null ? "Add" : "Save"}",
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_editingController.text.trim().isNotEmpty) {
                            ModelReminder prayer = ModelReminder(
                              id: widget._modelReminder != null
                                  ? widget._modelReminder.id
                                  : null,
                              dateTime: time.toString(),
                              name: _editingController.text,
                              status:
                                  widget._modelReminder == null ? true : false,
                            );
                            value.addAlarm(prayer,
                                shouldUpdate: widget._modelReminder == null
                                    ? false
                                    : true);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Title should't be empty"),
                                duration: Duration(milliseconds: 700),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
