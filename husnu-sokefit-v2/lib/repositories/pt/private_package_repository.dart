import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/providers/pt/private_package_provider.dart';

/*
This class is us
 */
class PrivatePackageRepository {
  PrivatePackageProvider provider = PrivatePackageProvider();

  Future<ApiResponseModel> packages()=> provider.packages();
  Future<ApiEvent> deletePackage(int packageId)=> provider.deletePackage(packageId);

}
