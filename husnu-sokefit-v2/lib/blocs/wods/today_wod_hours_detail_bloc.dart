import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/wods/wod_event.dart';
import 'package:crossfit/repositories/wod_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class TodayWodHoursDetailBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();
  final _eventSubject = BehaviorSubject<ApiEvent>();
  DateTime _updatedWodDate;

  Stream<ApiEvent> get stream => _subject.stream;

  TodayWodHoursDetailBloc(this._updatedWodDate) {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is ApiStartedEvent) {
      var wodRepository = new WodRepository();
      wodRepository.todayWodHourDetail(_updatedWodDate).then((result) {
        if (result.status)
          _subject.sink.add(ApiFinishedResponseModelEvent(result));
        else
          _subject.sink.add(ApiFailedEvent(result.message));
      });
    } else {
      _subject.sink.add(event);
    }
  }

  @override
  void init() {
    _eventSubject.sink.add(new ApiStartedEvent());
  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  void participateUser(DateTime updatedWodDate) {
    var wodRepository = new WodRepository();
    wodRepository.participateUserToWod(updatedWodDate).then((result) {
      if (!result.status) {
        _eventSubject.sink.add(new ApiFailedEvent(result.message));
      }
      _eventSubject.sink.add(new ApiStartedEvent());
    });
  }

  void cancelParticipate(DateTime updatedWodDate) {
    var wodRepository = new WodRepository();
    wodRepository.cancelParticipate(updatedWodDate).then((result) {
      if (!result.status) {
        _eventSubject.sink.add(new ApiFailedEvent(result.message));
      }
      _eventSubject.sink.add(new ApiStartedEvent());
    });
  }

  void addScore(DateTime wodUpdatedAt, String category, String score) {
    var wodRepository = new WodRepository();
    wodRepository.addScore(wodUpdatedAt, category, score).then((result) {
      if (result.status) {
        _eventSubject.sink.add(new ApiScoreSavedEvent());
      } else {
        _eventSubject.sink.add(new ApiFailedEvent(result.message));
      }
    });
  }

  void refresh() {
    _subject.sink.add(RefreshEvent());
  }

  void coachSetParticipated(int userWodId, String status) {
    var wodRepository = new WodRepository();
    wodRepository.coachSetParticipated(userWodId, status).then((result) {
      if (result.status) {
        init();
      } else {
        _eventSubject.sink.add(new ApiFailedEvent(result.message));
        _subject.first.then((value) => {
        _subject.add(value)
        });
      }
    });
  }
}
