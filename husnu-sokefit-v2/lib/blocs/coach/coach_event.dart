import 'package:sokefit/blocs/api_event.dart';


class CoachDeleteEvent extends ApiEvent{
  int coachId;
  CoachDeleteEvent(this.coachId);
}
class CoachListEvent extends ApiEvent{
  int locationId;
  CoachListEvent(this.locationId);
}
