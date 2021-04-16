import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/models/course_response_model.dart';
import 'package:sokefit/models/pt/hour_model.dart';

/*
This class is us
 */
class PrivateScheduleProvider {
  Future<ApiResponseModel> availableHours(int coachId, String startDate,String endDate) {
    var params = {'coach_id': coachId, 'start_date': startDate,'end_date':endDate};
    return new ApiHelper()
        .postRequest('pt/users/available-hours', params,accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      result.data = result.data
          .map<HourModel>((item) => HourModel.fromJson(item))
          .toList();
      return result;
    });
  }

  storeCourse(int coachId, String day, String hour) {
    var params = {'coach_id': coachId, 'day': day, 'hour': hour};
    return new ApiHelper()
        .postRequest('pt/users/courses', params,accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
          if(result.status==true){
            result.data =CourseModel.fromJson(result.data);
          }
      return result;
    });
  }

}
