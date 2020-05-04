import 'package:flutter/material.dart';
import 'package:my_prayer/screens/base_widget.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class WidgetPrayerList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ViewModelPrayers>(
      value: ViewModelPrayers(api: Provider.of(context)),
      onValueReady: (model)=> model.fetchPrayers(),
      builder: (context,model,child)=> Expanded(
          child: ListView.builder(
              itemBuilder: (context, position) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8, bottom: 6),
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
                                    fontSize: 24, color: Colors.black87),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Theme.of(context).backgroundColor,
                              onPressed: () {
                                print("");
                              },
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
                                    text:  "${model.prayers[position].hour}",
                                    style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                      text: "${model.prayers[position].hour}"),
                                ],
                              ),
                            ),
                            Switch(
                              value: true,
                              onChanged: (state) {
                              },
                              activeColor: Theme.of(context).backgroundColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: model.prayers == null ? 0 : model.prayers.length)),
    );
  }
}
