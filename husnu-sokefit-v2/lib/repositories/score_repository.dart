import 'package:sokefit/models/score_model.dart';
import 'package:sokefit/providers/score_provider.dart';

/*
This class is us
 */
class ScoreRepository {
  ScoreProvider provider = ScoreProvider();

  Future<List<ScoreModel>> scores(){
    return provider.scores();
  }
}
