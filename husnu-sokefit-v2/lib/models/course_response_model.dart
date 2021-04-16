import 'package:sokefit/models/coach_model.dart';

class CourseModel {
  int id;
  String registerDate;
  int coachId;
  int userId;
  String state;
  String createdAt;
  String updatedAt;
  String deletedAt;
  CoachModel coach;

  CourseModel(
      {this.id,
        this.registerDate,
        this.coachId,
        this.userId,
        this.state,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.coach});

  CourseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registerDate = json['register_date'];
    coachId = json['coach_id'];
    userId = json['user_id'];
    state = json['state'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    coach = json['coach'] != null ? new CoachModel.fromJson(json['coach']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['register_date'] = this.registerDate;
    data['coach_id'] = this.coachId;
    data['user_id'] = this.userId;
    data['state'] = this.state;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.coach != null) {
      data['coach'] = this.coach.toJson();
    }
    return data;
  }
}