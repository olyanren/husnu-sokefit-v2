import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/score/score_bloc.dart';
import 'package:sokefit/blocs/score/score_event.dart';
import 'package:sokefit/blocs/user/user_bloc.dart';
import 'package:sokefit/blocs/user/user_event.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/helpers/dialog_prompt_helper.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:sokefit/ui/formfields/user_photo_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_screen.dart';

class UserInfoScreen extends BaseUserScreen {
  final UserBloc _userBloc = new UserBloc();
  final ScoreBloc _scoreBloc = new ScoreBloc();
  UserModel _userModel;

  UserInfoScreen(this._userModel) : super(_userModel);

  @override
  String title() {
    return 'Bilgilerim';
  }

  hideSubMenu() {
    return true;
  }

  @override
  Widget innerBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          defaultInfo(context),
        ],
      ),
    );
  }

  Widget defaultInfo(BuildContext context) {
    var bodyHeight =
        MediaQuery.of(context).size.height - BaseScreen.appBarHeight;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    partImage(context),
                    partSubscription(context)
                  ],
                ),
                partPhoneAndEmail(),
              ],
            ),
            SizedBox(height: bodyHeight / 2.4, child: partUserScores()),
          ],
        ),
      ),
    );
  }

  Widget partImage(BuildContext context) {
    return UserPhotoField(this._userModel.image);
  }

  Widget partSubscription(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomFlatButton(
              '??yeli??imi Dondur',
              onPressed: () => this.freezeAccount(context),
            ),
            this._userModel.datePaid == null
                ? CustomText(
                    '??deme Tarihi Yok',
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                : CustomText(
                    DateHelper.getDateAsTurkish(this._userModel.datePaid),
                    fontSize: 20,
                    color: Colors.yellow.shade600),
            CustomText('KAYIT TAR??H??'),
            CustomText(
                DateHelper.getDateAsTurkish(this._userModel.finishDate, 1),
                fontSize: 20,
                color: Colors.yellow.shade600),
            CustomText('B??T???? TAR??H??'),
            Row(
              children: <Widget>[
                CustomText(
                    this._userModel.remainingDay == null
                        ? "0"
                        : this._userModel.remainingDay.toString(),
                    fontSize: 40,
                    color: Colors.yellow.shade600),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText('KALAN'),
                      CustomText('G??N'),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget partPhoneAndEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomText(
                this._userModel.phone.substring(0, 3),
              ),
              CustomText(
                this._userModel.phone.substring(3),
              ),
            ],
          ),
          CustomText(this._userModel.email),
        ],
      ),
    );
  }

  Widget partUserScores() {
    return BlocBuilder(
      root: this,
      bloc: _scoreBloc,
      child: StreamBuilder<ApiEvent>(
          stream: _scoreBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
            if (!snapshot.hasData || !(snapshot.data is ScoreFinishedEvent))
              return CustomProgressBarWave();
            else {
              var scores = (snapshot.data as ScoreFinishedEvent).scores;
              return ListView.builder(
                  padding: EdgeInsets.only(top: 10.0, bottom: 0),
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(
                              scores[index].name,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  this.updateScore(context, scores[index].id),
                              child: CustomText(
                                scores[index].userValue.isEmpty
                                    ? "DE??ER G??R??N??Z"
                                    : scores[index].userValue,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.white,
                        )
                      ],
                    );
                  });
            }
          }),
    );
  }

  void init(BuildContext buildContext) {
    _userBloc.stream.listen((event) {
      showResult(buildContext, event);
    });
    _scoreBloc.init();
    _scoreBloc.stream.listen((event) {
      showScoreResult(buildContext, event);
    });
  }

  void showScoreResult(BuildContext context, ApiEvent event) {
    if (event is ApiFailedEvent) {
      AlertHelper.show(context, 'Hata Olu??tu', event.message);
    } else if (event is ScoreUpdateFinishedEvent) {
      _scoreBloc.refresh();
    }
  }



  void updateScore(BuildContext context, int scoreId) {
    PromptDialogHelper.show(context, 'De??er', 'De??er giriniz').then((result) {
      if (result != null && result.data != null) {
        _scoreBloc.eventSink.add(StartScoreUpdateEvent(scoreId, result.data));
      }
    });
  }

  freezeAccount(BuildContext context) {
    ConfirmHelper.showConfirm(context,
            '??yeli??inizi 1 ay s??reyle dondurmak istedi??inize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        _userBloc.freezeAccount();
      }
    });
  }
}
