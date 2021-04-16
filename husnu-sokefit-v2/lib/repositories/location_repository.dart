import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/location_model.dart';
import 'package:sokefit/models/package_model.dart';
import 'package:sokefit/providers/location_provider.dart';
import 'package:sokefit/providers/package_provider.dart';

/*
This class is us
 */
class LocationRepository {
  LocationProvider provider = LocationProvider();

  Future<List<LocationModel>> locations()=> provider.locations();


}
