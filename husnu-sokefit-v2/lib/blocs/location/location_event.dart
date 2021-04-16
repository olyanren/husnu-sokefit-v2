import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/location_model.dart';
import 'package:sokefit/models/package_model.dart';

class LocationFinishedEvent extends ApiEvent{
  List<LocationModel> locations;
  LocationFinishedEvent(this.locations);
}
