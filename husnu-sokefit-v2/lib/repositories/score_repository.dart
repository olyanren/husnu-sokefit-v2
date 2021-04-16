import 'package:crossfit/models/score_model.dart';
import 'package:crossfit/providers/score_provider.dart';

/*
This class is us
 */
class ScoreRepository {
  ScoreProvider provider = ScoreProvider();

  Future<List<ScoreModel>> scores(){
    return provider.scores();
  }
}
