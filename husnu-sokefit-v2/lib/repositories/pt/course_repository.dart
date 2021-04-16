import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/providers/pt/course_provider.dart';

/*
This class is us
 */
class CourseRepository {
  var provider = CourseProvider();
  Future<ApiResponseModel> storeCourse (int coachId,String day, String hour)=> provider.storeCourse(coachId,day,hour);
  Future<ApiResponseModel> courses ( )=> provider.courses();
  Future<ApiResponseModel> coursesByDate (int coachId,String startDate,String endDate )=> provider.coursesByDate(coachId,startDate,endDate);
  Future<ApiResponseModel> cancel (int courseId )=> provider.cancel(courseId);

}
