import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/payment/payment_event.dart';
import 'package:crossfit/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_event.dart';

class PaymentBloc extends BaseBloc {
  var _subject = new BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final _eventSubject = BehaviorSubject<ApiEvent>();

  Sink<ApiEvent> get eventSink => _eventSubject.sink;

  PaymentBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is PaymentStartedEvent) {
      var packageId = event.packageId;

      var userRepository = new UserRepository();
      userRepository.payment(packageId).then((result) {
        if (result.status == true)
          _subject.sink
              .add(new PaymentSuccessEvent(result.data, result.message));
        else
          _subject.sink.add(new PaymentFailEvent(result.message));
      });
    }else  if (event is PrivatePaymentStartedEvent) {
      var packageId = event.packageId;
      var coachId = event.coachId;
      var isManuel=event.isManuel;
      var userRepository = new UserRepository();
      userRepository.privatePayment(packageId,coachId,isManuel).then((result) {
        if (result.status == true)
          _subject.sink
              .add(new PaymentSuccessEvent(result.data, result.message));
        else
          _subject.sink.add(new PaymentFailEvent(result.message));
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
    // TODO: implement refresh
  }

  void startPrivatePayment(int packageId,int coachId,{bool isManuel=false}) {
    eventSink.add(new PrivatePaymentStartedEvent(packageId,coachId,isManuel));
  }
}
