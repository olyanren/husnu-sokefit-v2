class HourCoachModel {
  String hour;
  String coach;
  HourCoachModel();
  factory HourCoachModel.fromJson(Map<String, dynamic> json) {
    var model=new HourCoachModel();
    model.hour=json['hour'];
    model.coach=json['coach'];
    return model;
  }
}