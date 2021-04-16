import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/score_model.dart';

class ScoreFinishedEvent extends ApiEvent{
  List<ScoreModel> scores;
  ScoreFinishedEvent(this.scores);
}