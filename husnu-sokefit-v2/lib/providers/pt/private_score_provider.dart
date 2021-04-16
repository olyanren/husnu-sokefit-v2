import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/helpers/database_helper.dart';
import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/models/pt/private_score_model.dart';

/*
This class is us
 */
class PrivateScoreProvider {
  Future<ApiResponseModel> scores() {
    return new DatabaseHelper().user().then((user) {
      return new ApiHelper()
          .request('pt/users/scores', accessToken: user.accessToken)
          .then((result) {
        if (result.status == true) {
          result.data
              .map<PrivateScoreModel>((item) => PrivateScoreModel.fromJson(item))
              .toList();
        }
        return result;
      });
    });
  }
  Future<ApiResponseModel> updateScore(int scoreId, String value) {

      var postParams = {
        'score_id': scoreId,
        'value': value,
      };
      return new ApiHelper().postRequest('pt/users/scores', postParams,
          accessToken: Constants.ACCESS_TOKEN);

  }

}
