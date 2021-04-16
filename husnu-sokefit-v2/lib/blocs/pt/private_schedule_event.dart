import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/pt/hour_model.dart';
class LoadPrivateScheduleEvent extends ApiEvent{
  int coachId;
  String startDate;
  String endDate;
  LoadPrivateScheduleEvent(this.coachId,this.startDate,this.endDate);
}
