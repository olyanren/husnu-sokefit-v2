import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/models/course_response_model.dart';
import 'package:crossfit/models/pt/hour_model.dart';
import 'package:crossfit/models/pt/private_coach_course_response_model.dart';

/*
This class is us
 */
class CoachCourseProvider {


  courses() {
    return new ApiHelper()
        .request('pt/coaches/courses-summary', accessToken: Constants.ACCESS_TOKEN)
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
  coursesForEdit() {
    return new ApiHelper()
        .request('pt/coaches/courses', accessToken: Constants.ACCESS_TOKEN)
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

  coursesForEmpty() {
    return new ApiHelper()
        .request('pt/coaches/courses-empty', accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<HourModel>(
                (item) => HourModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }
  filterCourses(String startDate,String endDate,String query,int coachId){
    var params = {'start_date': startDate,'end_date':endDate,'query':query,'coach_id':coachId.toString()};
    return new ApiHelper()
        .request('pt/coaches/courses-summary', queryParameters: params, accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<PrivateCoachCourseResponseModel>(
                (item) => PrivateCoachCourseResponseModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }
  filterCoursesForAdmin(String startDate,String endDate,String query,int coachId){
    var params = {'start_date': startDate,'end_date':endDate,'query':query,'coach_id':coachId.toString()};
    return new ApiHelper()
        .request('pt/admin/users/list', queryParameters: params, accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<PrivateCoachCourseResponseModel>(
                (item) => PrivateCoachCourseResponseModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }
  filterCoursesForEdit(String startDate,String endDate,String query,int coachId,bool isGroup){
    var params = {'start_date': startDate,'end_date':endDate,'query':query,'coach_id':coachId.toString(),'is_group':isGroup.toString()};
    return new ApiHelper()
        .request('pt/coaches/courses', queryParameters: params, accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<PrivateCoachCourseResponseModel>(
                (item) => PrivateCoachCourseResponseModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }
  filterCoursesForEmpty(String startDate,String endDate,String query,int coachId){
    var params = {'start_date': startDate,'end_date':endDate,'query':query,'coach_id':coachId.toString()};
    return new ApiHelper()
        .request('pt/coaches/courses-empty', queryParameters: params, accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<HourModel>(
                (item) => HourModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }
  accept(int courseId) {
    var params = {'course_id': courseId};
    return new ApiHelper()
        .postRequest('pt/coaches/courses/accept', params,
        accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      return result;
    });
  }
  refuse(int courseId) {
    var params = {'course_id': courseId};
    return new ApiHelper()
        .postRequest('pt/coaches/courses/refuse', params,
        accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      return result;
    });
  }
  cancel(int courseId) {
    var params = {'course_id': courseId};
    return new ApiHelper()
        .postRequest('pt/coaches/courses/cancel', params,
            accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      return result;
    });
  }

}
