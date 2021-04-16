import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/providers/pt/private_coach_provider.dart';

/*
This class is us
 */
class PrivateCoachRepository {
  var provider = PrivateCoachProvider();

  Future<ApiResponseModel> summary()=> provider.summary();
}
