import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/providers/pt/private_admin_provider.dart';

/*
This class is us
 */
class PrivateAdminRepository {
  var provider = PrivateAdminProvider();

  Future<ApiResponseModel> summary()=> provider.summary();
}
