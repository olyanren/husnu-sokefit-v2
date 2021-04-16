import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/database_helper.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'login_event.dart';

class LoginBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final _loginEventSubject = BehaviorSubject<ApiEvent>();

  Sink<ApiEvent> get loginEventSink => _loginEventSubject.sink;

  LoginBloc() {
    _loginEventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is LoginInitializedEvent) {
      new DatabaseHelper().user().then((user) {
        if (_subject.isClosed) return;
        _subject.sink.add(new LoginInitializeFinishedEvent(user));
      });
    }
    if (event is LoginStartedEvent) {
      String phone = event.phone;
      String password = event.password;
      bool isRemember = event.isRememberMe;
      var userRepository = new UserRepository();
      userRepository.login(phone, password).then((result) {
        if (result.status == true) {
          var user = UserModel.fromJson(result.data);
          Constants.ACCESS_TOKEN = user.accessToken;
          Constants.USER_ROLES = user.role;
          Constants.LOCATION_NAME = user.locationName;
          Constants.LOCATION_ID = user.locationId;
          user.password = password;
          if (isRemember) {
            var databaseHelper = new DatabaseHelper();
            databaseHelper.removeAll().then((result) {
              databaseHelper.saveOrUpdateUser(user);
            });
          } else {
            var databaseHelper = new DatabaseHelper();
            databaseHelper.removeFromUsers(user);
          }
          _subject.sink.add(new LoginSuccessEvent(result.message, user));
        } else
          _subject.sink.add(new LoginFailedEvent(result.message));
      });
    }
  }

  @override
  void dispose() {
    _subject.close();
    _loginEventSubject.close();
  }

  @override
  void init() {
    loginEventSink.add(new LoginInitializedEvent());
  }

  void refresh() {
    _subject.sink.add(RefreshEvent());
  }
}
