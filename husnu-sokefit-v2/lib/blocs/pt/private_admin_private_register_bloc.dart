import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/pt/private_admin_events.dart';
import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/models/pt/private_admin_private_register_pagination_model.dart';
import 'package:sokefit/repositories/pt/private_admin_private_register_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../pagination_bloc.dart';

class PrivateAdminPrivateRegisterBloc extends BaseBloc
    implements PaginationBloc<PrivateAdminPrivateRegisterPaginationModel> {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();
  ApiEvent event;

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;

  get eventSink => _eventSubject.sink;

  PrivateAdminPrivateRegisterBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
     if (event is SearchPrivateRegisterEvent) {
      _searchInner( event.query, event.page, event.itemCount)
          .then((result) {
        if (result.success) {
          _subject.sink.add(PaginationEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }
  }

  @override
  Future<PaginationModel> items(int page, int itemCount) async {
    if (_subject.isClosed) return null;
      return this._searchInner("",page, itemCount);
  }




  @override
  void init() {
    // TODO: implement init
  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  @override
  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }

  void search(String query, int page, int itemCount) {
    _eventSubject.add(
        new SearchPrivateRegisterEvent( query, page, itemCount));
  }

  Future<PaginationModel> _searchInner(
      String query, int page, int itemCount) async {
    var repository = new PrivateAdminPrivateRegisterRepository();
    return repository.search( query, page, itemCount);
  }
}
