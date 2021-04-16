import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/repositories/wod_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class TodayWodHoursBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();
  final _eventSubject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;

  TodayWodHoursBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is ApiStartedEvent) {
      var wodRepository = new WodRepository();
      wodRepository.todayWodHoursUser().then((result) {
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
  @override
  void refresh() {
    _subject.add(RefreshEvent());
  }
}
