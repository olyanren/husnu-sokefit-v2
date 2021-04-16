import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/pt/private_user_event.dart';
import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/repositories/pt/private_coach_repository.dart';
import 'package:rxdart/rxdart.dart';

class PrivateCoachBloc extends BaseBloc {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;


  PrivateCoachBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {

    if (event is PrivateUserSummaryEvent) {

      var coachRepository=new PrivateCoachRepository();
      coachRepository.summary().then((result){
        if(_subject.isClosed)return;
        if(result.status){
          _subject.sink.add(PrivateCoachSummaryFinishedEvent(result.data));
        }else{
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }
  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  @override
  void init() {
    // TODO: implement init
  }

  void summary(){
    _eventSubject.add(new PrivateUserSummaryEvent());
  }

  @override
  void refresh() {
    // TODO: implement refresh
  }


  void uploadPhoto(String path) {
    _eventSubject.add(new UploadPhotoEvent(path));
  }


}
