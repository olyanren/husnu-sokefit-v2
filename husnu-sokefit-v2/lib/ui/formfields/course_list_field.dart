import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/course/course_bloc.dart';
import 'package:sokefit/blocs/course/course_event.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/course_response_model.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/datatable_header_text.dart';
import 'package:sokefit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CourseListField extends BaseBlocScreen {
  CourseBloc _courseBloc = new CourseBloc();
  var _refreshBloc = new RefreshBloc();
  var _courses = List<CourseModel>();
  String startDate;
  String endDate;
  int coachId;
  CourseListField({Key key, this.coachId,this.startDate, this.endDate}) : super(key: key);

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
    if (startDate!=null && startDate.isNotEmpty) {
      if (endDate == null || endDate.isEmpty) endDate = DateHelper.currentDateAsTurkish();
      _courseBloc.loadCoursesByTwoDates(coachId, startDate, endDate);
    } else {
      _courseBloc.loadCourses();
    }

    _courseBloc.stream.listen((event) {
      showResult(context, event);
      if (event is LoadCoursesFinishedEvent) {
        _courses = event.courses;
      }
      if (event is ApiSuccessEvent) {
        _courseBloc.loadCourses();
      }
      _refreshBloc.refresh();
    });
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
                DataColumn(label: DataTableHeaderText('SAAT')),
                DataColumn(label: DataTableHeaderText('ANTRENÖR')),
                DataColumn(label: DataTableHeaderText('DURUM')),
                DataColumn(label: DataTableHeaderText('İŞLEM')),
              ],
              rows: _courses.map((item) {
                return DataRow(
                  key: Key(item.id.toString()),
                  cells: <DataCell>[
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            DateHelper.getDateAsTurkish(
                                item.registerDate.split(' ')[0]),
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            item.registerDate
                                .split(' ')[1]
                                .replaceAll(":00", ""),
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.center,
                          child: CustomText(
                            item.coach.name,
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.center,
                          child: CustomText(
                            item.state,
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      GestureDetector(
                        onTap: () => cancelCourse(context, item),
                        child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ));
  }

  cancelCourse(context, CourseModel course) {
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
