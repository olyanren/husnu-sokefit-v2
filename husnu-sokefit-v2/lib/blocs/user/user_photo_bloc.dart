import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserPhotoBloc extends BaseBloc {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;


  UserPhotoBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is UploadPhotoEvent) {
      _subject.sink.add(event);
      var userRepository=new UserRepository();
      userRepository.updatePhoto(event.path).then((result){
        if(result.status){
          _subject.sink.add(UploadPhotoFinishedEvent(result.data['img']));
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

  @override
  void refresh() {
    // TODO: implement refresh
  }


  void uploadPhoto(String path) {
    _eventSubject.add(new UploadPhotoEvent(path));
  }
}
