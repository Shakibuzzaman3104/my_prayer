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
        ap: maps[i]['ap'],
        status: maps[i]['status'],
      );
    });
  }


  Future updateStatus(int id, int status) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db =  await dbHelper.db;
    // row to update
    Map<String, dynamic> row = {
      'status' : status,
    };
    // do the update and get the number of affected rows
    int updateCount = await db.update(
        TableNameConstants.PRAYER_TABLE,
        row,
        where: 'id = ?',
        whereArgs: [id]);

    // show the results: print all rows in the db
    print(await db.query(TableNameConstants.PRAYER_TABLE));
  }


  Future updatePrayer(ModelPrayer modelPrayer) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db =  await dbHelper.db;
    // row to update
    Map<String, dynamic> row = {
      'name' : modelPrayer.name,
      'hour' : modelPrayer.hour,
      'min' : modelPrayer.min,
      'ap' : modelPrayer.ap,
      'status' : modelPrayer.status,
    };
    // do the update and get the number of affected rows
    int updateCount = await db.update(
        TableNameConstants.PRAYER_TABLE,
        row,
        where: 'id = ?',
        whereArgs: [modelPrayer.id]);

    // show the results: print all rows in the db
    print(await db.query(TableNameConstants.PRAYER_TABLE));
  }

}
