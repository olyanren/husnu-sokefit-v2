import 'package:crossfit/models/pagination_model.dart';
import 'package:crossfit/models/pt/pt_admin_private_register_model.dart';

class PrivateAdminPrivateRegisterPaginationModel
    extends PaginationModel<PrivateAdminPrivateRegisterModel> {
  @override
  PrivateAdminPrivateRegisterPaginationModel.fromJson(
      Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = super.getData(json);
  }

  @override
  PrivateAdminPrivateRegisterModel fromJson(Map<String, dynamic> json) {
    return PrivateAdminPrivateRegisterModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJSON(PrivateAdminPrivateRegisterModel model) {
    return model.toJson();
  }
}
