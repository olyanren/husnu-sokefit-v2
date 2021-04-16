import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/location_model.dart';
import 'package:sokefit/models/package_model.dart';

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
