class ModelPrayer {
  int id;
  String name;
  String hour;
  String min;
  String ap;
  int status;

  List<ModelPrayer> adjacentNodes;

  ModelPrayer({this.id,this.name, this.ap,this.min,this.hour,this.status});


  ModelPrayer.clone(ModelPrayer source) :
        this.id = source.id,
        this.name = source.name,
        this.hour = source.hour,
        this.min = source.min,
        this.ap = source.ap,
        this.status = source.status,
        this.adjacentNodes = source.adjacentNodes.map((item) => new ModelPrayer.clone(item)).toList();


  ModelPrayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hour = json['hour'];
    min = json['min'];
    ap = json['ap'];
    status = json['status'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['hour'] = this.hour;
    data['min'] = this.min;
    data['ap'] = this.ap;
    data['status'] = this.status;
    return data;
  }

}
