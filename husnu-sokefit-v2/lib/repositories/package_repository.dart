import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/package_model.dart';
import 'package:crossfit/providers/package_provider.dart';

/*
This class is us
 */
class PackageRepository {
  PackageProvider provider = PackageProvider();

  Future<List<PackageModel>> packages()=> provider.packages();
  Future<ApiEvent> deletePackage(int packageId)=> provider.deletePackage(packageId);

}
