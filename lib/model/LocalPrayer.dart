import 'package:hive/hive.dart';

part 'LocalPrayer.g.dart';

@HiveType(typeId: 18, adapterName: 'LocalPrayerAdapter')
class ModelLocalPrayer extends HiveObject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String time;

 // List<UpComingPrayer> adjacentNodes;

  ModelLocalPrayer({this.id,this.name,  this.time});

/*
  UpComingPrayer.clone(UpComingPrayer source) :
        this.id = source.id,
        this.name = source.name,
        this.hour = source.hour,
        this.min = source.min,
        this.ap = source.ap,
        this.status = source.status,
        this.adjacentNodes = source.adjacentNodes.map((item) => new UpComingPrayer.clone(item)).toList();*/


  ModelLocalPrayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['time'] = this.time;
    return data;
  }

}
