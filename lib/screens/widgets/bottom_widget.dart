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

  _pickTime() async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null)
      setState(() {
        time = t;
      });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => IconButton(
        icon: widget.icon,
        onPressed: () => showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
            context: context,
            builder: (_) => BaseWidget<ViewModelPrayers>(
                  value: ViewModelPrayers(api: Provider.of(context)),
                  builder: (context, value, child) => Container(
                    padding: EdgeInsets.all(12),
                    height: 350,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "${widget._modelPrayer == null ? "Add new Prayer" : "Edit Prayer"}",
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Name",
                          ),
                          controller: _editingController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Time: ${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute} ${time.period.toString().split(("."))[1].toUpperCase()}",
                            ),
                            FlatButton(
                              child: Text(
                                "Pick Time",
                                style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              onPressed: _pickTime,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                              elevation: 0,
                              child: Text(
                                "${widget._modelPrayer == null ? "Add" : "Save"}",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Theme.of(context).backgroundColor,
                              onPressed: () {
                                ModelPrayer prayer = ModelPrayer(
                                    name: _editingController.text,
                                    hour: time.hour.toString(),
                                    min: time.minute.toString(),
                                    status: 0,
                                    ap: time.period
                                        .toString()
                                        .split(("."))[1]
                                        .toUpperCase());
                                widget._modelPrayer == null
                                    ? value.addPrayer(prayer)
                                    : value.updatePrayer(prayer);

                                Navigator.of(context).pop();
                              }),
                        )
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
