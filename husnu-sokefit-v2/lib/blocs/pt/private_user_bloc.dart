import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/pt/private_user_event.dart';
import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/repositories/pt/private_user_repository.dart';
import 'package:crossfit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class PrivateUserBloc extends BaseBloc {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;


  PrivateUserBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is UploadPhotoEvent) {
      var userRepository=new UserRepository();
      userRepository.updatePhoto(event.path).then((result){
        if(result.status){
          _subject.sink.add(UploadPhotoFinishedEvent(result.data['img']));
        }else{
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }
    if (event is PrivateUserSummaryEvent) {

      var userRepository=new PrivateUserRepository();
      userRepository.summary(userId:event.userId).then((result){
        if(_subject.isClosed)return;
        if(result.status){
          _subject.sink.add(PrivateUserSummaryFinishedEvent(result.data));
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

  void summary({int userId=0}){
    _eventSubject.add(new PrivateUserSummaryEvent(userId:userId));
  }

  @override
  void refresh() {
    // TODO: implement refresh
  }


  void uploadPhoto(String path) {
    _eventSubject.add(new UploadPhotoEvent(path));
  }


}
