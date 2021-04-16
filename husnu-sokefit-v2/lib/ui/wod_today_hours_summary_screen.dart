import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/wods/today_wod_hours_bloc.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/today_hour_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/datatable_header_text.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:crossfit/ui/wod_today_hours_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WodTodayHoursSummaryScreen extends BaseUserScreen {
  TodayWodHoursBloc _bloc = new TodayWodHoursBloc();
  UserModel _userModel;

  WodTodayHoursSummaryScreen(this._userModel) : super(_userModel);

  @override
  title() {
    return CustomText('KATILIMCILAR',
        color: CustomColors.titleColor,
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  @override
  Widget innerBody(BuildContext context) {

    return BlocBuilder(
      root: this,
      bloc: _bloc,
      child: StreamBuilder(
        stream: _bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
          if (!snapshot.hasData ||
              snapshot.data is ApiFailedEvent ||
              snapshot.data is ApiStartedEvent) return CustomProgressBarWave();
          var total = 0, joined = 0, remaining = 0;
          var data=(snapshot.data as ApiFinishedResponseModelEvent)
              .responseModel
              .data;
          data.forEach((e) {
            var item=TodayHourModel.fromJson(e);
            total += item.total;
            joined += item.registerUserCount;
            remaining += item.remainingUserCount;
          });

          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(16.0)),
                Padding(padding: const EdgeInsets.all(16.0)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: DataTable(
                        dataRowHeight: 70,
                        columns: [
                          DataColumn(label: DataTableHeaderText('WOD')),
                          DataColumn(label: DataTableHeaderText('ANTRENÖR')),
                          DataColumn(label: DataTableHeaderText('TOPLAM')),
                          DataColumn(label: DataTableHeaderText('KATILIM')),
                          if (userModel.role == 'user')
                            DataColumn(label: DataTableHeaderText('KAYDOL'))
                          else
                            DataColumn(label: DataTableHeaderText('KALAN'))
                        ],
                        rows: (snapshot.data as ApiFinishedResponseModelEvent)
                            .responseModel
                            .data
                            .map<DataRow>((item) {
                          var model = TodayHourModel.fromJson(item);

                          return DataRow(
                            key: Key(model.id.toString()),
                            cells: <DataCell>[
                              DataCell(
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      model.hour,
                                      textDecoration: TextDecoration.underline,
                                      fontSize: 20,
                                    )),
                                onTap: () {
                                  goToTodayWodDetailScreen(
                                      context, _userModel, model);
                                },
                              ),
                              DataCell(
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      model.coach,
                                      textDecoration: TextDecoration.none,
                                      fontSize: 20,
                                    )),
                                onTap: () {},
                              ),
                              DataCell(
                                Align(
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      '${model.total}',
                                      color: CustomColors.titleColor,
                                      fontSize: 20,
                                    )),
                              ),
                              DataCell(
                                Align(
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      '${model.registerUserCount}',
                                      color: Colors.yellow,
                                      fontSize: 20,
                                    )),
                                onTap: () {},
                              ),
                              if (userModel.role == 'user')
                                DataCell(
                                  CustomFlatButton(
                                    model.isCancelled ? "KATIL" : "KATILDINIZ",
                                    onPressed: () =>
                                        this.choseParticipate(context, model),
                                    paddingBottom: 5,
                                  ),
                                  onTap: () {},
                                )
                              else
                                DataCell(CustomText(
                                  '${model.remainingUserCount}',
                                  fontSize: 20,
                                )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(16.0)),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomText("Kontenjan"),
                        CustomText("Katılım"),
                        CustomText("Kalan"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomText(total.toString()),
                        CustomText(joined.toString()),
                        CustomText(remaining.toString()),
                      ],
                    ),
                  ],
                )
              ]);
        },
      ),
    );
  }

  void init(BuildContext context) {
    _bloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  void participate(BuildContext context, TodayHourModel todayHourModel) {
    ConfirmHelper.showWodConfirm(context, todayHourModel, false).then((result) {
      if (result == ConfirmAction.ACCEPT) {
        _bloc.participateUser(todayHourModel.updatedAt);
      }
    });
  }

  void goToTodayWodDetailScreen(BuildContext context, UserModel userModel,
      TodayHourModel todayHourModel) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            WodTodayHoursDetailScreen(userModel, todayHourModel)));
  }

  void cancelParticipate(BuildContext context, TodayHourModel todayHourModel) {
    ConfirmHelper.showWodConfirm(context, todayHourModel, true).then((result) {
      if (result == ConfirmAction.ACCEPT) {
        _bloc.cancelParticipate(todayHourModel.updatedAt);
      }
    });
  }

  void showResult(BuildContext context, ApiEvent event) {
    if (event is ApiFailedEvent) {
      AlertHelper.showToast(context, 'Hata Oluştu', event.message);
    }
  }

  choseParticipate(BuildContext context, TodayHourModel model) {
    model.isCancelled == false
        ? cancelParticipate(context, model)
        : participate(context, model);
  }
}
