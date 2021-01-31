import 'package:flutter/material.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';

class CustomSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: SizeConfig.heightMultiplier * 30,
            collapsedHeight: SizeConfig.heightMultiplier * 12,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 0,
            backgroundColor: Colors.blueAccent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3,
                    right: SizeConfig.widthMultiplier * 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                        Text(
                          "Upcoming prayer",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                        Text(
                          "Asr",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 1.6),
                        ),
                        Text(
                          "4:05 PM",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.6),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: SizeConfig.textMultiplier * 1.5,
                        ),
                        Text(
                          "Dhaka",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              background: Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 5,
                    right: SizeConfig.widthMultiplier * 3,
                    top: SizeConfig.heightMultiplier * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            appBarIcons(
                                icon: "assets/img/sunrise.png",
                                time: "6:15 AM"),
                            SizedBox(
                              width: SizeConfig.widthMultiplier * 5,
                            ),
                            appBarIcons(
                                icon: "assets/img/sunset.png", time: "6:35 PM"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Gregorian\n01-01-2021",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              "Hijri\n19-05-1442",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              _buildList(50),
            ),
          ),
        ],
      ),
    );
  }

  List _buildList(int count) {
    List<Widget> listItems = List();

    for (int i = 0; i < count; i++) {
      listItems.add(new Padding(
          padding: new EdgeInsets.all(20.0),
          child: new Text('Item ${i.toString()}',
              style: new TextStyle(fontSize: 25.0))));
    }

    return listItems;
  }
}

Widget appBarIcons({String icon, String time}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        icon,
        height: SizeConfig.imageSizeMultiplier * 15,
        width: SizeConfig.imageSizeMultiplier * 15,
      ),
      Text(
        time,
        style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 2, color: Colors.white),
      ),
    ],
  );
}
