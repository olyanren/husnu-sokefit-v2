import 'hour_coach_model.dart';

class WodHourModel {
  String day;
  String dayShortcut;
  List<HourCoachModel> hourCoaches;

  WodHourModel();

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'day_shortcut': dayShortcut,
      'hours': hourCoaches,
    };
  }

  factory WodHourModel.fromJson(Map<String, dynamic> json) {
    var model = new WodHourModel();
    model.day = json["day"];
    model.dayShortcut = json["day_shortcut"];
    model.hourCoaches = json["hours"] != null
        ? json["hours"]
            .map<HourCoachModel>((item) => HourCoachModel.fromJson(item))
            .toList()
        : new List<HourCoachModel>();
    return model;
  }
}
