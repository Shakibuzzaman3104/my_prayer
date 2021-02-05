import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/model/ModelTasbih.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';
import 'package:my_prayer/viewmodel/viewmodel_settings.dart';

Future showChangeServerDialog(
    BuildContext context,
    TextEditingController _title,
    ViewModelSettings viewmodel,
    Function onClick) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.imageSizeMultiplier))),
      child: SingleChildScrollView(
        child: Container(
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
                controller: _title,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  hintText: "Ex: old trafford,manchester",
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
                  onPressed: () {
                    if (_title.text.trim().isNotEmpty)
                      viewmodel.fetchCoordinateFromName(_title.text);
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
                height: SizeConfig.heightMultiplier * 20,
                child: ListView.builder(
                    itemCount: viewmodel.addresses.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return InkWell(
                        onTap: (){
                          debugPrint("${viewmodel.addresses[index].locality}");
                        },
                        child: ListTile(
                          leading: Text(
                              "${viewmodel.addresses[index].featureName}, ${viewmodel.addresses[index].countryName}"),
                        ),
                      );
                    }),
              ),
              MaterialButton(
                minWidth: SizeConfig.widthMultiplier * 100,
                height: SizeConfig.heightMultiplier * 5,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
