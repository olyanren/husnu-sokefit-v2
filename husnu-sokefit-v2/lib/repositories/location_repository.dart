import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/location_model.dart';
import 'package:crossfit/models/package_model.dart';
import 'package:crossfit/providers/location_provider.dart';
import 'package:crossfit/providers/package_provider.dart';

/*
This class is us
 */
class LocationRepository {
  LocationProvider provider = LocationProvider();

  Future<List<LocationModel>> locations()=> provider.locations();


}
