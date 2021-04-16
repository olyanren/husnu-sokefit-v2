import 'package:sokefit/models/base_model.dart';

class UserSummary extends BaseModel {
  int id;
  String name;

  String phone;
  int remainingDay;
  bool isRenewSmsSent=false;

  UserSummary();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'remaining_day': remainingDay,
      'is_renew_sms_sent': isRenewSmsSent,
    };
  }

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    var userModel = new UserSummary();
    userModel.id = json["id"];
    userModel.name = json["name"] == null ? json["account"] : json["name"];

    userModel.phone = json["phone"];

    userModel.remainingDay = json["remaining_day"];
    userModel.isRenewSmsSent =
        json["is_renew_sms_sent"]==null ? false : json["is_renew_sms_sent"] == 1;
    return userModel;
  }

  @override
  bool operator ==(dynamic other) {
    return id == (other.id);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  @override
  String toString() {
    if (phone == null) return name;
    return name + " ($phone)";
  }
}
