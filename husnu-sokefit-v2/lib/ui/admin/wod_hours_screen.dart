import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/wods/wod_hour_bloc.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/helpers/snackbar_helper.dart';
import 'package:crossfit/models/today_hour_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/models/wod_hour_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/my_web_view.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:crossfit/ui/wod_today_hours_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WodHoursScreen extends BaseUserScreen {
  final WodHourBloc _bloc = new WodHourBloc();
  final UserModel _userModel;

  WodHoursScreen(this._userModel) : super(_userModel);

  @override
  title() {
    return CustomText('WOD SAATLERİ',
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
              !(snapshot.data is ApiFinishedResponseModelEvent))
            return CustomProgressBarWave();
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                getHeaderButtons(context),
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            (snapshot.data as ApiFinishedResponseModelEvent)
                                .responseModel
                                .data
                                .map<Widget>((item) {
                          var model = WodHourModel.fromJson(item);
                          return SizedBox(
                            width: 300,
                            child: CustomText(model.day,
                                padding: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow.shade800),
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            (snapshot.data as ApiFinishedResponseModelEvent)
                                .responseModel
                                .data
                                .map<Widget>((item) {
                          var model = WodHourModel.fromJson(item);

                          return SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: model.hourCoaches.map<Widget>((item) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      CustomText(
                                        item.hour,
                                        color: getModelColor(model),
                                        paddingLeft: 5,
                                      ),
                                      CustomText(
                                        item.coach,
                                        color: getModelColor(model),
                                        paddingLeft: 15,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ))
              ]);
        },
      ),
    );
  }

  Widget getHeaderButtons(BuildContext context) {
    if (!Constants.USER_ROLES.contains("admin")) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomFlatButton(
          'WOD SAATLERİ EKLE',
          onPressed: () => this.goToAdminPanelForWodHours(context),
          padding: 8,
        ),
        Expanded(
          child: CustomFlatButton(
            'TÜMÜNÜ SİL',
            onPressed: () => this.removeAllWodHours(context),
            padding: 8,
          ),
        ),
      ],
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.white),
    );
  }

  void goToTodayWodDetailScreen(BuildContext context, UserModel userModel,
      TodayHourModel todayHourModel) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            WodTodayHoursDetailScreen(userModel, todayHourModel)));
  }

  void init(BuildContext context) {
    _bloc.stream.listen((event) {
      showResult(context, event);
      if (event is WodHourDeleteFailedEvent ||
          event is WodHourDeleteFinishedEvent) {
        _bloc.init();
      }
    });
  }

  getModelColor(WodHourModel model) {
    if (model.day == 'Salı' || model.day == 'Cumartesi')
      return Colors.yellow.shade600;
    if (model.day == 'Perşembe' || model.day == 'Pazar')
      return CustomColors.titleColor;
  }

  removeAllWodHours(BuildContext context) {
    ConfirmHelper.showConfirm(
            context, 'Tümünü silmek istediğinize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        SnackBarHelper.show(context, 'Tüm wod saatleri siliniyor');
        _bloc.event.add(WodHourDeleteEvent());
      }
    });
  }

  goToAdminPanelForWodHours(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyWebView(
              title: 'Wod Ekleme',
              url: ApiHelper.BASE_PATH +
                  ApiHelper.API_PATH +
                  '/wods/create-for-web',
            )));
  }
}
