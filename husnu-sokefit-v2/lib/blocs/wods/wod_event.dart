import 'package:crossfit/blocs/api_event.dart';

class ApiParticipateStartedEvent extends ApiEvent {}

class ApiParticipateFinishedEvent extends ApiEvent {}

class ApiParticipateFailedEvent extends ApiEvent {}
class ApiScoreSavedEvent extends ApiEvent {}
class TodayWodCreateEvent extends ApiEvent{
  String date;
  String content;
  TodayWodCreateEvent(this.date,this.content);
}

class ApiWodDetailEvent extends ApiEvent{
  int id;
  ApiWodDetailEvent(this.id);
}
class ApiWodDetailSuccess extends ApiEvent{
  String content;
  ApiWodDetailSuccess(this.content);
}