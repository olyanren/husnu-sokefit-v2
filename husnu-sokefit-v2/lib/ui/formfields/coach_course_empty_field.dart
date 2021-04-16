import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/course/coach_course_bloc.dart';
import 'package:sokefit/blocs/course/course_event.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/blocs/user/notification_bloc.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/pt/hour_model.dart';
import 'package:sokefit/models/pt/private_coach_course_response_model.dart';
import 'package:sokefit/models/string_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/custom_asset_image.dart';
import 'package:sokefit/themes/custom_dropdown_base_model_field.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/datatable_header_text.dart';
import 'package:sokefit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CoachCourseEmptyField extends BaseBlocScreen {
  CoachCourseBloc _courseBloc = new CoachCourseBloc();
  var _refreshBloc = new RefreshBloc();
  var _courses = List<HourModel>();
  String startDate;
  String endDate;
  String query;
  int coachId;
  final NotificationBloc _smsBloc = new NotificationBloc();
  List<StringModel> states = [
    StringModel("GELDİ"),
    StringModel("GELMEDİ"),
    StringModel("İPTAL")
  ];

  CoachCourseEmptyField(
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
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child: drawCoursesList(context)),

                    Divider(
                      thickness: 1,
                      color: Colors.white,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomText(
                        'İlgili Tarihteki Boş Saatler',
                        color: Colors.white,
                      ),
                    ),
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
      if (event is LoadCoachCoursesEmptyFinishedEvent) {
        _courses = event.courses;
      }
      if (event is ApiSuccessEvent) {
        initCourses();
      }
      _refreshBloc.refresh();
    });
    _smsBloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  void initCourses() {
    if (startDate != null && startDate.isNotEmpty) {
      if (endDate == null || endDate.isEmpty)
        endDate = DateHelper.currentDateAsTurkish();
      _courseBloc.filterCoursesForEmpty(startDate, endDate, query, coachId);
    } else {
      _courseBloc.loadCoursesForEmpty();
    }
  }

  Widget drawCoursesList(BuildContext context) {
    return Expanded(
        key: UniqueKey(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FittedBox(
            child: DataTable(
              columns: [
                DataColumn(label: DataTableHeaderText('ANTRENÖR')),
                DataColumn(label: DataTableHeaderText('TARİH')),
                DataColumn(label: DataTableHeaderText('SAAT')),
                DataColumn(label: DataTableHeaderText('İŞLEM')),
              ],
              rows: _courses.map((item) {
                return DataRow(
                  key: UniqueKey(),
                  cells: <DataCell>[
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            item.coachName,
                            fontSize: 14,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            item.date,
                            fontSize: 14,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            item.hour,
                            fontSize: 14,
                          )),
                    ),
                    DataCell(
                      Align(
                          alignment: Alignment.center,
                          child: CustomAssetImage(
                            'sms-alert-icon.png',
                            paddingTop: 5,
                            onPressed: () => sendSms(context, item),
                          )),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ));
  }

  sendSms(context, HourModel course) {
    ConfirmHelper.showSmsConfirmationForUser(
      context,
      'SMS İçeriği: "${course.coachName} '
      'ile ${course.date} ${course.hour} saati için ders yapmak isterseniz rezervasyon yapabilirsiniz" Bu SMS göndermek istediğinize emin misiniz?',
    ).then((value) {
      if (value.confirmResult == ConfirmAction.ACCEPT) {
        _smsBloc.sendSms(value.user.id.toString(),
            'Sayın ${value.user.name}, ${course.coachName} ile ${course.date} ${course.hour} saati için ders yapmak isterseniz rezervasyon yapabilirsiniz');
      }
    });
  }
}
