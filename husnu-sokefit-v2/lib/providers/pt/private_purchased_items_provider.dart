import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/models/pagination_model.dart';
import 'package:crossfit/models/pt/purchase_pagination_model.dart';



/*
This class is us
 */
class PrivatePurchaseItemsProvider {
  Future<PaginationModel> purchasedItems(
      int page, int itemCount, int userId) async {
    var params = new Map<String, String>();

    params["user_id"] = userId.toString();
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    var result = await new ApiHelper().request(
        userId == 0 ? 'pt/users/purchases' : 'pt/admin/users/purchases',
        accessToken: Constants.ACCESS_TOKEN,
        queryParameters: params);
    var pagination = new PrivatePurchasePaginationModel.fromJson(result.data);
    pagination.success = result.status;
    pagination.message = result.message;
    return pagination;
  }
}
