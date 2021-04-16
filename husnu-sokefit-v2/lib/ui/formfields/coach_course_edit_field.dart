import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/course/coach_course_bloc.dart';
import 'package:crossfit/blocs/course/course_event.dart';
import 'package:crossfit/blocs/refresh_bloc.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/helpers/date_helper.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/pt/private_coach_course_response_model.dart';
import 'package:crossfit/models/string_model.dart';
import 'package:crossfit/themes/custom_dropdown_base_model_field.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/datatable_header_text.dart';
import 'package:crossfit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CoachCourseEditField extends BaseBlocScreen {
  CoachCourseBloc _courseBloc = new CoachCourseBloc();
  var _refreshBloc = new RefreshBloc();
  var _courses = List<PrivateCoachCourseResponseModel>();
  String startDate;
  String endDate;
  String query;
  int coachId;
  bool isGroup;

  List<StringModel> states = [
    StringModel("GELDİ"),
    StringModel("BEKLEMEDE"),
    StringModel("GELMEDİ"),
    StringModel("İPTAL")
  ];

  CoachCourseEditField(
      {Key key, this.startDate, this.endDate, this.query, this.coachId,this.isGroup=false})
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
              return getCoursesList(context);
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
      _courseBloc.filterCoursesForEdit(startDate, endDate, query, coachId,isGroup:isGroup);
    } else {
      _courseBloc.loadCoursesForEdit();
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
                DataColumn(label: DataTableHeaderText('DURUM SEÇİNİZ')),
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
                            item.user.name,
                            fontSize: 15,
                          )),
                    ),
                    DataCell(Align(
                        alignment: Alignment.center,
                        child: CustomDropdownBaseModelField<StringModel>(
                          hintText: 'DURUM',
                          selectedValue: StringModel(item.state),
                          items: states,
                          emptyMessage: 'Bu alan boş olamaz',
                          onChanged: (value) {
                            stateChanged(context, item,value);
                          },
                        ))),
                  ],
                );
              }).toList(),
            ),
          ),
        ));
  }

  stateChanged(context, PrivateCoachCourseResponseModel course,StringModel state) {
    if (state.value == 'GELDİ')
      _courseBloc.accept(course.id);
    else if (state.value == 'GELMEDİ')
      _courseBloc.refuse(course.id);
    else if (state.value == 'İPTAL'||state.value=='İPTAL') cancelCourse(context, course);
  }

  cancelCourse(context, PrivateCoachCourseResponseModel course) {
    ConfirmHelper.showConfirm(
            context, 'Dersi iptal etmek istediğinize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        if (course.state == 'İPTAL') {
          AlertHelper.show(context, 'Hata', 'Daha önceden iptal ettiniz');
        } else {
          _courseBloc.cancel(course.id);
        }
      }
    });
  }
}
