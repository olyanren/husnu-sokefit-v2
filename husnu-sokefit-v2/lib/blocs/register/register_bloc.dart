import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/register/register_event.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends BaseBloc {
  ApiEvent accessToken;
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final _eventSubject = BehaviorSubject<ApiEvent>();

  //Sink<ApiEvent> get eventSink => _eventSubject.sink;

  RegisterBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is RegisterStarted) {
      var userModel = event.userModel;

      var userRepository = new UserRepository();
      userRepository.register(userModel).then((result) {
        if (result.status == true)
          _subject.sink.add(new RegisterSuccess(UserModel.fromJson(result.data)));
        else
          _subject.sink.add(new RegisterFail(result.message));
      });
    } else if (event is PrivateRegisterStarted) {
      var userModel = event.userModel;

      var userRepository = new UserRepository();
      userRepository.privateRegister(userModel).then((result) {
        if (result.status == true)
          _subject.sink.add(new RegisterSuccess(UserModel.fromJson(result.data)));
        else
          _subject.sink.add(new RegisterFail(result.message));
      });
    }else if (event is PrivateManuelPaymentRegisterStarted) {
      var userModel = event.userModel;

      var userRepository = new UserRepository();
      userRepository.privateManuelPaymentRegister(userModel).then((result) {
        if (result.status == true)
          _subject.sink.add(new RegisterSuccess(UserModel.fromJson(result.data)));
        else
          _subject.sink.add(new RegisterFail(result.message));
      });
    }
    else if (event is PrivateAccountRenewEvent) {

      var userRepository = new UserRepository();
      userRepository.privateRenewAccount(event.coachId,event.packageId,event.userId).then((result) {
        if (result.status == true)
          _subject.sink.add(new PrivateAccountRenewFinishedEvent());
        else
          _subject.sink.add(new RegisterFail(result.message));
      });
    }
  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  @override
  void init() {
    // TODO: implement init
  }

  @override
  void refresh() {
    _subject.add(RefreshEvent());
  }

  void register(UserModel userModel) {
    _eventSubject.add(RegisterStarted(userModel));
  }

  void privateRegister(UserModel userModel) {
    _eventSubject.add(PrivateRegisterStarted(userModel));
  }
  void manuelPaymentRegister(UserModel userModel) {
    _eventSubject.add(PrivateManuelPaymentRegisterStarted(userModel));
  }

  void privateRenewAccount(int coachId, int packageId,{int userId:0}) {
    _eventSubject.add(PrivateAccountRenewEvent(coachId,packageId,userId));
  }
}
