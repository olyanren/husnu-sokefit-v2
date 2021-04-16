import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/models/pt/private_user_summary_model.dart';

class PrivateUserProvider {
  Future<ApiResponseModel> summary({int userId = 0}) {
    var params = {'user_id': userId.toString()};
    return new ApiHelper()
        .request(userId==0?'pt/users/summary':'pt/admin/users/summary',
            queryParameters: userId == 0 ? null : params,
            accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = PrivateUserSummaryModel.fromJson(result.data);
      }
      return result;
    });
  }
}
