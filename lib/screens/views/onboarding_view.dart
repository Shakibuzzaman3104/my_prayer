import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/views/dashboard.dart';
import 'package:my_prayer/utils/router_path_constants.dart';

import 'home.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushNamed(RouterPathsConstants.HOME);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: SvgPicture.asset('assets/img/location.svg', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "As-salamu alaykum\n ٱلسَّلَامُ عَلَيْكُمْ",
          body: "App needs Location permission to access prayer information",
          footer: MaterialButton(
            elevation: 0,
            onPressed: () {},
            child: Text(
              "Grant permission",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blueAccent,
          ),
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Learn as you go",
          bodyWidget: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4,
                vertical: SizeConfig.heightMultiplier * 2),
            height: SizeConfig.heightMultiplier * 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "CHANGE LOCATION",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier * 3),
                ),
                SizedBox(height: SizeConfig.heightMultiplier),
                TextFormField(

                  cursorColor: Colors.black,
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 2,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                    hintText: "Ex: old trafford,manchester",
                    hintStyle: TextStyle(color: Colors.black),
                    labelText: "enter location",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: MaterialButton(
                    onPressed: () {
                      /*if (_title.text.trim().isNotEmpty)
                        viewmodel.fetchCoordinateFromName(_title.text);*/
                    },
                    color: Colors.blueAccent,
                    child: Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 3,
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 15,
                  child: /*viewmodel.addresses == null
                      ? Center(
                          child: Text("Searched locations will appear here"),
                        )
                      : viewmodel.isFetchingData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : viewmodel.addresses.length == 0
                              ? Center(
                                  child: Text("No address matches your input"),
                                )
                              : ListView.builder(
                                  itemCount: viewmodel.addresses.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return InkWell(
                                      onTap: () {
                                        onClick(viewmodel.addresses[index]);
                                        viewmodel.resetAddress();
                                      },
                                      child: ListTile(
                                        tileColor: Theme.of(context).cardColor,
                                        leading: Text(
                                          "${viewmodel.addresses[index].featureName}, ${viewmodel.addresses[index].countryName}",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),*/ Container(),),
                Text(
                  "OR",
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 2,
                      color: Theme.of(context).primaryColor),
                ),
                MaterialButton(
                  minWidth: SizeConfig.widthMultiplier * 100,
                  height: SizeConfig.heightMultiplier * 5,
                  onPressed: () {
                    //onClick(null);
                    // Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.navigation_outlined,
                        color: Theme.of(context).backgroundColor,
                      ),
                      Text(
                        "Locate me",
                        style:
                            TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ],
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Kids and teens",
          body:
              "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage('img2'),
          footer: RaisedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
