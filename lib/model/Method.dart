import 'package:hive/hive.dart';

import 'Params.dart';

part 'Method.g.dart';

@HiveType(typeId: 13, adapterName: 'MethodAdapter')
class Method {
    Method({
        this.id,
        this.name,
        this.params,
    });

    @HiveField(0)
    int id;
    @HiveField(1)
    String name;
    @HiveField(2)
    Params params;

    factory Method.fromJson(Map<String, dynamic> json) => Method(
        id: json["id"],
        name: json["name"],
        params: Params.fromJson(json["params"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "params": params.toJson(),
    };
}