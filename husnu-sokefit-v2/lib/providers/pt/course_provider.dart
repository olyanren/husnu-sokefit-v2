import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/models/course_response_model.dart';

/*
This class is us
 */
class CourseProvider {
  storeCourse(int coachId, String day, String hour) {
    var params = {'coach_id': coachId, 'day': day, 'hour': hour};
    return new ApiHelper()
        .postRequest('pt/users/courses', params,
            accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = CourseModel.fromJson(result.data);
      }
      return result;
    });
  }

  courses() {
    return new ApiHelper()
        .request('pt/users/courses', accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<CourseModel>(
                (item) => CourseModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }
  coursesByDate(int coachId,String startDate,String endDate){
    var params = {'coach_id':coachId.toString(),'start_date': startDate,'end_date':endDate};
    return new ApiHelper()
        .request('pt/users/courses', queryParameters: params, accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<CourseModel>(
                (item) => CourseModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }
  cancel(int courseId) {
    var params = {'course_id': courseId};
    return new ApiHelper()
        .postRequest('pt/users/courses/cancel', params,
            accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      return result;
    });
  }

}
