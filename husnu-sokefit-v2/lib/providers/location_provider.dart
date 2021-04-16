import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/models/location_model.dart';
import 'package:crossfit/models/package_model.dart';

/*
This class is us
 */
class LocationProvider {
  Future<List<LocationModel>> locations() {
    return new ApiHelper().request('locations').then((result) {
      return result.data
          .map<LocationModel>((item) => LocationModel.fromJson(item))
          .toList();
    });
  }


}
