

class TodayHourDetailModel {
  int id;
  int accountId;
  String account;
  String category;
  String score;
  bool isParticipated;
  bool isCancelled;

  TodayHourDetailModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'account': account,
      'category': category,
      'score': score,
      'is_participated': isParticipated,
      'is_cancelled': isCancelled,
    };
  }

  factory TodayHourDetailModel.fromJson(Map<String, dynamic> json) {
    var item = TodayHourDetailModel();
    item.id = int.parse(json["id"].toString());
    item.accountId = int.parse(json["account_id"].toString());
    item.account = json["account"];
    item.category = json["category"];
    item.score = json["score"];
    item.isParticipated =
        json["is_participated"] == 0 || json["is_participated"] == false
        ||json["is_participated"] == "0"
            ? false
            : true;
    item.isCancelled = json["is_cancelled"] == 0 ||
            json["is_cancelled"] == false ||
            json["is_cancelled"] == null
        ? false
        : true;
    return item;
  }
}
