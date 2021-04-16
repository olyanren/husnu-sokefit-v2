import 'package:crossfit/models/base_model.dart';

class ScoreModel extends BaseModel {
  int id;
  String name;

  String description;
  String userValue;

  ScoreModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user_value': userValue,
    };
  }

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    var model = new ScoreModel();
    model.id = json['id'];
    model.name = json['name'];
    model.description = json['description'];
    model.userValue = json['user_value'];
    return model;
  }
}
