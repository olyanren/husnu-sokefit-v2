import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/models/package_model.dart';

/*
This class is us
 */
class PackageProvider {
  Future<List<PackageModel>> packages() {
    var baseUrl = "users";
    if (Constants.USER_ROLES.contains("admin")) baseUrl = "admin";
    else if (Constants.USER_ROLES.contains("coach")) baseUrl = "coaches";
    return new ApiHelper()
        .request('$baseUrl/packages', accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      return result.data
          .map<PackageModel>((item) => PackageModel.fromJson(item))
          .toList();
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
