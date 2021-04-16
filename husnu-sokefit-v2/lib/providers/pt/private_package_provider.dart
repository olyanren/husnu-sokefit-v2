import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/models/pt/private_package_model.dart';

/*
This class is us
 */
class PrivatePackageProvider {
  Future<ApiResponseModel> packages() {
    var params = {
      'columns[0][name]': 'id',
      'order[0][column]': '0',
      'order[0][dir]': 'asc'
    };
    return new ApiHelper()
        .request('pt/packages', queryParameters: params)
        .then((result) {
      result.data = result.data
          .map<PrivatePackageModel>(
              (item) => PrivatePackageModel.fromJson(item))
          .toList();
      return result;
    });
  }

  Future<ApiEvent> deletePackage(int packageId) {
    return new ApiHelper()
        .deleteRequest('admin/packages/$packageId',
            accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        return ApiSuccessEvent(result.message);
      } else
        return ApiFailedEvent(result.message);
    });
  }
}
