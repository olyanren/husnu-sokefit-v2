import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/helpers/database_helper.dart';
import 'package:sokefit/models/score_model.dart';

/*
This class is us
 */
class ScoreProvider {
  Future<List<ScoreModel>> scores() {
    var baseUrl = 'users';
    if (Constants.USER_ROLES.contains('admin')) baseUrl = 'admin';
    if (Constants.USER_ROLES.contains('coach')) baseUrl = 'coaches';

    return new ApiHelper()
        .request(baseUrl + '/scores', accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      return result.data
          .map<ScoreModel>((item) => ScoreModel.fromJson(item))
          .toList();
    });
  }
}
