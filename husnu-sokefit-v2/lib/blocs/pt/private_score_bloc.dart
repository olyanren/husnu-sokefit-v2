import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/pt/private_score_event.dart';
import 'package:sokefit/repositories/pt/private_score_repository.dart';
import 'package:rxdart/rxdart.dart';

class PrivateScoreBloc extends BaseBloc {
  var _subject = new BehaviorSubject<ApiEvent>();
  var _eventSubject = new BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;



  PrivateScoreBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is UpdatePrivateScoreEvent) {
      var scoreRepository = new PrivateScoreRepository();
      scoreRepository.updateScore(event.scoreId, event.value).then((result) {
        if (result.status) {
          _subject.sink.add(ApiSuccessEvent(result.message));
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

  }

  void initScores() {
    var repository = new PrivateScoreRepository();
    repository.scores().then((result) {
      if(result.status==false)
        _eventSubject.add(ApiFailedEvent(result.message));
      else
      _eventSubject.sink.add(PrivateScoreFinishedEvent(result.data));
    });
  }

  @override
  void refresh() {
    initScores();
  }

  void updateScore(int id, String data) {
    _eventSubject.add(UpdatePrivateScoreEvent(id,  data));
  }
}
