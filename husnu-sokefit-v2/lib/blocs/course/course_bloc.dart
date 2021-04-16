import 'package:sokefit/repositories/pt/course_repository.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/repositories/pt/course_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_event.dart';
import 'course_event.dart';

class CourseBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final _eventSubject = BehaviorSubject<ApiEvent>();

  CourseBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is StoreCourseEvent) {
      var repository = new CourseRepository();
      repository
          .storeCourse(event.coachId, event.day, event.hour)
          .then((value) {
        if (value.status) {
          _subject.sink.add(new ApiSuccessEvent(value.message));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    } else if (event is LoadCoursesEvent) {
      var repository = new CourseRepository();
      repository.courses().then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoursesFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }else if (event is LoadCoursesFilterByDateEvent) {
      var repository = new CourseRepository();
      repository.coursesByDate(event.coachId,event.startDate,event.endDate).then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoursesFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }else if (event is CourseCancelEvent) {
      var repository = new CourseRepository();
      repository.cancel(event.courseId).then((value) {
        if (value.status) {
          _subject.sink.add(new ApiSuccessEvent(value.message));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }
  }

  @override
  void dispose() {
    _subject.close();
  }

  @override
  void init() {

  }
  void loadCourses(){
    _eventSubject.sink.add(LoadCoursesEvent());
  }
  void loadCoursesByTwoDates(int coachId,String startDate,String endDate){
    _eventSubject.sink.add(LoadCoursesFilterByDateEvent(coachId,startDate,endDate));
  }
  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }

  void storeCourse(int coachId, String day, String hour) {
    _eventSubject.sink.add(StoreCourseEvent(coachId, day, hour));
  }


  void cancel(courseId) {
    _eventSubject.sink.add(CourseCancelEvent(courseId));
  }
}
