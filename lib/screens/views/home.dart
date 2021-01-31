import 'package:flutter/material.dart';
import 'package:my_prayer/screens/widgets/home/sliver.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Container(
          child: CustomSliver(),
        ),
      ),
    );
  }
}
