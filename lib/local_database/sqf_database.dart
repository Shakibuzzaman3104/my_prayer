import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:my_prayer/models/model_prayer.dart';
import 'package:my_prayer/utils/table_name_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  initDb() async {
    var theDb = await openDatabase(join(await getDatabasesPath(), "todo.db"),
        version: 1, onCreate: _onCreate,onConfigure: _onConfigure);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE prayer(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, hour TEXT,min TEXT,ap TEXT, status INTEGER)");

    print("Table Created");

    Batch batch = db.batch();
    String prayerJson = await rootBundle.loadString('assets/json/prayer.json');
    List citiesList = json.decode(prayerJson);
    citiesList.forEach((val) {
      ModelPrayer modelPrayer = ModelPrayer.fromJson(val);
      batch.insert(TableNameConstants.PRAYER_TABLE, modelPrayer.toMap());
    });

    batch.commit();

    print("data inserted");
  }

 /* void saveEmployee(Employee employee) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Employee(firstname, lastname, mobileno, emailid ) VALUES(' +
              '\'' +
              employee.firstName +
              '\'' +
              ',' +
              '\'' +
              employee.lastName +
              '\'' +
              ',' +
              '\'' +
              employee.mobileNo +
              '\'' +
              ',' +
              '\'' +
              employee.emailId +
              '\'' +
              ')');
    });
  }

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = new List();
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["firstname"], list[i]["lastname"],
          list[i]["mobileno"], list[i]["emailid"]));
    }
    print(employees.length);
    return employees;
  }*/
}
