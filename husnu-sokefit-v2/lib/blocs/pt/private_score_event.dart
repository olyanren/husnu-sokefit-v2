import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/pt/private_score_model.dart';

class PrivateScoreFinishedEvent extends ApiEvent{
  List<PrivateScoreModel> scores;
  PrivateScoreFinishedEvent(this.scores);
}

class UpdatePrivateScoreEvent extends ApiEvent{
  int scoreId;
  String value;
  UpdatePrivateScoreEvent(this.scoreId,this.value);
}