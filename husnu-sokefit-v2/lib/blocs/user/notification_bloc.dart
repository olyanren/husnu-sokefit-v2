import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class NotificationBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();
  final _eventSubject = BehaviorSubject<ApiEvent>();
  Stream<ApiEvent> get stream => _subject.stream;
  NotificationBloc() {
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
  void sendSms(String userIds, String message) {
    var repository=new UserRepository();
    repository.sendSms(userIds,message).then((result){
      if(result.status){
        _eventSubject.add(ApiSuccessEvent(result.message));
      }else{
        _eventSubject.add(ApiFailedEvent(result.message));
      }
    });
  }
  void sendSmsToCoach(int coachId, String message) {
    var repository=new UserRepository();
    repository.sendSmsToCoach(coachId,message).then((result){
      if(result.status){
        _eventSubject.add(ApiSuccessEvent(result.message));
      }else{
        _eventSubject.add(ApiFailedEvent(result.message));
      }
    });
  }

  void sendOneSignalNotification(String userIds, String message,[String tag]) {
    var repository=new UserRepository();
    repository.sendOneSignalNotification(userIds,message,tag).then((result){
      if(result.status){
        _eventSubject.add(ApiSuccessEvent(result.message));
      }else{
        _eventSubject.add(ApiFailedEvent(result.message));
      }
    });
  }
}
