import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/course_response_model.dart';
import 'package:crossfit/models/pt/hour_model.dart';
import 'package:crossfit/models/pt/private_coach_course_response_model.dart';

class StoreCourseEvent extends ApiEvent{
  int coachId;
  String day;
  String hour;
  StoreCourseEvent(this.coachId,this.day,this.hour);
}

class LoadCoursesEvent extends ApiEvent{}
class LoadCoursesForEditEvent extends ApiEvent{}
class LoadCoursesForEmptyEvent extends ApiEvent{}
class LoadCoursesFilterByDateEvent extends ApiEvent{
  int coachId;
  String startDate;
  String endDate;
  LoadCoursesFilterByDateEvent(this.coachId,this.startDate,this.endDate);
}
class LoadCoursesFilterEvent extends ApiEvent{
  String startDate;
  String endDate;
  String query;
  int coachId;
  LoadCoursesFilterEvent(this.startDate,this.endDate,this.query,this.coachId);
}
class LoadCoursesFilterForAdminEvent extends ApiEvent{
  String startDate;
  String endDate;
  String query;
  int coachId;
  LoadCoursesFilterForAdminEvent(this.startDate,this.endDate,this.query,this.coachId);
}
class LoadCoursesFilterForEditEvent extends ApiEvent{
  String startDate;
  String endDate;
  String query;
  int coachId;
  bool isGroup;
  LoadCoursesFilterForEditEvent(this.startDate,this.endDate,this.query,this.coachId,this.isGroup);
}

class LoadCoursesFilterForEmptyEvent extends ApiEvent{
  String startDate;
  String endDate;
  String query;
  int coachId;
  LoadCoursesFilterForEmptyEvent(this.startDate,this.endDate,this.query,this.coachId);
}
class LoadCoachCoursesFinishedEvent extends ApiEvent{
  List<PrivateCoachCourseResponseModel> courses;
  LoadCoachCoursesFinishedEvent(this.courses);
}
class LoadCoachCoursesEmptyFinishedEvent extends ApiEvent{
  List<HourModel> courses;
  LoadCoachCoursesEmptyFinishedEvent(this.courses);
}
class LoadCoursesFinishedEvent extends ApiEvent{
  List<CourseModel> courses;
  LoadCoursesFinishedEvent(this.courses);
}
class CourseAcceptEvent extends ApiEvent{
  int courseId;
  CourseAcceptEvent(this.courseId);
}
class CourseRefuseEvent extends ApiEvent{
  int courseId;
  CourseRefuseEvent(this.courseId);
}
class CourseCancelEvent extends ApiEvent{
  int courseId;
  CourseCancelEvent(this.courseId);
}