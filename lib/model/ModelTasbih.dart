import 'package:hive/hive.dart';
part 'ModelTasbih.g.dart';

@HiveType(typeId: 21,adapterName: "ModelTasbihAdapter")
class ModelTasbih{

  @HiveField(0)
  double counter;
  @HiveField(1)
  String title;
  @HiveField(2)
  String recitation;
  @HiveField(3)
  double max;
  @HiveField(4)
  int index;

  ModelTasbih({this.counter, this.title, this.recitation, this.max, this.index=-1});

}