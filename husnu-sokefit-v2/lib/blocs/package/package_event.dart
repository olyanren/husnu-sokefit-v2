import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/package_model.dart';

class PackageFinishedEvent extends ApiEvent{
  List<PackageModel> packages;
  PackageFinishedEvent(this.packages);
}
class PackageDeleteEvent extends ApiEvent{
  int packageId;
  PackageDeleteEvent(this.packageId);
}