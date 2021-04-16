import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/providers/pt/private_user_provider.dart';

/*
This class is us
 */
class PrivateUserRepository {
  var provider = PrivateUserProvider();

  Future<ApiResponseModel> summary({int userId:0})=> provider.summary(userId: userId);
}
