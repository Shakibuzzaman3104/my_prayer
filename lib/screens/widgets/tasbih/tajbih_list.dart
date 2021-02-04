import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/viewmodel/viewmodel_tasbih.dart';
import 'package:provider/provider.dart';

import 'tajbih_dialog.dart';

class WidgetTajbihList extends StatefulWidget {
  @override
  _WidgetTajbihListState createState() => _WidgetTajbihListState();
}

class _WidgetTajbihListState extends State<WidgetTajbihList> {
  TextEditingController _title;
  TextEditingController _recitation;
  TextEditingController _max;

  @override
  void initState() {
    super.initState();
    ViewmodelTasbih model =
        Provider.of<ViewmodelTasbih>(context, listen: false);
    model.fetchTasbih();
    _title = TextEditingController();
    _recitation = TextEditingController();
    _max = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewmodelTasbih>(builder: (context, viewModel, child) {
      return Container(
        child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.imageSizeMultiplier * 2),
          crossAxisCount: 4,
          itemCount: viewModel.tasbihs.length,
          itemBuilder: (BuildContext context, int index) => new Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  BorderRadius.circular(SizeConfig.imageSizeMultiplier * 2),
            ),
            padding: EdgeInsets.only(
                left: SizeConfig.imageSizeMultiplier * 3,
                right: SizeConfig.imageSizeMultiplier * 3,
                top: SizeConfig.imageSizeMultiplier * 3),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${viewModel.tasbihs[index].title}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: SizeConfig.textMultiplier * 2,
                          fontWeight: FontWeight.bold),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: SizeConfig.imageSizeMultiplier * 8,
                          width: SizeConfig.imageSizeMultiplier * 8,
                          child: FittedBox(
                            child: Text(
                              "${viewModel.tasbihs[index].counter.floor()}/${viewModel.tasbihs[index].max.floor()}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.textMultiplier * 1.3),
                            ),
                          ),
                        ),
                        Container(
                          height: SizeConfig.imageSizeMultiplier * 10,
                          width: SizeConfig.imageSizeMultiplier * 10,
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).cardColor,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                            value: ((100) *
                                    (viewModel.tasbihs[index].counter /
                                        viewModel.tasbihs[index].max)) /
                                100,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                Text(
                  "${viewModel.tasbihs[index].recitation}",
                  maxLines: 10,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: SizeConfig.textMultiplier * 1.8),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Theme.of(context).accentColor,
                        ),
                        iconSize: SizeConfig.imageSizeMultiplier * 5,
                        onPressed: () {
                          showAddEditDialog(context, _title, _recitation, _max,
                              (modelTasbih) {
                            viewModel.addTasbih(modelTasbih);
                          }, tasbih: viewModel.tasbihs[index]);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.open_in_new,
                          color: Theme.of(context).accentColor,
                        ),
                        iconSize: SizeConfig.imageSizeMultiplier * 5,
                        onPressed: () => {
                              viewModel.getSingleTasbih(index),
                              Navigator.pop(context),
                            }),
                    IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).accentColor,
                        ),
                        iconSize: SizeConfig.imageSizeMultiplier * 5,
                        onPressed: () {
                          viewModel.removeTasbih(pos: index);
                        }),
                  ],
                ),
              ],
            ),
          ),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: SizeConfig.imageSizeMultiplier * 2,
          crossAxisSpacing: SizeConfig.imageSizeMultiplier * 2,
        ),
      );
    });
  }
}
