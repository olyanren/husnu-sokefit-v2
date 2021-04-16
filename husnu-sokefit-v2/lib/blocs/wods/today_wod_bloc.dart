import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/wods/wod_event.dart';
import 'package:crossfit/repositories/wod_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class TodayWodBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();
  final event = BehaviorSubject<ApiEvent>();
  Stream<ApiEvent> get stream => _subject.stream;
  TodayWodBloc() {
    event.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is ApiStartedEvent) {
      var wodRepository = new WodRepository();
      wodRepository.todayWod().then((result) {
        if (result.status)
          _subject.sink.add(ApiFinishedEvent(result.data[0]['wod_content']));
        else
          _subject.sink.add(ApiFailedEvent(result.message));
      });
    }else  if (event is TodayWodCreateEvent) {
      var wodRepository = new WodRepository();
      wodRepository.createWod(event.date,event.content).then((result) {
        if (result.status)
          _subject.sink.add(ApiSuccessEvent(result.message));
        else
          _subject.sink.add(ApiFailedEvent(result.message));
      });
    } else  if (event is ApiWodDetailEvent) {
      var wodRepository = new WodRepository();
      wodRepository.wodDetail(event.id).then((result) {
        if (result.status)
          _subject.sink.add(ApiWodDetailSuccess(result.data['content']));
        else
          _subject.sink.add(ApiFailedEvent(result.message));
      });
    }  else {
      _subject.sink.add(event);
    }
  }
  @override
  void init() {

  }
  @override
  void dispose() {
    _subject.close();
    event.close();
  }
  @override
  void refresh() {
    _subject.add(RefreshEvent());
  }

  void storeWod(String date, String content) {
    event.add(new TodayWodCreateEvent(date, content));
  }

  void initWodDetailEvent(int id) {
    event.add(new ApiWodDetailEvent(id));
  }

}
