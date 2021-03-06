import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/providers/pt/private_schedule_provider.dart';

/*
This class is us
 */
class PrivateScheduleRepository {
  PrivateScheduleProvider provider = PrivateScheduleProvider();
  Future<ApiResponseModel> availableHours (int coachId,String startDate,String endDate)=> provider.availableHours(coachId,startDate,endDate);
}
