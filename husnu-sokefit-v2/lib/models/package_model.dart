import 'package:sokefit/models/base_model.dart';

class PackageModel extends BaseModel {
  int id;
  String name;
  int price;
  int dayCount;

  PackageModel();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'day_count': dayCount,
    };
  }

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    var packageModel = new PackageModel();
    packageModel.id = json['id'];
    packageModel.name = json['name'];
    packageModel.price = json['price'];
    packageModel.dayCount = json['day_count'];
    return packageModel;
  }

  @override
  String toString() {
    var priceText = (price / 100).toStringAsFixed(2);
    return name + " (" + priceText + " TL)";
  }
}
