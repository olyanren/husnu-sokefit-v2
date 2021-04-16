import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/wods/today_wod_hours_detail_bloc.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/models/today_hour_detail_model.dart';
import 'package:crossfit/models/today_hour_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/datatable_header_text.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:crossfit/ui/wod_today_hours_add_score_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WodTodayHoursDetailScreen extends BaseUserScreen {
  TodayWodHoursDetailBloc _bloc;
  UserModel _userModel;
  TodayHourModel _todayHourModel;

  WodTodayHoursDetailScreen(this._userModel, this._todayHourModel)
      : super(_userModel) {
    _bloc = new TodayWodHoursDetailBloc(_todayHourModel.updatedAt);
  }

  @override
  title() {
    return CustomText('WOD KATILIMCILARI',
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

              snapshot.data is ApiStartedEvent) return CustomProgressBarWave();
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            CustomText(
                              this._todayHourModel.hour,
                              color: Colors.yellow.shade800,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText('WOD')
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              this._todayHourModel.total.toString(),
                              color: Colors.yellow.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText('TOPLAM')
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              this._todayHourModel.registerUserCount.toString(),
                              color: Colors.yellow.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText('KATILIM')
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              this
                                  ._todayHourModel
                                  .remainingUserCount
                                  .toString(),
                              color: Colors.yellow.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText('KALAN')
                          ],
                        ),
                      ],
                    ),
                    isScoreEntered(snapshot)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _userModel.role == "user"
                                ?  GestureDetector(
                              onTap: ()=>addScore(context),
                              child: Image.asset('assets/images/score_save.png'),
                            )
                                : Container())
                  ],
                ),
                Padding(padding: const EdgeInsets.all(16.0)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: DataTable(
                        columns: [
                          DataColumn(label: DataTableHeaderText('AD SOYAD')),
                          DataColumn(label: DataTableHeaderText('KATILDI')),
                          DataColumn(label: DataTableHeaderText('SKORU')),
                        ],
                        rows: (snapshot.data as ApiFinishedResponseModelEvent)
                            .responseModel
                            .data
                            .map<DataRow>((item) {
                          var model = TodayHourDetailModel.fromJson(item);
                          return DataRow(
                            key: Key(model.id.toString()),
                            cells: <DataCell>[
                              DataCell(
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      model.account,
                                    )),
                              ),
                              DataCell(
                                Align(
                                    alignment: Alignment.center,
                                    child: model.isParticipated &&
                                            !model.isCancelled
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 30.0,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 30.0,
                                          )),
                                onTap: () {
                                  coachSetParticipated(model);
                                },
                              ),
                              DataCell(
                                Align(
                                    alignment: Alignment.center,
                                    child: getScore(context, model)),
                                onTap: () {},
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              ]);
        },
      ),
    );
  }

  Widget getScore(BuildContext buildContext, TodayHourDetailModel model) {
    if (model.category == null) model.category = "-";
    if (model.score == null) model.score = "-";
    return CustomText('${model.category} - ${model.score}',
        color: Colors.yellow.shade800);
  }

  bool isScoreEntered(AsyncSnapshot<ApiEvent> snapshot) {
    if (!snapshot.hasData || !(snapshot is ApiFinishedResponseModelEvent))
      return false;
    var result = ((snapshot.data as ApiFinishedResponseModelEvent)
        .responseModel
        .data as List<TodayHourDetailModel>);
    for (var i = 0; i < result.length; i++) {
      if ((result[i].category == null || result[i].category.isEmpty) &&
          this._userModel.id == result[i].accountId) {
        return false;
      }
    }
    return true;
  }

  void init(BuildContext context) {
    _bloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  void addScore(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WodTodayHoursAddScoreScreen(
            this._userModel, this._todayHourModel)));
  }

  void showResult(BuildContext context, ApiEvent event) {
    if (event is ApiFailedEvent) {
      AlertHelper.showToast(context, 'Hata Oluştu', event.message);
    }
  }

  void coachSetParticipated(TodayHourDetailModel model) {
    if (!userModel.role.contains('coach')&& !userModel.role.contains('admin')) return;
    if (!model.isCancelled && model.isParticipated) {
      _bloc.coachSetParticipated(model.id, 'cancel');
    } else {
      _bloc.coachSetParticipated(model.id, 'participated');
    }
  }
}
