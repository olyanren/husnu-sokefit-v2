import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/models/pt/private_coach_purchase_pagination_model.dart';


/*
This class is us
 */
class PrivateCoachPurchaseItemsProvider {
  Future<PaginationModel> purchasedItems(int page, int itemCount) async {
    var params = new Map<String, String>();
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    var result = await new ApiHelper().request('pt/coaches/purchases',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
    var pagination = new PrivateCoachPurchasePaginationModel.fromJson(result.data);
    pagination.success = result.status;
    pagination.message = result.message;
    return pagination;
  }

  Future<PaginationModel> search(String startDate, String endDate, String query, int page, int itemCount,int coachId) async {
    var params = new Map<String, String>();
    params["start_date"] = startDate;
    params["end_date"] = endDate;
    params["query"] = query;
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    params["coach_id"] = coachId.toString();
    var result = await new ApiHelper().request('pt/coaches/purchases',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
    var pagination = new PrivateCoachPurchasePaginationModel.fromJson(result.data);
    pagination.success = result.status;
    pagination.message = result.message;
    return pagination;
  }
}
