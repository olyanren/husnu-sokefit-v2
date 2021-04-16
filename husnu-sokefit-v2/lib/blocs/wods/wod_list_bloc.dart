import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/wods/wod_event.dart';
import 'package:sokefit/repositories/wod_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class WodListBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();
  final event = BehaviorSubject<ApiEvent>();
  Stream<ApiEvent> get stream => _subject.stream;
  WodListBloc() {
    event.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is ApiStartedEvent) {
      var wodRepository = new WodRepository();
      wodRepository.wods().then((result) {
        if (result.status)
          _subject.sink.add(ApiFinishedResponseModelEvent(result));
        else
          _subject.sink.add(ApiFailedEvent(result.message));
      });

    }  else {
      _subject.sink.add(event);
    }
  }
  @override
  void init() {
    event.add(ApiStartedEvent());
  }
  @override
  void dispose() {
    _subject.close();
    event.close();
  }
  @override
  void refresh() {
    _subject.add(RefreshEvent());
  }
}
