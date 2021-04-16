import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/course/coach_course_bloc.dart';
import 'package:sokefit/blocs/course/course_event.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/pt/private_coach_course_response_model.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/datatable_header_text.dart';
import 'package:sokefit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CoachCourseListField extends BaseBlocScreen {
  CoachCourseBloc _courseBloc = new CoachCourseBloc();
  var _refreshBloc = new RefreshBloc();
  var _courses = List<PrivateCoachCourseResponseModel>();
  String startDate;
  String endDate;
  String query;
  int coachId;

  CoachCourseListField(
      {Key key, this.startDate, this.endDate, this.query, this.coachId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        root: this,
        bloc: _refreshBloc,
        child: StreamBuilder<ApiEvent>(
            stream: _refreshBloc.stream,
            builder: (context, AsyncSnapshot<ApiEvent> snapshot) {
              if (!snapshot.hasData) return CustomProgressBarWave();
              var availableCount =
                  _courses.where((element) => element.state == 'GELDİ').length;
              var absentCount =
                  _courses.where((element) => element.state == 'GELMEDİ').length;
              var cancelCount =
                  _courses.where((element) => element.state == 'İPTAL').length;
              return Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomText(
                          'Geldi: $availableCount',
                          color: Colors.green,
                        ),
                        CustomText(
                          'Gelmedi: $absentCount',
                          color: Colors.red,
                        ),
                        CustomText(
                          'İptal: $cancelCount',
                          color: Colors.amber,
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(8),),
                    getCoursesList(context),
                  ],
                ),
              );
            }));
  }

  @override
  void dispose() {
    _courseBloc.dispose();
  }

  @override
  void init(BuildContext context) {
    initCourses();

    _courseBloc.stream.listen((event) {
      showResult(context, event);
      if (event is LoadCoachCoursesFinishedEvent) {
        _courses = event.courses;
      }
      if (event is ApiSuccessEvent) {
        initCourses();
      }
      _refreshBloc.refresh();
    });
  }

  void initCourses() {
    if (startDate != null && startDate.isNotEmpty) {
      if (endDate == null || endDate.isEmpty)
        endDate = DateHelper.currentDateAsTurkish();
      _courseBloc.filterCourses(startDate, endDate, query, coachId);
    } else {
      _courseBloc.loadCourses();
    }
  }

  Widget getCoursesList(BuildContext context) {
    return Expanded(
        key: UniqueKey(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FittedBox(
            child: DataTable(
              columns: [
                DataColumn(label: DataTableHeaderText('TARİH')),
                DataColumn(label: DataTableHeaderText('ÜYE')),
                DataColumn(label: DataTableHeaderText('DURUM')),
              ],
              rows: _courses.map((item) {
                return DataRow(
                  key: Key(item.id.toString()),
                  cells: <DataCell>[
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            DateHelper.getDateTimeAsTurkish(item.registerDate),
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.center,
                          child: CustomText(
                            item.user == null ? '' : item.user.name,
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.center,
                          child: CustomText(
                            item.state??'',
                            fontSize: 15,
                            color: item.state == 'GELDİ'
                                ? Colors.green
                                : (item.state == 'İPTAL'
                                    ? Colors.amber
                                    : Colors.red),
                          )),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ));
  }

  acceptCourse(context, PrivateCoachCourseResponseModel course) {
    _courseBloc.accept(course.id);
  }

  refuseCourse(context, PrivateCoachCourseResponseModel course) {
    _courseBloc.refuse(course.id);
  }

  cancelCourse(context, PrivateCoachCourseResponseModel course) {
    ConfirmHelper.showConfirm(
            context, 'Dersi iptal etmek istediğinize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        if (course.state == 'IPTAL') {
          AlertHelper.show(context, 'Hata', 'Daha önceden iptal ettiniz');
        } else {
          _courseBloc.cancel(course.id);
        }
      }
    });
  }
}
