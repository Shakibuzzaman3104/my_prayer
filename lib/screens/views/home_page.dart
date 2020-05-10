import 'package:flutter/material.dart';
import 'package:my_prayer/models/model_prayer.dart';
import 'package:my_prayer/screens/base_widget.dart';
import 'package:my_prayer/screens/widgets/bottom_widget.dart';
import 'package:my_prayer/screens/widgets/widget_prayer_list.dart';
import 'package:my_prayer/viewmodel/viewmodel_prayers.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  ViewModelPrayers model;

  @override
  void initState() {
    model = Provider.of<ViewModelPrayers>(context,listen: false);
    model.upcomingPrayer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModelPrayers>(builder: ( ctx,  value,  child) =>Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 48.0, left: 12),
              child: Text(
                "${model.nextPrayer.hour == null ? "" : model.nextPrayer.name}",
                style: TextStyle(fontSize: 40, color: Colors.white,fontWeight: FontWeight.w200),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "${model.nextPrayer.hour == null ? "00:00":"${model.nextPrayer.hour}:${model.nextPrayer.min}"}",
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
        backgroundColor: Theme.of(context).backgroundColor,
        tooltip: 'Add Alarm',
        child: WidgetBottomSheet(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onPressed: () {},
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ),);
  }
}
