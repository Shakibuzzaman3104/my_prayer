import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:my_prayer/model/ModelTasbih.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/screens/widgets/tasbih/tajbih_dialog.dart';
import 'package:my_prayer/utils/router_path_constants.dart';
import 'package:my_prayer/viewmodel/viewmodel_tasbih.dart';
import 'package:provider/provider.dart';

class ViewTasbih extends StatefulWidget {
  @override
  _ViewTasbihState createState() => _ViewTasbihState();
}

class _ViewTasbihState extends State<ViewTasbih> {
  TextEditingController _title;
  TextEditingController _recitation;
  TextEditingController _max;

  @override
  void initState() {
    ViewmodelTasbih model =
        Provider.of<ViewmodelTasbih>(context, listen: false);
    model.fetchTasbih();
    _title = TextEditingController();
    _recitation = TextEditingController();
    _max = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ViewmodelTasbih>(builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          resizeToAvoidBottomPadding: false,
          body: Container(
            padding: EdgeInsets.all(SizeConfig.imageSizeMultiplier * 3),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.heightMultiplier * 1.5),
                        alignment: Alignment.center,
                        child: Text(
                          viewModel.singleTasbih.title,
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 3,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: SizeConfig.heightMultiplier * 15,
                        width: SizeConfig.widthMultiplier * 90,
                        padding:
                            EdgeInsets.all(SizeConfig.imageSizeMultiplier * 3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.imageSizeMultiplier * 3)),
                        child: Text(
                          viewModel.singleTasbih.recitation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textMultiplier * 2),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          /*Container(
                            height: SizeConfig.imageSizeMultiplier * 70,
                            width: SizeConfig.imageSizeMultiplier * 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 15,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),*/
                          Text(
                            "${viewModel.singleTasbih.counter.floor()}/${viewModel.singleTasbih.max.floor()}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          Container(
                            height: SizeConfig.imageSizeMultiplier * 70,
                            width: SizeConfig.imageSizeMultiplier * 70,
                            /*  decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),*/
                            child: InkWell(
                              onTap: () {
                                if (viewModel.singleTasbih.counter !=
                                    viewModel.singleTasbih.max) {
                                  HapticFeedback.mediumImpact();
                                  viewModel.increaseCounter().then((value) {
                                    if (value)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Congratulations, you have reached your goal",
                                          ),
                                          duration: Duration(milliseconds: 600),
                                        ),
                                      );
                                  });
                                }
                              },
                              customBorder: new CircleBorder(),
                              child: CircularProgressIndicator(
                                strokeWidth: 10,
                                backgroundColor: Theme.of(context).cardColor,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                                value: ((100) *
                                        (viewModel.singleTasbih.counter /
                                            viewModel.singleTasbih.max)) /
                                    100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.history_toggle_off,
                                color: Theme.of(context).accentColor,
                              ),
                              iconSize: SizeConfig.imageSizeMultiplier * 6,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    RouterPathsConstants.TasbihHistory);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Theme.of(context).accentColor,
                              ),
                              iconSize: SizeConfig.imageSizeMultiplier * 6,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Are you sure"),
                                    content: Text(
                                        "Your progress will be lost forever"),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          viewModel.reset();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Yes"),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No"),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Theme.of(context).accentColor,
                              ),
                              iconSize: SizeConfig.imageSizeMultiplier * 6,
                              onPressed: () {
                                showAddEditDialog(
                                    context, _title, _recitation, _max,
                                    (ModelTasbih modelTasbih) {
                                  if (modelTasbih.index == -1) {
                                    viewModel.addTasbih(modelTasbih);
                                    debugPrint("Add");
                                  } else {
                                    debugPrint("Update ${modelTasbih.index}");
                                    viewModel.updateTasbih(modelTasbih);
                                  }
                                }, tasbih: viewModel.singleTasbih);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).backgroundColor,
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              showAddEditDialog(context, _title, _recitation, _max,
                  (modelTasbih) {
                viewModel.addTasbih(modelTasbih);
              });
            },
          ),
        );
      }),
    );
  }
}
