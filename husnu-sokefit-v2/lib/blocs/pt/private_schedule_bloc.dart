import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/pt/private_admin_events.dart';
import 'package:crossfit/blocs/pt/private_schedule_event.dart';
import 'package:crossfit/repositories/pt/private_schedule_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_event.dart';

class PrivateScheduleBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final _eventSubject = BehaviorSubject<ApiEvent>();

  PrivateScheduleBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is LoadPrivateScheduleEvent) {
      var repository = new PrivateScheduleRepository();
      repository.availableHours(event.coachId,event.startDate,event.endDate).then((value) {
        if(value.status){
          _subject.sink.add(new LoadPrivateScheduleFinishedEvent(value.data));
        }else{
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }
  }

  @override
  void dispose() {
    _subject.close();
  }

  @override
  void init() {}

  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }

  void initCoachHours(int coachId,String startDate,String endDate) {
    _eventSubject.sink.add(new LoadPrivateScheduleEvent(coachId,startDate,endDate));
  }


}
