import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_prayer/models/model_prayer.dart';
import 'package:my_prayer/screens/base_widget.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class WidgetBottomSheet extends StatefulWidget {
  final ModelPrayer _modelPrayer;
  final Icon icon;

  WidgetBottomSheet({ModelPrayer modelPrayer, @required this.icon})
      : _modelPrayer = modelPrayer;

  @override
  _WidgetBottomSheetState createState() => _WidgetBottomSheetState();
}

class _WidgetBottomSheetState extends State<WidgetBottomSheet> {
  TextEditingController _editingController;

  TimeOfDay time;

  @override
  void initState() {
    time = TimeOfDay(
        hour: widget._modelPrayer == null
            ? TimeOfDay.now().hour
            : int.parse(widget._modelPrayer.hour),
        minute: widget._modelPrayer == null
            ? TimeOfDay.now().minute
            : int.parse(widget._modelPrayer.min));

    _editingController = TextEditingController(
        text: "${widget._modelPrayer == null ? "" : widget._modelPrayer.name}");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.icon,
      onPressed: () => showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          backgroundColor: Colors.white,
          context: context,
          builder: (_) => Consumer<ViewModelPrayers>(
                builder: (context, value, child) => Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .55,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${widget._modelPrayer == null ? "Add prayer" : "Edit prayer"}",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w300),
                          ),
                          Divider(),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),
                            decoration: InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(),
                              ),
                            ),
                            controller: _editingController,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*.2,
                            width: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime(1969, 1, 1, time.hour, time.minute),
                              onDateTimeChanged: (DateTime newDateTime) {
                                time = TimeOfDay.fromDateTime(newDateTime);
                              },
                              use24hFormat: false,
                              minuteInterval: 1,
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          MaterialButton(
                              height: 44,
                              minWidth: double.infinity,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0)),
                              child: Text(
                                "${widget._modelPrayer == null ? "Add" : "Save"}",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Theme.of(context).backgroundColor,
                              onPressed: () {
                                ModelPrayer prayer = ModelPrayer(
                                    id: widget._modelPrayer!=null ? widget._modelPrayer.id : null,
                                    name: _editingController.text,
                                    hour: time.hour.toString(),
                                    min: time.minute<10? "0"+time.minute.toString() : time.minute.toString(),
                                    status: 0,
                                    ap: time.period
                                        .toString()
                                        .split(("."))[1]
                                        .toUpperCase());
                                widget._modelPrayer == null
                                    ? value.addPrayer(prayer)
                                    : value.updatePrayer(prayer);

                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}
