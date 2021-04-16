import 'package:sokefit/models/base_model.dart';

class HourModel extends BaseModel{
  String hour;
  String date;
  String coachName;
  int coachId;
  HourModel(this.hour);

  @override
  String toString() {
    // TODO: implement toString
    return hour;
  }

  factory HourModel.fromJson(Map<String, dynamic> json) {
    var model= new HourModel( json["hour"]);
    model.coachId=json['coach_id']??'0';
    model.coachName=json['coach_name']??'';
    model.date=json['date']??'0';
    return model;
  }
}