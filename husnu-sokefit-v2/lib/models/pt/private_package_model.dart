import 'package:sokefit/models/base_model.dart';

class PrivatePackageModel extends BaseModel {
  int id;
  String name;

  String price;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  PrivatePackageModel(
      {
        this.price,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  PrivatePackageModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    price =json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return name+" (Fiyat: $price₺)";
  }
}