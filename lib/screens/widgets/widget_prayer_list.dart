import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/screens/base_widget.dart';
import 'package:my_prayer/screens/widgets/bottom_widget.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class WidgetPrayerList extends StatefulWidget {
  @override
  _WidgetPrayerListState createState() => _WidgetPrayerListState();
}

class _WidgetPrayerListState extends State<WidgetPrayerList> {
  ViewModelPrayers viewModelPrayers;

  @override
  void initState() {
    viewModelPrayers = Provider.of<ViewModelPrayers>(context, listen: false);
    viewModelPrayers.fetchPrayers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModelPrayers>(
      builder: (ctx, model, child) => Expanded(
        child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (con, position) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: EdgeInsets.only(top: 8,bottom: 8),
                  padding: EdgeInsets.only(right: 12),
                  color: Colors.red,
                  child: Align(
                    child: Icon(Icons.delete,color: Colors.white,size: 32,),
                    alignment: Alignment.centerRight,
                  ),
                ),
                onDismissed: (direction) {
                    model.deletePrayer(model.prayers[position].id);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 8, bottom: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 8),
                                child: Text(
                                  "${model.prayers[position].name}",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black87,fontWeight: FontWeight.w300),
                                ),
                              ),
                              WidgetBottomSheet(
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).backgroundColor,
                                ),
                                modelPrayer: model.prayers[position],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "${(int.parse(model.prayers[position].hour) > 12 ? (int.parse(model.prayers[position].hour) - 12).toString() : model.prayers[position].hour)}:${model.prayers[position].min}",
                                      style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                        text: "${model.prayers[position].ap}"),
                                  ],
                                ),
                              ),
                              Switch(
                                value: model.prayers[position].status == 1
                                    ? true
                                    : false,
                                onChanged: (_) =>
                                    model.prayers[position].status == 0
                                        ? model.addNotification(
                                            pos: position,
                                            id: model.prayers[position].id,
                                          )
                                        : model.removeNotification(
                                            model.prayers[position].id,
                                          ),
                                activeColor: Theme.of(context).backgroundColor,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                key: Key(model.prayers[position].id.toString()),
              );
            },
            itemCount: model.prayers == null ? 0 : model.prayers.length),
      ),
    );
  }
}
