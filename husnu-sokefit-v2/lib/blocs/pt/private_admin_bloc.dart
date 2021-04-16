import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/pt/private_user_event.dart';
import 'package:sokefit/blocs/user/user_event.dart';
import 'package:sokefit/repositories/pt/private_admin_repository.dart';
import 'package:rxdart/rxdart.dart';

class PrivateAdminBloc extends BaseBloc {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;


  PrivateAdminBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {

    if (event is PrivateAdminSummaryEvent) {

      var repository=new PrivateAdminRepository();
      repository.summary().then((result){
        if(_subject.isClosed)return;
        if(result.status){
          _subject.sink.add(PrivateAdminSummaryFinishedEvent(result.data));
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
    _eventSubject.add(new PrivateAdminSummaryEvent());
  }

  @override
  void refresh() {
    // TODO: implement refresh
  }


  void uploadPhoto(String path) {
    _eventSubject.add(new UploadPhotoEvent(path));
  }


}
