import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/helpers/database_helper.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/models/pt/private_score_model.dart';

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
