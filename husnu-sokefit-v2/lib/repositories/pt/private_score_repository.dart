import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/providers/pt/private_score_provider.dart';

/*
This class is us
 */
class PrivateScoreRepository {
  var provider = PrivateScoreProvider();

  Future<ApiResponseModel> scores()=> provider.scores();

  Future<ApiResponseModel> updateScore(int scoreId, String value) =>provider.updateScore(scoreId,value);
}
