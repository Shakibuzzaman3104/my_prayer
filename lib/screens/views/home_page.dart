import 'package:flutter/material.dart';
import 'package:my_prayer/models/model_prayer.dart';
import 'package:my_prayer/screens/base_widget.dart';
import 'package:my_prayer/screens/widgets/bottom_widget.dart';
import 'package:my_prayer/screens/widgets/widget_add_edit.dart';
import 'package:my_prayer/screens/widgets/widget_prayer_list.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ViewModelPrayers>(
      value: ViewModelPrayers(api: Provider.of(context)),
      onValueReady: (model)=>model.upcomingPrayer(),
      builder: (ctx,model,child)=>Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Center(
              child: new Text("Prayer Times", textAlign: TextAlign.center)),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 16.0, left: 12),
                child: Text(
                  "${model.nextPrayer.name}",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "${model.nextPrayer.hour}:${model.nextPrayer.min}",
                    style: Theme.of(context).textTheme.title,
                    children: <TextSpan>[
                      TextSpan(
                        text: "${model.nextPrayer.ap}",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              model.busy
                  ? CircularProgressIndicator()
                  : WidgetPrayerList(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Alarm',
          child: WidgetBottomSheet(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          onPressed: () {},
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
