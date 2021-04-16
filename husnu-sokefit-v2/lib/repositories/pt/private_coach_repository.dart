import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/providers/pt/private_coach_provider.dart';

/*
This class is us
 */
class PrivateCoachRepository {
  var provider = PrivateCoachProvider();

  Future<ApiResponseModel> summary()=> provider.summary();
}
