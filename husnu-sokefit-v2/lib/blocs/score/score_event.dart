import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/score_model.dart';

class ScoreFinishedEvent extends ApiEvent{
  List<ScoreModel> scores;
  ScoreFinishedEvent(this.scores);
}