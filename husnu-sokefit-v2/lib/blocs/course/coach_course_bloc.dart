import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/repositories/pt/coach_course_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../api_event.dart';
import 'course_event.dart';

class CoachCourseBloc extends BaseBloc {
  final _subject = BehaviorSubject<ApiEvent>();

  Stream<ApiEvent> get stream => _subject.stream;
  final _eventSubject = BehaviorSubject<ApiEvent>();

  CoachCourseBloc() {
    _eventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is LoadCoursesEvent) {
      var repository = new CoachCourseRepository();
      repository.courses().then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoursesFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }else  if (event is LoadCoursesForEditEvent) {
      var repository = new CoachCourseRepository();
      repository.coursesForEdit().then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoursesFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }else  if (event is LoadCoursesForEmptyEvent) {
      var repository = new CoachCourseRepository();
      repository.coursesForEmpty().then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoachCoursesEmptyFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }  else if (event is LoadCoursesFilterEvent) {
      var repository = new CoachCourseRepository();
      repository
          .filterCourses(
          event.startDate, event.endDate, event.query, event.coachId)
          .then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoachCoursesFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    } else if (event is LoadCoursesFilterForAdminEvent) {
      var repository = new CoachCourseRepository();
      repository
          .filterCoursesForAdmin(
          event.startDate, event.endDate, event.query, event.coachId)
          .then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoachCoursesFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    } else if (event is LoadCoursesFilterForEditEvent) {
      var repository = new CoachCourseRepository();
      repository
          .filterCoursesForEdit(
          event.startDate, event.endDate, event.query, event.coachId,event.isGroup)
          .then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoachCoursesFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    }else if (event is LoadCoursesFilterForEmptyEvent) {
      var repository = new CoachCourseRepository();
      repository
          .filterCoursesForEmpty(
          event.startDate, event.endDate, event.query, event.coachId)
          .then((value) {
        if (value.status) {
          _subject.sink.add(new LoadCoachCoursesEmptyFinishedEvent(value.data));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    } else if (event is CourseAcceptEvent) {
      var repository = new CoachCourseRepository();
      repository.accept(event.courseId).then((value) {
        if (value.status) {
          _subject.sink.add(new ApiSuccessEvent(value.message));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    } else if (event is CourseRefuseEvent) {
      var repository = new CoachCourseRepository();
      repository.refuse(event.courseId).then((value) {
        if (value.status) {
          _subject.sink.add(new ApiSuccessEvent(value.message));
        } else {
          _subject.sink.add(new ApiFailedEvent(value.message));
        }
      });
    } else if (event is CourseCancelEvent) {
      var repository = new CoachCourseRepository();
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
  void init() {}

  void loadCourses() {
    _eventSubject.sink.add(LoadCoursesEvent());
  }

  void loadCoursesForEdit() {
    _eventSubject.sink.add(LoadCoursesForEditEvent());
  }
  void loadCoursesForEmpty() {
    _eventSubject.sink.add(LoadCoursesForEmptyEvent());
  }

  void filterCourses(
      String startDate, String endDate, String query, int coachId) {
    _eventSubject.sink
        .add(LoadCoursesFilterEvent(startDate, endDate, query, coachId));
  }
  void filterCoursesForAdmin(
      String startDate, String endDate, String query, int coachId) {
    _eventSubject.sink
        .add(LoadCoursesFilterForAdminEvent(startDate, endDate, query, coachId));
  }
  void filterCoursesForEdit(
      String startDate, String endDate, String query, int coachId,{bool isGroup=false}) {
    _eventSubject.sink
        .add(LoadCoursesFilterForEditEvent(startDate, endDate, query, coachId,isGroup));
  }
  void filterCoursesForEmpty(
      String startDate, String endDate, String query, int coachId) {
    _eventSubject.sink
        .add(LoadCoursesFilterForEmptyEvent(startDate, endDate, query, coachId));
  }
  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }

  void storeCourse(int coachId, String day, String hour) {
    _eventSubject.sink.add(StoreCourseEvent(coachId, day, hour));
  }

  void accept(courseId) {
    _eventSubject.sink.add(CourseAcceptEvent(courseId));
  }

  void refuse(courseId) {
    _eventSubject.sink.add(CourseRefuseEvent(courseId));
  }

  void cancel(courseId) {
    _eventSubject.sink.add(CourseCancelEvent(courseId));
  }
}
