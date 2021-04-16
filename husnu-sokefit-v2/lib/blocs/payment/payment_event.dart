import 'package:crossfit/blocs/api_event.dart';

class PaymentStartedEvent extends ApiEvent{
  int packageId;
  PaymentStartedEvent(this.packageId);
}
class PaymentSuccessEvent extends ApiFinishedEvent{
  String htmlUrl;
  PaymentSuccessEvent(this.htmlUrl,String message) : super(message);
}
class PaymentFailEvent extends ApiFailedEvent{
  PaymentFailEvent(String message) : super(message);
}

class PrivatePaymentStartedEvent extends ApiEvent{
  int packageId;
  int coachId;
  bool isManuel;
  PrivatePaymentStartedEvent(this.packageId,this.coachId,this.isManuel);
}