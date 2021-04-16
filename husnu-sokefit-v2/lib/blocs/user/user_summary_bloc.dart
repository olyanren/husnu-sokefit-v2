import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/user/user_event.dart';
import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/models/user_pagination_model.dart';
import 'package:sokefit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../pagination_bloc.dart';

class UserSummaryBloc extends BaseBloc
    implements PaginationBloc<UserPaginationModel> {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();
  ApiEvent event;
  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;

  get eventSink => _eventSubject.sink;

  UserSummaryBloc(this.event) {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is ApiStartedEvent) {
      var userRepository = new UserRepository();
      userRepository.users().then((result) {
        if (result.status) {
          _subject.sink.add(ApiFinishedResponseModelEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    } else if (event is LoadPassiveUsersEvent) {
      this.items(event.page, event.itemCount).then((result) {
        if (result.success) {
          _subject.sink.add(PaginationEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    } else if (event is LoadActiveUsersEvent) {
      this.activeUsers(event.page, event.itemCount).then((result) {
        if (_subject.isClosed) return null;
        if (result.success) {
          _subject.sink.add(PaginationEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    } else if (event is SearchPassiveUsersEvent) {
      this
          ._searchPassiveUsersInner(event.query, event.page, event.itemCount)
          .then((result) {
        if (result.success) {
          _subject.sink.add(PaginationEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }
    else if (event is SearchActiveUsersEvent) {
      this
          ._searchActiveUsersInner(event.query, event.page, event.itemCount)
          .then((result) {
        if (result.success) {
          _subject.sink.add(PaginationEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }
  }

  void searchActiveUsers(String query, int page, int itemCount) {
    _eventSubject.add(new SearchActiveUsersEvent(query, page, itemCount));
  }
  void searchPassiveUsers(String query, int page, int itemCount) {
    _eventSubject.add(new SearchPassiveUsersEvent(query, page, itemCount));
  }

  Future<PaginationModel> _searchPassiveUsersInner(
      String query, int page, int itemCount) async {
    var userRepository = new UserRepository();
    return userRepository.searchPassiveUsers(query, page, itemCount);
  }
  Future<PaginationModel> _searchActiveUsersInner(
      String query, int page, int itemCount) async {
    var userRepository = new UserRepository();
    return userRepository.searchActiveUsers(query, page, itemCount);
  }

  @override
  Future<PaginationModel> items(int page, int itemCount) async {
      if (_subject.isClosed) return null;
      if (this.event is LoadActiveUsersEvent)
        return this.activeUsers(page, itemCount);
      else
        return this.passiveUsers(page, itemCount);
  }

  Future<PaginationModel> passiveUsers(int page, int itemCount) async {
    var userRepository = new UserRepository();
    return userRepository.passiveUsers(page, itemCount);
  }

  Future<PaginationModel> activeUsers(int page, int itemCount) async {
    var userRepository = new UserRepository();
    return userRepository.activeUsers(page, itemCount);
  }

  void loadPassiveUsers(int page, int itemCount) {
    _eventSubject.add(new LoadPassiveUsersEvent(page, itemCount));
  }

  void loadActiveUsers(int page, int itemCount) {
    _eventSubject.add(new LoadActiveUsersEvent(page, itemCount));
  }

  @override
  void init() {
    // TODO: implement init
  }
  void initUsers(){
    _eventSubject.add(ApiStartedEvent());
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
}
