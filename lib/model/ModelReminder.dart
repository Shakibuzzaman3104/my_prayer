import 'package:hive/hive.dart';
part 'ModelReminder.g.dart';

@HiveType(typeId: 20, adapterName: 'ModelReminderAdapter')
class ModelReminder extends HiveObject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String dateTime;
  @HiveField(3)
  bool status;

  ModelReminder({this.id,this.name,  this.dateTime,this.status=true});


  ModelReminder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dateTime = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['time'] = this.dateTime;
    data['status'] = this.status;
    return data;
  }

}