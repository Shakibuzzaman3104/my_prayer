import 'package:hive/hive.dart';


part 'Method.g.dart';

@HiveType(typeId: 13, adapterName: 'MethodAdapter')
class Method {
    Method({
        this.id,
        this.name,
    });

    @HiveField(0)
    int id;
    @HiveField(1)
    String name;


    factory Method.fromJson(Map<String, dynamic> json) => Method(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}