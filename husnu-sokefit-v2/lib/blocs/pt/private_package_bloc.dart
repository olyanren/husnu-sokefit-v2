import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/package/package_event.dart';
import 'package:crossfit/repositories/pt/private_package_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_event.dart';

class PrivatePackageBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final eventSubject = BehaviorSubject<ApiEvent>();

  Sink<ApiEvent> get eventSink => eventSubject.sink;

  PrivatePackageBloc() {
    eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is PackageDeleteEvent) {
      var packageRepository = new PrivatePackageRepository();
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
    var packageRepository = new PrivatePackageRepository();
    packageRepository.packages().then((result) {
      if (result.status) {
        _subject.sink.add(ApiFinishedResponseModelEvent(result));
      } else {
        _subject.sink.add(ApiFailedEvent(result.message));
      }
    });
  }

  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }
}
