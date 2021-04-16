import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/models/pt/private_admin_summary_model.dart';

class PrivateAdminProvider{
  Future<ApiResponseModel> summary() {

      return new ApiHelper()
          .request('pt/admin/summary', accessToken: Constants.ACCESS_TOKEN)
          .then((result) {
        if (result.status == true) {
          result.data= PrivateAdminSummaryModel.fromJson(result.data);
        }
        return result;
      });

  }
}