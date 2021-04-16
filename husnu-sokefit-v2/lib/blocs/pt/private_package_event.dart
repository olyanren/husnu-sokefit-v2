import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/pt/private_package_model.dart';

class PrivatePackageFinishedEvent extends ApiEvent{
  List<PrivatePackageModel> packages;
  PrivatePackageFinishedEvent(this.packages);
}
