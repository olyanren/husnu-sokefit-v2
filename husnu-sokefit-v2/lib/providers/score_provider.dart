import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/helpers/database_helper.dart';
import 'package:crossfit/models/score_model.dart';

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
