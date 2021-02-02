import 'package:hive/hive.dart';

@HiveType(typeId: 20, adapterName: 'ModelReminderAdapter')
class ModelReminder extends HiveObject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String time;
  @HiveField(3)
  int status;

  ModelReminder({this.id,this.name,  this.time,this.status=0});


  ModelReminder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['time'] = this.time;
    data['status'] = this.status;
    return data;
  }

}