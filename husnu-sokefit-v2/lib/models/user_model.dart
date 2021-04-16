import 'package:crossfit/models/base_model.dart';

class UserModel extends BaseModel {
  int id;
  String name;

  String image;
  String phone;
  String password;
  String email;
  int packageId;
  int coachId;
  String coachName;
  int remainingDay;
  String finishDate;
  String accessToken;
  String datePaid;
  String role;
  String locationName;
  int joinedCount;
  int locationId;

  UserModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'phone': phone,
      'password': password,
      'email': email,
      'package_id': packageId,
      'remaining_day': remainingDay,
      'finish_date': finishDate,
      'access_token': accessToken,
      'date_paid': datePaid,
      'location_id': locationId,
      'role': role,
    };
  }

  factory UserModel.fromDatabase(Map<String, dynamic> json) {
    var userModel = new UserModel();
    userModel.id = json["id"] ?? 1;
    userModel.name = json["name"];
    userModel.email = json["email"];
    userModel.password = json["password"];
    userModel.remainingDay = json["remainingDay"]??0;
    userModel.accessToken = json["access_token"];
    userModel.locationId = json["location_id"];
    userModel.role = json["role"];

    return userModel;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var userModel = new UserModel();
    userModel.id = json["id"];
    userModel.name = json["name"] == null ? json["account"] : json["name"];
    userModel.image = json["image"] == null ? json["img"] : json["image"];
    userModel.phone = json["phone"];
    userModel.password = json["password"];
    userModel.email = json["email"];
    userModel.packageId = json["package_id"];
    userModel.remainingDay = json["remaining_day"]??0;
    userModel.finishDate = json["finish_date"];
    userModel.accessToken = json["access_token"];
    userModel.datePaid = json["date_paid"];
    userModel.role = json["roles"] ?? json['role'];
    userModel.joinedCount = json["joined_count"]??0;
    userModel.coachId = json["coach_id"];
    userModel.coachName = json["coach_name"];
    userModel.locationId = json["location_id"];
    userModel.locationName = json["location_name"];

    return userModel;
  }

  static UserModel test() {
    var userModel = new UserModel();
    userModel.name = 'Muhammed YÜCE';
    userModel.remainingDay = 10;
    userModel.coachId = 29;
    userModel.coachName = "Muhammed Koç";
    userModel.phone = "5455163924";
    userModel.email = "olyanren@gmail.com";
    return userModel;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}
