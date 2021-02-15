import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
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
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
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
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Search",
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
              ),
              Container(
                height: SizeConfig.heightMultiplier * 15,
                child: viewmodel.addresses == null
                    ? Center(
                        child: Text("Searched locations will appear here",style: TextStyle(color: Theme.of(context).primaryColor),),
                      )
                    : viewmodel.isFetchingData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : viewmodel.addresses.length == 0
                            ? Center(
                                child: Text("No address matches your input",style: TextStyle(color: Theme.of(context).primaryColor),),
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
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
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
                  onClick(null);
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
      ),
    ),
  );
}
