import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/blocs/user/user_summary_bloc.dart';

class UserPassiveListBloc extends UserSummaryBloc {

  UserPassiveListBloc() : super(LoadPassiveUsersEvent(1,10));
}
