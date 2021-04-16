import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/course/course_bloc.dart';
import 'package:sokefit/blocs/course/course_event.dart';
import 'package:sokefit/blocs/pt/private_admin_events.dart';
import 'package:sokefit/blocs/pt/private_schedule_bloc.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/course_response_model.dart';
import 'package:sokefit/models/pt/hour_model.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/datatable_header_text.dart';
import 'package:sokefit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CourseAvailableListField extends BaseBlocScreen {
  CourseBloc _courseBloc = new CourseBloc();
  PrivateScheduleBloc _scheduleBloc = new PrivateScheduleBloc();
  var _refreshBloc = new RefreshBloc();
  var _courses = List<HourModel>();
  int coachId;
  String startDate;
  String endDate;

  CourseAvailableListField(
      {Key key, this.coachId, this.startDate, this.endDate})
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
    _scheduleBloc.dispose();
  }

  @override
  void init(BuildContext context) {
    _scheduleBloc.initCoachHours(coachId, startDate, endDate);
    _scheduleBloc.stream.listen((event) {
      if (event is LoadPrivateScheduleFinishedEvent) {
        _courses = event.hours;
        _refreshBloc.refresh();
      } else {
        showResult(context, event);
      }
    });
    _courseBloc.stream.listen((event) {
      showResult(context, event);
      if (event is ApiSuccessEvent) {
        _scheduleBloc.initCoachHours(coachId, startDate, endDate);
      }
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
                DataColumn(label: DataTableHeaderText('Tarih')),
                DataColumn(label: DataTableHeaderText('Saat')),
                DataColumn(label: DataTableHeaderText('Antrenör')),
                DataColumn(label: DataTableHeaderText('İşlem')),
              ],
              rows: _courses.map((item) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            item.date,
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            item.hour,
                            fontSize: 15,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            item.coachName,
                            fontSize: 15,
                          )),
                    ),
                    DataCell(CustomFlatButton(
                      'KAYIT OL',
                      onPressed: () => addHour(context, item),
                      padding: 5,
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ));
  }

  addHour(BuildContext context, HourModel hourModel) {
    ConfirmHelper.showConfirm(context, 'Kayıt olmak istediğinize emin misiniz?')
        .then((result) {
      if (result == ConfirmAction.ACCEPT) {
        _courseBloc.storeCourse(
            hourModel.coachId, hourModel.date, hourModel.hour);
      }
    });
  }
}
