class ModelPrayer {
  int id;
  String name;
  String hour;
  String min;
  int status;

  ModelPrayer({this.id,this.name, this.min,this.hour,this.status});

  ModelPrayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hour = json['hour'];
    min = json['min'];
    status = json['status'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['hour'] = this.hour;
    data['min'] = this.min;
    data['status'] = this.status;
    return data;
  }

}
