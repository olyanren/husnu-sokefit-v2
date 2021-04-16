import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BaseBloc {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;


  UserBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
     if (event is FreezeAccountEvent) {
      _subject.sink.add(event);
      var userRepository=new UserRepository();
      userRepository.freezeAccount().then((result){
        if(result.status){
          _subject.sink.add(ApiSuccessEvent(result.message));
        }else{
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }else if (event is LoadPrivateUsersEvent){
       var userRepository=new UserRepository();
       userRepository.privateUsers().then((result){
         if (result.status) {
           _subject.sink.add(ApiFinishedResponseModelEvent(result));
         } else {
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
  void loadPrivateUsers(){
    _eventSubject.add(new LoadPrivateUsersEvent());
  }
  @override
  void refresh() {
    // TODO: implement refresh
  }

  void freezeAccount() {
    _eventSubject.add(new FreezeAccountEvent());
  }



}
