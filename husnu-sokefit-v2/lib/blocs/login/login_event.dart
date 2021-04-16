import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/user_model.dart';

class LoginInitializedEvent extends ApiEvent{}
class LoginInitializeFinishedEvent extends ApiEvent{
  UserModel user;
  LoginInitializeFinishedEvent(this.user);
}

class LoginStartedEvent extends ApiEvent{
  String phone;
  String password;
  bool isRememberMe;
  LoginStartedEvent(this.phone, this.password,this.isRememberMe);
}
class LoginSuccessEvent extends ApiFinishedEvent{
  UserModel user;
  LoginSuccessEvent(String message,this.user) : super(message);
}
class LoginFailedEvent extends ApiFailedEvent{
  LoginFailedEvent(String message) : super(message);
}