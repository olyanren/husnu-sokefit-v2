
import 'package:rxdart/rxdart.dart';

import 'api_event.dart';
import 'bloc.dart';



class RefreshBloc extends BaseBloc{
  final _subject = BehaviorSubject<ApiEvent>();
  Stream<ApiEvent> get stream => _subject.stream;
  final _eventSubject = BehaviorSubject<ApiEvent>();

  Sink<ApiEvent> get event => _eventSubject.sink;
  RefreshBloc() {
    _eventSubject.listen(_mapEventToState);
  }
  void _mapEventToState(ApiEvent event) {

  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  @override
  void init() {
    //_subject.sink.add(RefreshEvent());
  }

  void refresh() {
   _subject.add(RefreshEvent());
  }

}