import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/pt/private_admin_summary_model.dart';
import 'package:crossfit/models/pt/private_coach_summary_model.dart';
import 'package:crossfit/models/pt/private_user_summary_model.dart';

class PrivateUserSummaryEvent extends ApiEvent{
  int coachId;
  int userId;
  PrivateUserSummaryEvent({this.coachId:0,this.userId});
}
class PrivateUserSummaryFinishedEvent extends ApiEvent{
  PrivateUserSummaryModel summaryModel;
  PrivateUserSummaryFinishedEvent(this.summaryModel);
}

class PrivateCoachSummaryEvent extends ApiEvent{}
class PrivateAdminSummaryEvent extends ApiEvent{}
class PrivateCoachSummaryFinishedEvent extends ApiEvent{
  PrivateCoachSummaryModel summaryModel;
  PrivateCoachSummaryFinishedEvent(this.summaryModel);
}

class PrivateAdminSummaryFinishedEvent extends ApiEvent{
  PrivateAdminSummaryModel summaryModel;
  PrivateAdminSummaryFinishedEvent(this.summaryModel);
}