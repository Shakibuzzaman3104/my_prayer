import 'package:my_prayer/local_database/sqf_database.dart';
import 'package:my_prayer/models/model_prayer.dart';
import 'package:my_prayer/utils/table_name_constants.dart';
import 'package:sqflite/sqflite.dart';

class Api {
  DBHelper dbHelper;

  Api({this.dbHelper});

  Future<int> addPrayer(ModelPrayer prayer) async {
    Database dbClient = await dbHelper.db;
    return await dbClient.insert(
      TableNameConstants.PRAYER_TABLE,
      prayer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<ModelPrayer>> getPrayers() async {
    Database dbClient = await dbHelper.db;
    final List<Map<String, dynamic>> maps = await dbClient.query(TableNameConstants.PRAYER_TABLE);
    return List.generate(maps.length, (i) {
      return ModelPrayer(
        id: maps[i]['id'],
        name: maps[i]['name'],
        hour: maps[i]['hour'],
        min: maps[i]['min'],
        status: maps[i]['status'],
      );
    });
  }
}
