import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/wods/today_wod_bloc.dart';
import 'package:crossfit/blocs/wods/wod_event.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/models/today_hour_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/models/wod_model.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/size_config.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:crossfit/ui/wod_list_screen.dart';
import 'package:crossfit/ui/wod_today_hours_summary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../themes/colors.dart';
import 'admin/wod_hours_screen.dart';
import 'admin/wod_today_create_screen.dart';

class WodTodayScreen extends BaseUserScreen {
  TodayWodBloc _bloc = new TodayWodBloc();
  WodModel _wodModel;

  WodTodayScreen(UserModel userModel, [WodModel wodModel]) : super(userModel) {
    _wodModel = wodModel;
  }

  bool enableUserAccountNavigation() {
    return true;
  }

  @override
  title() {
    return CustomText('GÜNÜN WOD BİLGİSİ',
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
          if (!snapshot.hasData) return Container();

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Html(
                        data: snapshot.data is ApiWodDetailSuccess
                            ? ((snapshot.data as ApiWodDetailSuccess).content)
                            : snapshot.data.message ?? '',
                        style: {
                          "p": Style(
                              color: Color.fromARGB(255, 46, 213, 115),
                              fontSize: FontSize(
                                  12 * SizeConfig.safeBlockHorizontal)),
                        },
                      )),
                ),
              ),
              snapshot.data is ApiWodDetailSuccess
                  ? Container()
                  : snapshot.data is ApiFinishedEvent
                      ? (userModel.role == 'user'
                          ? GestureDetector(
                              onTap: () => goToTodayWodScreen(context),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Image.asset('assets/images/join.png'),
                              ))
                          : Column(
                              children: <Widget>[
                                CustomFlatButton(
                                  'KATILIMCILAR',
                                  onPressed: () => goToTodayWodScreen(context),
                                  padding: 8,
                                ),
                                getFooterButtons(context),
                              ],
                            ))
                      : Container(),
              snapshot.data is ApiWodDetailSuccess
                  ? Container()
                  : (userModel.role == 'user'
                      ? CustomFlatButton(
                          'TÜM WODLAR',
                          onPressed: () => goToAllWods(context),
                          padding: 8,
                          backgroundColor: CustomColors.button,
                        )
                      : Container())
            ],
          );
        },
      ),
    );
  }

  Widget getFooterButtons(BuildContext context) {
    if (Constants.USER_ROLES.contains("admin")) {
      return CustomFlatButton(
        'GÜNLÜK WOD EKLE',
        onPressed: () => createWod(context),
        padding: 8,
      );
    } else if (Constants.USER_ROLES.contains("coach")) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomFlatButton(
            'ANTRENÖR PROGRAMI',
            onPressed: () => goToWeeklySchedules(context),
            backgroundColor: CustomColors.button,
            color: Colors.white,
            padding: 8,
          ),
          Expanded(
            child: CustomFlatButton(
              'TÜM WODLAR',
              onPressed: () => goToAllWods(context),
              color: Colors.white,
              backgroundColor: CustomColors.button,
              padding: 8,

            ),
          )
        ],
      );
    }
    return Container();
  }

  void goToTodayWodScreen(BuildContext context) {
    if (userModel.role == 'user' && this.userModel.remainingDay <= 0) {
      AlertHelper.showToast(context, 'Hata Oluştu',
          'Wod\'a katılmak için üyeliğinizi yenilemeniz gerekmektedir.');
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              WodTodayHoursSummaryScreen(userModel)));
    }
  }

  void goToAllWods(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WodListScreen(userModel)));
  }

  void goToWeeklySchedules(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WodHoursScreen(userModel)));
  }

  void createWod(BuildContext context) {
    if (userModel.role == 'user' && this.userModel.remainingDay <= 0) {
      AlertHelper.showToast(context, 'Hata Oluştu',
          'Wod\'a katılmak için üyeliğinizi yenilemeniz gerekmektedir.');
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => WodTodayCreateScreen(userModel)));
    }
  }

  @override
  init(BuildContext buildContext) {
    if (_wodModel == null)
      _bloc.event.add(new ApiStartedEvent());
    else
      _bloc.initWodDetailEvent(_wodModel.id);
  }
}
