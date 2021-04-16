import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/repositories/wod_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class TodayWodCreateBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();
  final _eventSubject = BehaviorSubject<ApiEvent>();
  Stream<ApiEvent> get stream => _subject.stream;
  TodayWodCreateBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    _subject.sink.add(event);
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
  @override
  void refresh() {
    _subject.add(RefreshEvent());
  }

  void saveWodHour(String day, String hour,int total,int coachId) {
    var repository=new WodRepository();
    repository.saveWodHour(day,hour,total,coachId).then((result){
      if(result.status){
        _eventSubject.add(ApiFinishedResponseModelEvent(result));
      }else{
        _eventSubject.add(ApiFailedEvent(result.message));
      }
    });
  }

}
