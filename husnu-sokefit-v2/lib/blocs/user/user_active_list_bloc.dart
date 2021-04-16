import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/blocs/user/user_summary_bloc.dart';

class UserActiveListBloc extends UserSummaryBloc {
  UserActiveListBloc() :super(LoadActiveUsersEvent(1,10));
}
