

class TodayHourModel {
  int id;
  String day;
  String hour;
  String coach;
  int total;
  int remainingUserCount;
  int registerUserCount;
  String content;

  bool isParticipated;
  bool isCancelled;

  DateTime updatedAt;

  TodayHourModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'coach': coach,
      'hour': hour,
      'total': total,
      'content': content,
      'remaining_user_count': remainingUserCount,
      'register_user_count': registerUserCount,
      'is_participated': isParticipated,
      'is_cancelled': isCancelled,
      'updated_at': updatedAt,
    };
  }

  factory TodayHourModel.fromJson(Map<String, dynamic> json) {
    var item = TodayHourModel();
    item.id = json["id"];
    item.day = json["day"];
    item.coach = json["coach"]==null?"":json['coach'];
    item.hour = json["hour"];
    item.total = json["total"];
    item.content = json["content"];
    item.remainingUserCount = json["remaining_user_count"];
    item.registerUserCount = json["register_user_count"];
    item.isParticipated = json["is_participated"] == 0 ||json["is_participated"] == false ? false : true;
    item.isCancelled = json["is_cancelled"] == 0 ||json["is_cancelled"] == false ? false : true;
    item.updatedAt = DateTime.parse(json["updated_at"]);
    return item;
  }
}
