import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/location_model.dart';
import 'package:crossfit/models/package_model.dart';

class LocationFinishedEvent extends ApiEvent{
  List<LocationModel> locations;
  LocationFinishedEvent(this.locations);
}
