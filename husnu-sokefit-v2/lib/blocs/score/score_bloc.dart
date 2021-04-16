import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/score/score_event.dart';
import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/repositories/score_repository.dart';
import 'package:crossfit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class ScoreBloc extends BaseBloc {
  var _subject = new BehaviorSubject<ApiEvent>();
  var _eventSubject = new BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;

  get eventSink => _eventSubject.sink;

  ScoreBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is StartScoreUpdateEvent) {
      var userRepository = new UserRepository();
      userRepository.updateScore(event.scoreId, event.value).then((result) {
        if (result.status) {
          _subject.sink.add(ScoreUpdateFinishedEvent(result.message));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }else{
      _subject.add(event);
    }
  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  @override
  void init() {
    initScores();
  }

  void initScores() {
    var repository = new ScoreRepository();
    repository.scores().then((result) {
      _eventSubject.sink.add(ScoreFinishedEvent(result));
    });
  }

  @override
  void refresh() {
    initScores();
  }
}
