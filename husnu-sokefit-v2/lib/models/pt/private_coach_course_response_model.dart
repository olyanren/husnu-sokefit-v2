import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/user_model.dart';

class PrivateCoachCourseResponseModel {
  int id;
  String registerDate;
  int coachId;
  String coachName;
  String userName;
  String userImage;
  String userPhone;
  int userId;
  String totalPrice;
  String state;
  String createdAt;
  String updatedAt;
  String deletedAt;

  int totalCourse;
  int joinedCount;
  int cancelledCount;
  int absentCount;
  int rawPrice;
  int primPrice;
  UserModel user;
  UserModel couple;
  CoachModel coach;

  PrivateCoachCourseResponseModel({
    this.id,
    this.registerDate,
    this.coachId,
    this.userId,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  PrivateCoachCourseResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registerDate = json['register_date'];
    coachId = json['coach_id'] == null
        ? 0
        : int.parse(json['coach_id'].toString() ?? '0');
    coachName = json['coach_name'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userPhone = json['user_phone'];
    userId = json['userId'] == null
        ? 0
        : int.parse(json['userId'].toString() ?? '0');
    state = json['state'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    totalCourse = json['total_course'] == null
        ? 0
        : int.parse(json['total_course'].toString() ?? '0');
    joinedCount = json['joined_count'] == null
        ? 0
        : int.parse(json['joined_count'].toString() ?? '0');
    absentCount = json['absent_count'] == null
        ? 0
        : int.parse(json['absent_count'].toString() ?? '0');
    cancelledCount = json['cancelled_count'] == null
        ? 0
        : int.parse(json['cancelled_count'].toString() ?? '0');
    rawPrice = json['raw_price'];
    primPrice = json['prim_price']==null?0:json['prim_price'].toInt();
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    couple =
    json['couple'] != null ? new UserModel.fromJson(json['couple']) : null;
    coach =
    json['coach'] != null ? new CoachModel.fromJson(json['coach']) : null;

    if (couple != null) userName = userName + '(' + couple.name + ')';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['register_date'] = this.registerDate;
    data['coach_id'] = this.coachId;
    data['user_name'] = this.userName;
    data['coach_name'] = this.coachName;
    data['userId'] = this.userId;
    data['total_price'] = this.totalPrice;
    data['state'] = this.state;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['total_course'] = this.totalCourse;
    data['joined_count'] = this.joinedCount;
    data['absent_count'] = this.absentCount;
    data['cancelled_count'] = this.cancelledCount;
    data['raw_price'] = this.rawPrice;
    data['prim_price'] = this.primPrice;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.couple != null) {
      data['couple'] = this.couple.toJson();
    }
    if (this.coach != null) {
      data['coach'] = this.coach.toJson();
    }
    return data;
  }
}
