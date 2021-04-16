import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/models/pt/private_admin_private_register_pagination_model.dart';

/*
This class is us
 */
class PrivateAdminPrivateRegisterProvider {
  Future<PaginationModel> search(String query, int page, int itemCount) async {
    var params = new Map<String, String>();

    params["query"] = query;
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    var result = await new ApiHelper().request('pt/admin/users/registers',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
    var pagination =
        new PrivateAdminPrivateRegisterPaginationModel.fromJson(result.data);
    pagination.success = result.status;
    pagination.message = result.message;
    return pagination;
  }
}
