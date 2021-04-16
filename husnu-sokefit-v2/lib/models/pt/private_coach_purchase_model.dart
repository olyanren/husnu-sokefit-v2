import 'package:crossfit/models/user_model.dart';

class PrivateCoachPurchaseModel {
  int id;
  int coachId;
  int userId;
  int packageId;
  int dayCount;
  bool isFromAdmin;
  int price;
  bool isPaid;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  UserModel user;

  PrivateCoachPurchaseModel(
      {this.id,
        this.coachId,
        this.userId,
        this.packageId,
        this.dayCount,
        this.isFromAdmin,
        this.price,
        this.isPaid,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user});

  PrivateCoachPurchaseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coachId = json['coach_id'];
    userId = json['user_id'];
    packageId = json['package_id'];
    dayCount = json['day_count'];
    isFromAdmin = json['is_from_admin'];
    price = json['price'];
    isPaid = json['is_paid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coach_id'] = this.coachId;
    data['user_id'] = this.userId;
    data['package_id'] = this.packageId;
    data['day_count'] = this.dayCount;
    data['is_from_admin'] = this.isFromAdmin;
    data['price'] = this.price;
    data['is_paid'] = this.isPaid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }


}