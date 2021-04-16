import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/models/pagination_model.dart';
import 'package:crossfit/models/pt/private_admin_private_register_pagination_model.dart';

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
