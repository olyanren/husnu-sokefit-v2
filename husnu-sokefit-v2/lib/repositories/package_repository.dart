import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/package_model.dart';
import 'package:sokefit/providers/package_provider.dart';

/*
This class is us
 */
class PackageRepository {
  PackageProvider provider = PackageProvider();

  Future<List<PackageModel>> packages()=> provider.packages();
  Future<ApiEvent> deletePackage(int packageId)=> provider.deletePackage(packageId);

}
