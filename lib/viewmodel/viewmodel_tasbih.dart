import 'package:flutter/material.dart';
import 'package:my_prayer/model/ModelTasbih.dart';
import 'package:my_prayer/server_setup/local_database.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewmodelTasbih extends BaseViewModel {
  List<ModelTasbih> _tasbihs = [];
  static ModelTasbih _modelTasbih;
  ModelTasbih reference = ModelTasbih(
    index: 0,
    title: "Best Dua",
    recitation: "La ilaha illallah muhammadur rasulullah (SM:)",
    counter: 0,
    max: 100,
  );

  ViewmodelTasbih() {
    _modelTasbih = reference;
  }

  ModelTasbih get singleTasbih => _modelTasbih;

  List<ModelTasbih> get tasbihs => _tasbihs;

  Future fetchTasbih() async {
    await HiveDb.getInstance().openTashbihBox();
    _tasbihs = HiveDb.getInstance().tasbih.values.toList();

    if (_tasbihs.isNotEmpty) {
      _modelTasbih = _tasbihs.last;
    }
    await HiveDb.getInstance().tasbih.close();

    notifyListeners();
  }

  Future getSingleTasbih(int pos) async {
    await HiveDb.getInstance().openTashbihBox();
    _modelTasbih = HiveDb.getInstance().tasbih.values.elementAt(pos);
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
    await HiveDb.getInstance().tasbih.close();
  }

  Future removeTasbih({@required int pos}) async {
    await HiveDb.getInstance().openTashbihBox();
    await HiveDb.getInstance().tasbih.deleteAt(pos);
    if (HiveDb.getInstance().tasbih.isEmpty) _modelTasbih = reference;
    await HiveDb.getInstance().tasbih.close();
    fetchTasbih();
  }

  reset() {
    _modelTasbih.counter = 0;
    notifyListeners();
  }

  void saveTasbih() {}
}
