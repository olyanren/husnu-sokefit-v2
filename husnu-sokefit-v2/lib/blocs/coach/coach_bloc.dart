import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/coach/coach_event.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class CoachBloc extends BaseBloc {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;
  get eventSink => _eventSubject.sink;

  CoachBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is CoachListEvent) {
      var userRepository = new UserRepository();
      userRepository.coaches(event.locationId).then((result) {
        if (result.status) {
          _subject.sink.add(ApiFinishedResponseModelEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }
    else if (event is CoachDeleteEvent) {
      var userRepository = new UserRepository();
      userRepository.deleteCoach(event.coachId).then((result) {
        if (!_subject.isClosed) _subject.sink.add(result);
      });
    }else{
      _subject.sink.add(event);
    }
  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  @override
  void init() {

  }

  void initByLocationId(int locationId){
    _eventSubject.add(CoachListEvent(locationId));
  }
  @override
  void refresh() {
    _subject.first.then((event){
      _subject.sink.add(event);
    });
  }

  void createCoach(CoachModel coachModel) {
    var userRepository=new UserRepository();
    userRepository.createCoach(coachModel).then((result){
      if(result.status){
        _subject.sink.add(ApiSuccessEvent(result.message));
      }else{
        _subject.sink.add(ApiFailedEvent(result.message));
      }
    });
  }
}
