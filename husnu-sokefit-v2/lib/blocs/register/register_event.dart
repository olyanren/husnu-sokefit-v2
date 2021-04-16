import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/user_model.dart';

class RegisterStarted extends ApiEvent{
  UserModel userModel;
  RegisterStarted(this.userModel);
}
class PrivateRegisterStarted extends ApiEvent{
  UserModel userModel;
  PrivateRegisterStarted(this.userModel);
}
class PrivateManuelPaymentRegisterStarted extends ApiEvent{
  UserModel userModel;
  PrivateManuelPaymentRegisterStarted(this.userModel);
}
class RegisterSuccess extends ApiEvent{
  UserModel userModel;
  RegisterSuccess(this.userModel);
}
class RegisterFail extends ApiFailedEvent{
  RegisterFail(String message) : super(message);
}


class PrivateAccountRenewEvent extends ApiEvent {
  int coachId;
  int packageId;
  int userId;
  PrivateAccountRenewEvent(this.coachId, this.packageId,this.userId);
}
class PrivateAccountRenewFinishedEvent extends ApiEvent {
    PrivateAccountRenewFinishedEvent();
}