import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/localization/Localization.dart';
import 'package:my_prayer/model/LocalPrayer.dart';
import 'package:my_prayer/utils/language_constants.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class WidgetBottomSheet extends StatefulWidget {
  final LocalPrayer _localPrayer;
  final Icon icon;
  final int pos;
  final GlobalKey<ScaffoldState> globalKey;

  WidgetBottomSheet(
      {LocalPrayer modelPrayer, @required this.icon, this.globalKey,this.pos})
      : _localPrayer = modelPrayer;

  @override
  _WidgetBottomSheetState createState() => _WidgetBottomSheetState();
}

class _WidgetBottomSheetState extends State<WidgetBottomSheet> {
  TextEditingController _editingController;

  TimeOfDay time;

  @override
  void initState() {
    time = TimeOfDay(
        hour: widget._localPrayer == null
            ? TimeOfDay.now().hour
            : int.parse(widget._localPrayer.hour),
        minute: widget._localPrayer == null
            ? TimeOfDay.now().minute
            : int.parse(widget._localPrayer.min));

    _editingController = TextEditingController(
        text: "${widget._localPrayer == null ? "" : widget._localPrayer.name}");
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
                            "${widget._localPrayer == null ?  Localization.of(context).translate(LanguageConstant.ADD_PRAYER) : Localization.of(context).translate(LanguageConstant.EDIT_PRAYER)}",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w300),
                          ),
                          Divider(),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300),
                            decoration: InputDecoration(
                              labelText: "${Localization.of(context).translate(LanguageConstant.NAME)}",
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
                            height: MediaQuery.of(context).size.height * .2,
                            width: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime:
                                  DateTime(1969, 1, 1, time.hour, time.minute),
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
                                "${widget._localPrayer == null ? Localization.of(context).translate(LanguageConstant.ADD) : Localization.of(context).translate(LanguageConstant.SAVE)}",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Theme.of(context).backgroundColor,
                              onPressed: () {
                                LocalPrayer prayer = LocalPrayer(
                                    id: widget._localPrayer != null
                                        ? widget._localPrayer.id
                                        : null,
                                    name: _editingController.text,
                                    hour: time.hour.toString(),
                                    min: time.minute < 10
                                        ? "0" + time.minute.toString()
                                        : time.minute.toString(),
                                    status: 0,
                                    ap: time.period
                                        .toString()
                                        .split(("."))[1]
                                        .toUpperCase());
                                widget._localPrayer == null
                                    ? value.addPrayer(prayer).then((value) {
                                        widget.globalKey.currentState
                                            .showSnackBar(SnackBar(
                                                duration: Duration(milliseconds: 800),
                                                content:
                                                    Text("New Prayer added")));
                                      })
                                    : value.updatePrayer(prayer,widget.pos).then((value) {
                                        widget.globalKey.currentState
                                            .showSnackBar(SnackBar(
                                              duration: Duration(milliseconds: 800),
                                                content:
                                                    Text("Prayer updated")));
                                      });
                                  _editingController.clear();
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
