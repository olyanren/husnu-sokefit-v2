import 'package:crossfit/models/pagination_model.dart';
import 'package:crossfit/models/pt/private_coach_purchase_model.dart';

class PrivateCoachPurchasePaginationModel extends PaginationModel<PrivateCoachPurchaseModel> {
  String price;
  String prim;
  @override
  PrivateCoachPurchasePaginationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    price = json['price'];
    prim = json['prim'];
    data=super.getData(json);
  }
  @override
  PrivateCoachPurchaseModel fromJson(Map<String, dynamic> json) {
    return PrivateCoachPurchaseModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJSON(PrivateCoachPurchaseModel model) {

    return model.toJson();
  }

}
