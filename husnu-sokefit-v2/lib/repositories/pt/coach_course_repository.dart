import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/providers/pt/coach_course_provider.dart';

/*
This class is us
 */
class CoachCourseRepository {
  var provider = CoachCourseProvider();

  Future<ApiResponseModel> courses() => provider.courses();

  Future<ApiResponseModel> coursesForEdit() => provider.coursesForEdit();

  Future<ApiResponseModel> coursesForEmpty() => provider.coursesForEmpty();

  Future<ApiResponseModel> filterCourses(
          String startDate, String endDate, String query, int coachId) =>
      provider.filterCourses(startDate, endDate, query, coachId);

  Future<ApiResponseModel> filterCoursesForAdmin(
          String startDate, String endDate, String query, int coachId) =>
      provider.filterCoursesForAdmin(startDate, endDate, query, coachId);

  Future<ApiResponseModel> filterCoursesForEdit(String startDate,
          String endDate, String query, int coachId, bool isGroup) =>
      provider.filterCoursesForEdit(
          startDate, endDate, query, coachId, isGroup);

  Future<ApiResponseModel> filterCoursesForEmpty(
          String startDate, String endDate, String query, int coachId) =>
      provider.filterCoursesForEmpty(startDate, endDate, query, coachId);

  Future<ApiResponseModel> accept(int courseId) => provider.accept(courseId);

  Future<ApiResponseModel> refuse(int courseId) => provider.refuse(courseId);

  Future<ApiResponseModel> cancel(int courseId) => provider.cancel(courseId);
}
