import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/course/coach_course_bloc.dart';
import 'package:crossfit/blocs/course/course_event.dart';
import 'package:crossfit/blocs/refresh_bloc.dart';
import 'package:crossfit/blocs/user/notification_bloc.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/helpers/date_helper.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/pt/private_coach_course_response_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_asset_image.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/datatable_header_text.dart';
import 'package:crossfit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_info_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_show_user_info_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_users_screen.dart';
import 'package:crossfit/ui/pt/pt_user_info_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CoachCourseUserListField extends BaseBlocScreen {
  CoachCourseBloc _courseBloc = new CoachCourseBloc();
  var _refreshBloc = new RefreshBloc();
  var _notificationBloc = new NotificationBloc();
  var _courses = List<PrivateCoachCourseResponseModel>();
  String startDate;
  String endDate;
  String query;
  int coachId;

  CoachCourseUserListField(
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
                    Expanded(child: getCoursesList(context)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: <Widget>[],
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
      if (event is LoadCoachCoursesFinishedEvent) {
        _courses = event.courses;
      }
      if (event is ApiSuccessEvent) {
        initCourses();
      }
      _refreshBloc.refresh();
    });
    _notificationBloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  void initCourses() {
    _courseBloc.filterCourses(startDate, endDate, query, coachId);
  }

  Widget getCoursesList(BuildContext context) {
    return SingleChildScrollView(
      key: UniqueKey(),
      scrollDirection: Axis.vertical,
      child: FittedBox(
        child: DataTable(

          columns: [
            DataColumn(label: DataTableHeaderText('Üye',fontSize: 20,)),
            DataColumn(label: DataTableHeaderText('Antrönür',fontSize: 20,)),
            DataColumn(label: DataTableHeaderText('Ders',fontSize: 20,)),
            DataColumn(label: DataTableHeaderText('Telelefon',fontSize: 20,)),
          ],
          rows: _courses.map((item) {
            return DataRow(
              key: UniqueKey(),
              cells: <DataCell>[
                DataCell(
                  Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        item.userName,
                        fontSize: 18,
                        underline: true,
                        color: CustomColors.important,
                        onClick: () => goToUserDetail(context, item.user),
                      )),
                ),
                DataCell(
                  Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        item.coachName,
                        fontSize: 18,
                      )),
                ),
                DataCell(
                  Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        '${item.totalCourse}/${item.joinedCount}/${item.cancelledCount}',
                        fontSize: 18,
                      )),
                ),
                DataCell(
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CustomText(
                          item.user.phone,
                          fontSize: 18,
                          paddingRight: 5,
                          onClick: ()=>launch("tel://${item.user.phone}"),
                          underline: true,
                        ),
                        CustomAssetImage(
                          'sms-alert-icon-small.png',
                          onPressed: () => sendSms(context, item),
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  goToUserDetail(BuildContext context, UserModel userModel) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            PrivateCoachShowUserInfoScreen(userModel)));
  }

  sendSms(BuildContext context, PrivateCoachCourseResponseModel model) {
    var smsContent = 'Sayın ${model.user.name}, '
        'kalan ders sayınız: ${(model.totalCourse - model.joinedCount - model.cancelledCount)} gündür. '
        'Yenileme işlemi için antrönörünüze başvurabilirsiniz';
    ConfirmHelper.showSmsConfirmation(
      context,
      '"$smsContent" Bu SMS göndermek istediğinize emin misiniz?',
    ).then((value) {
      if (value.confirmResult == ConfirmAction.ACCEPT) {
        _notificationBloc.sendSms(model.user.id.toString(), smsContent);
      }
    });
  }

  callUser(BuildContext context, String phone) {

  }
}
