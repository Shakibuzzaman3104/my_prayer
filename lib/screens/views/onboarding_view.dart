import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/views/dashboard.dart';
import 'package:my_prayer/utils/router_path_constants.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:my_prayer/viewmodel/viewmodel_settings.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  TextEditingController _title;

  @override
  void initState() {
    _title = TextEditingController();
    ViewModelSettings settings =
        Provider.of<ViewModelSettings>(context, listen: false);
    settings.fetchPosition();
    super.initState();
  }

  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName) {
    return Align(
      child: SvgPicture.asset('assets/img/$assetName.svg',
          width: SizeConfig.imageSizeMultiplier * 70),
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

    return Consumer<ViewModelSettings>(builder: (context, settings, child) {
      return IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            title: "As-salamu alaykum\n ٱلسَّلَامُ عَلَيْكُمْ",
            body: "App needs Location permission to access prayer information",
            image: _buildImage('location'),
            footer: MaterialButton(
              color: Colors.blue,
              child: Text(
                "Grant permission",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await settings.checkPermission().then((value) async {
                  switch (value) {
                    case PERMISSIONS.APPROVED:
                      await settings.changeLocation(null);
                      introKey.currentState?.animateScroll(2);
                      break;
                    default:
                      introKey.currentState?.animateScroll(2);
                      break;
                  }
                });
              },
            ),
            decoration: pageDecoration,
          ),
          settings.permission == PERMISSIONS.APPROVED
              ? PageViewModel(title: "Hellow", body: "sdfgf")
              : PageViewModel(
                  title: "Enter manual location",
                  bodyWidget: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 4,
                        vertical: SizeConfig.heightMultiplier * 2),
                    height: SizeConfig.heightMultiplier * 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: SizeConfig.heightMultiplier),
                        TextFormField(
                          controller: _title,
                          cursorColor: Theme.of(context).primaryColor,
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 2,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            hintText: "Ex: old trafford, Manchester",
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
                            labelText: "enter location",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_title.text.trim().isNotEmpty)
                                await settings
                                    .fetchCoordinateFromName(_title.text);
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
                          child: settings.addresses == null
                              ? Center(
                                  child: Text(
                                      "Searched locations will appear here"),
                                )
                              : settings.isFetchingData
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : settings.addresses.length == 0
                                      ? Center(
                                          child: Text(
                                              "No address matches your input"),
                                        )
                                      : ListView.builder(
                                          itemCount: settings.addresses.length,
                                          itemBuilder:
                                              (BuildContext ctx, int index) {
                                            return InkWell(
                                              onTap: () {
                                                settings.changeLocation(
                                                    settings.addresses[index]);
                                              },
                                              child: ListTile(
                                                tileColor:
                                                    Theme.of(context).cardColor,
                                                leading: Text(
                                                  "${settings.addresses[index].featureName}, ${settings.addresses[index].countryName}",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                        ),
                      ],
                    ),
                  ),
                  image: _buildImage('location'),
                  decoration: pageDecoration,
                ),
          PageViewModel(
            title: "Time is valuable",
            body:
                "Imagine sleeping without praying Isha and waking up in your grave",
            image: _buildImage('clock'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () async {
          await settings.changeFirstBoot();
          Navigator.of(context).pushNamed(RouterPathsConstants.HOME);
        },
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: false,
        showNextButton: settings.onBoardingPosition == 0 ? false : true,
        skipFlex: 0,
        nextFlex: 0,
        freeze: settings.onBoardingPosition == 0 ? true : false,
        onChange: (int pos) {
          settings.changeOnBoardingPosition(pos);
          if (pos == 1 && settings.permission != PERMISSIONS.APPROVED) {
            debugPrint("Denied");
          }
        },
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
    });
  }
}
