import 'package:flutter/material.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/model/ModelTasbih.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewmodelTasbih extends BaseViewModel {
  List<ModelTasbih> _tasbihs = [];
  static ModelTasbih _modelTasbih;
  MySharedPreferences sharedPreferences;
  ModelTasbih reference = ModelTasbih(
    index: 0,
    title: "Best Dua",
    recitation: "La ilaha illallah muhammadur rasulullah (SM:)",
    counter: 0,
    max: 100,
  );

  ViewmodelTasbih() {
    _modelTasbih = reference;
    sharedPreferences = MySharedPreferences.getInstance();
  }

  ModelTasbih get singleTasbih => _modelTasbih;

  List<ModelTasbih> get tasbihs => _tasbihs;

  Future fetchTasbih() async {
    await HiveDb.getInstance().openTashbihBox();
    _tasbihs = HiveDb.getInstance().tasbih.values.toList();
    if (_tasbihs.isNotEmpty) {
      int latsIndex = await sharedPreferences.getLatsTasbih();
      _modelTasbih = _tasbihs[latsIndex];
    }
    await HiveDb.getInstance().tasbih.close();

    notifyListeners();
  }

  Future getSingleTasbih(int pos) async {
    await HiveDb.getInstance().openTashbihBox();
    await sharedPreferences.setLastTasbih(pos);
    _modelTasbih = HiveDb.getInstance()
        .tasbih
        .values
        .toList()
        .elementAt(pos);
    await HiveDb.getInstance().tasbih.close();
    notifyListeners();
  }

  Future<bool> increaseCounter() async {
    _modelTasbih.counter++;
    await HiveDb.getInstance().openTashbihBox();
    if (HiveDb.getInstance().tasbih.isNotEmpty)
      await HiveDb.getInstance().tasbih.putAt(_modelTasbih.index, _modelTasbih);
    else
      await HiveDb.getInstance().tasbih.add(_modelTasbih);
    await HiveDb.getInstance().tasbih.close();
    notifyListeners();
    if (_modelTasbih.max == _modelTasbih.counter) return true;

    return false;
  }

  Future addTasbih(ModelTasbih tasbih) async {
    await HiveDb.getInstance().openTashbihBox();
    int length = HiveDb.getInstance().tasbih.values.length;
    tasbih.index = length;
    await HiveDb.getInstance().tasbih.add(tasbih);
    await sharedPreferences.setLastTasbih(tasbih.index);
    await HiveDb.getInstance().tasbih.close();
    _modelTasbih = tasbih;
    notifyListeners();
  }

  Future updateTasbih(ModelTasbih tasbih) async {
    await HiveDb.getInstance().openTashbihBox();
    await HiveDb.getInstance().tasbih.put(tasbih.index, tasbih);
    if (tasbih.index == _modelTasbih.index) _modelTasbih = tasbih;
    notifyListeners();
    await HiveDb.getInstance().tasbih.close();
  }

  Future removeTasbih({@required int pos}) async {
    await HiveDb.getInstance().openTashbihBox();
    HiveDb.getInstance().tasbih.values.toList().removeAt(pos);
    if(await sharedPreferences.getLatsTasbih() == pos)
      {
       await sharedPreferences.setLastTasbih(HiveDb.getInstance().tasbih.length);
      }
    if (HiveDb.getInstance().tasbih.isEmpty) {
      await sharedPreferences.setLastTasbih(-1);
      _modelTasbih = reference;
    }
    await HiveDb.getInstance().tasbih.close();
    fetchTasbih();
  }

  reset() async{
    _modelTasbih.counter = 0;
    await HiveDb.getInstance().openTashbihBox();
    await HiveDb.getInstance().tasbih.putAt(_modelTasbih.index, _modelTasbih);
    await HiveDb.getInstance().tasbih.clear();
    notifyListeners();
  }
}
