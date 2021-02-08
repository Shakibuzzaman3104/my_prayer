import 'package:flutter/material.dart';
import 'package:my_prayer/model/ModelTasbih.dart';
import 'package:my_prayer/responsive/sizeconfig.dart';

Future showAddEditDialog(
    BuildContext context,
    TextEditingController _title,
    TextEditingController _recitation,
    TextEditingController _max,
    Function onClick,
    {ModelTasbih tasbih}) {
  if (tasbih != null) {
    _title.text = tasbih.title;
    _recitation.text = tasbih.recitation;
    _max.text = tasbih.max.floor().toString();
  }

  return showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.imageSizeMultiplier))),
      child: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
          height: SizeConfig.heightMultiplier * 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                tasbih == null ? "ADD TASBIH" : "EDIT TASHBIH",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.textMultiplier * 3),
              ),
              TextFormField(
                controller: _title,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  labelText: "Title",
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
              TextFormField(
                controller: _recitation,
                minLines: 10,
                maxLines: 150,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: "Description/Dua",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              TextFormField(
                controller: _max,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Total",
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
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
              ),
              MaterialButton(
                minWidth: SizeConfig.widthMultiplier * 100,
                height: SizeConfig.heightMultiplier * 5,
                onPressed: () {
                  if (_title.text.trim().isNotEmpty &&
                      _recitation.text.isNotEmpty &&
                      _max.text.trim().isNotEmpty) {
                    if (tasbih != null) {
                      if (double.parse(_max.text) < tasbih.counter) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Max value can't be less than counter value"),
                          ),
                        );
                      } else
                        onClick(ModelTasbih(
                            index: tasbih.index,
                            title: _title.text,
                            recitation: _recitation.text,
                            max: double.parse(_max.text),
                            counter: tasbih.counter));
                    } else if (double.parse(_max.text) < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Max value can't be negative"),
                        ),
                      );
                    } else
                      onClick(
                        ModelTasbih(
                            title: _title.text,
                            recitation: _recitation.text,
                            max: double.parse(_max.text),
                            counter: 0),
                      );
                    _title.clear();
                    _max.clear();
                    _recitation.clear();
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Text(
                  tasbih == null ? "Add" : "Update",
                  style: TextStyle(color: Theme.of(context).backgroundColor),
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
