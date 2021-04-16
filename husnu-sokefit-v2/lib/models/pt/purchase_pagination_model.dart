import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/models/pt/private_purchase_model.dart';

class PrivatePurchasePaginationModel extends PaginationModel<PrivatePurchaseModel> {
  String price;

  @override
  PrivatePurchasePaginationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    price = json['price'];

    data=super.getData(json);
  }
  @override
  PrivatePurchaseModel fromJson(Map<String, dynamic> json) {
    return PrivatePurchaseModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJSON(PrivatePurchaseModel model) {
    return model.toJson();
  }

}
