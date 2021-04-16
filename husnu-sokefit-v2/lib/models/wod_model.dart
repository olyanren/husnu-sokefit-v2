import 'hour_coach_model.dart';

class WodModel {
  int id;
  String day;


  WodModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,

    };
  }

  factory WodModel.fromJson(Map<String, dynamic> json) {
    var model = new WodModel();
    model.id = json["id"];
    model.day = json["day"];

    return model;
  }
}
