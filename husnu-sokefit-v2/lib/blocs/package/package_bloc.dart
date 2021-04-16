import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/package/package_event.dart';
import 'package:sokefit/repositories/package_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_event.dart';

class PackageBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final eventSubject = BehaviorSubject<ApiEvent>();

  Sink<ApiEvent> get eventSink => eventSubject.sink;

  PackageBloc() {
    eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is PackageDeleteEvent) {
      var packageRepository = new PackageRepository();
      packageRepository.deletePackage(event.packageId).then((result) {
        if (!_subject.isClosed) _subject.sink.add(result);
      });
    }else{
      _subject.sink.add(event);
    }

  }

  @override
  void dispose() {
    _subject.close();
  }

  @override
  void init() {
    initPackages();
  }

  void initPackages() {
    var packageRepository = new PackageRepository();
    packageRepository.packages().then((result) {
      _subject.sink.add(PackageFinishedEvent(result));
    });
  }

  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }
}
