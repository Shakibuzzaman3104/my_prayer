
import 'package:hive/hive.dart';

part 'Designation.g.dart';

@HiveType(typeId: 9, adapterName: 'DesignationAdapter')

class Designation extends HiveObject{
    Designation({
        this.abbreviated,
        this.expanded,
    });

    @HiveField(0)
    String abbreviated;
    @HiveField(1)
    String expanded;

    factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        abbreviated: json["abbreviated"],
        expanded: json["expanded"],
    );

    Map<String, dynamic> toJson() => {
        "abbreviated": abbreviated,
        "expanded": expanded,
    };
}