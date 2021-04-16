import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/repositories/wod_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class WodHourBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();
  final _eventSubject = BehaviorSubject<ApiEvent>();

  Sink<ApiEvent> get event => _eventSubject.sink;

  Stream<ApiEvent> get stream => _subject.stream;

  WodHourBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is LoadWodHourEvent) {
      var wodRepository = new WodRepository();
      wodRepository.wodHours().then((result) {
        if (result.status)
          _subject.sink.add(ApiFinishedResponseModelEvent(result));
        else
          _subject.sink.add(ApiFailedEvent(result.message));
      });
    }
    else if (event is WodHourDeleteEvent) {
      var wodRepository = new WodRepository();
      wodRepository.removeWodHours().then((result) {
        if (_subject.isClosed) return;
          _subject.sink.add(result);
      });
    } else {
      _subject.sink.add(event);
    }
  }

  @override
  void init() {
    loadWodHours();
  }

  void loadWodHours() {
     _eventSubject.sink.add(new LoadWodHourEvent());
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
}
