import 'package:crossfit/models/base_model.dart';

class LocationModel extends BaseModel {
  int id;
  String name;
  int price;
  int dayCount;

  LocationModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,

    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    var model = new LocationModel();
    model.id = json['id'];
    model.name = json['name'];
    return model;
  }

  @override
  String toString() {
    return name;
  }
}
