import 'package:sokefit/models/base_model.dart';

class CoachModel extends BaseModel {
  int id;
  String name;

  String phone;
  String email;
  String level;
  String ratio;
  int locationId;
  CoachModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone':phone,
      'email': email,
      'level': level,
      'ratio':ratio,
      'location_id':locationId
    };
  }

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    var model = new CoachModel();
    model.id = json["id"];
    model.name = json["name"]??'';
    model.phone = json["phone"]??'';
    model.email = json["email"]??'';
    model.level = json["level"]??'';
    model.ratio = json["ratio"]??'';
    model.locationId = json["location_id"]??0;
    return model;
  }
  @override
  bool operator ==(dynamic other) {

    return id==(other.id);
  }
  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
  @override
  String toString() {
    // TODO: implement toString
    return name;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['level'] = this.level;
    data['ratio'] = this.ratio;
    data['location_id'] = this.locationId;
    return data;
  }

  factory CoachModel.test() {
    var model = new CoachModel();
    model.id = 1;
    model.name = "Muhammed YÜCE";
    model.phone = "05455163925";
    return model;
  }

}
