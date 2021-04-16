import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/models/user_summary.dart';

class UserPaginationModel extends PaginationModel<UserSummary> {

  @override
  UserPaginationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data=super.getData(json);
  }

  @override
  UserSummary fromJson(Map<String, dynamic> json) {
    return UserSummary.fromJson(json);
  }
  @override
  Map<String, dynamic> toJSON(UserSummary model) {
   return model.toMap();
  }
}
