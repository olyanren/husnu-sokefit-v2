import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/location/location_event.dart';
import 'package:sokefit/blocs/package/package_event.dart';
import 'package:sokefit/repositories/location_repository.dart';
import 'package:sokefit/repositories/package_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_event.dart';

class LocationBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final eventSubject = BehaviorSubject<ApiEvent>();

  Sink<ApiEvent> get eventSink => eventSubject.sink;

  LocationBloc() {
    eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
      _subject.sink.add(event);
  }

  @override
  void dispose() {
    _subject.close();
  }

  @override
  void init() {
    initLocations();
  }

  void initLocations() {
    var repo = new LocationRepository();
    repo.locations().then((result) {
      _subject.sink.add(LocationFinishedEvent(result));
    });
  }

  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }
}
