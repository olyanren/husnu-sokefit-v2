import 'dart:math';

import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/pt/private_score_bloc.dart';
import 'package:crossfit/blocs/pt/private_user_bloc.dart';
import 'package:crossfit/blocs/pt/private_user_event.dart';
import 'package:crossfit/blocs/user/user_photo_bloc.dart';
import 'package:crossfit/helpers/dialog_prompt_helper.dart';
import 'package:crossfit/helpers/string_helper.dart';
import 'package:crossfit/models/pt/private_score_model.dart';
import 'package:crossfit/models/pt/private_user_summary_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/size_config.dart';
import 'package:crossfit/ui/pt/pt_renew_account_screen.dart';
import '../../themes/colors.dart';
import '../../themes/custom_flat_button.dart';
import '../../themes/custom_text.dart';
import '../payment_screen.dart';
import 'base_pt_screen.dart';

import 'package:crossfit/themes/custom_progress_bar.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:crossfit/ui/formfields/user_photo_field.dart';
import 'package:crossfit/ui/pt/pt_purchased_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_screen.dart';
import 'private_send_notification_to_coach_screen.dart';
import 'private_send_sms_to_coach_screen.dart';
import 'pt_course_list_screen.dart';

class PrivateUserInfoScreen extends BasePrivateScreen {
  final PrivateUserBloc _userBloc = new PrivateUserBloc();
  final UserPhotoBloc _userPhotoBloc = new UserPhotoBloc();
  final PrivateScoreBloc _scoreBloc = new PrivateScoreBloc();
  UserModel _userModel;
  PrivateUserSummaryModel _summaryModel;

  PrivateUserInfoScreen(this._userModel) : super(_userModel);

  @override
  String title() {
    return 'Bilgilerim';
  }

  hideSubMenu() {
    return false;
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _userBloc,
      child: StreamBuilder<ApiEvent>(
          stream: _userBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
            if (!snapshot.hasData ||
                !(snapshot.data is PrivateUserSummaryFinishedEvent))
              return CustomProgressBar();

            _summaryModel =
                (snapshot.data as PrivateUserSummaryFinishedEvent).summaryModel;

            return SingleChildScrollView(
              child: defaultInfo(context),
            );
          }),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.screenWidth / 3 * 1 - 8,
                      child: Column(
                        children: <Widget>[
                          partImage(context),
                          CustomText(
                            'Eski Alımlarım',
                            color: Colors.green,
                            paddingTop: 10,
                            paddingBottom: 10,
                            onClick: () => goToOldPurchases(context),
                          ),
                          CustomText(
                            'Geçmiş Derslerim',
                            color: Colors.green,
                            paddingTop: 10,
                            paddingBottom: 10,
                            onClick: () => goToOldCourses(context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => goToNotification(context),
                                child: Image.asset(
                                  'assets/images/notification.png',
                                  width: 40,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => goToSendSms(context),
                                child: Image.asset(
                                  'assets/images/sms-alert-icon.png',
                                  width: 35,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                        width: SizeConfig.screenWidth / 3 * 2 - 8,
                        child: summary(context)),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                middle(context),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
                height: bodyHeight / 2.4,
                child: footer(context, _summaryModel.scores)),
          ],
        ),
      ),
    );
  }

  Widget partImage(BuildContext context) {
    return UserPhotoField(_userModel.image);
  }

  Widget summary(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          children: [
            TableRow(children: [
              CustomText('KAYIT TARİHİ'),
              CustomText(
                _summaryModel.registerDate,
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
            TableRow(children: [
              CustomText('SON ALINAN DERS'),
              CustomText(
                '${_summaryModel.lastDayCount} DERS',
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
            TableRow(children: [
              CustomText('ANTRENÖR'),
              CustomText(
                _summaryModel.coach,
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
            TableRow(children: [
              CustomText('TOPLAM DERS'),
              CustomText(
                _summaryModel.totalDays.toString(),
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
            TableRow(children: [
              CustomText('KALAN DERS'),
              CustomText(
                _summaryModel.remainingDayCount.toString(),
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
            TableRow(children: [
              CustomText('İPTAL DERS'),
              CustomText(
                _summaryModel.cancelledDayCount.toString(),
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
            TableRow(children: [
              CustomText('GELİNMEYEN DERS'),
              CustomText(
                _summaryModel.absentDayCount.toString(),
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
            TableRow(children: [
              CustomText('YAPILAN DERS'),
              CustomText(
                _summaryModel.availableDayCount.toString(),
                color: CustomColors.orange,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              )
            ]),
          ],
        ));
  }

  Widget middle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: middleLeft(context)),
        middleRight(context)
      ],
    );
  }

  Widget middleLeft(BuildContext context) {
    var oldKgString = _summaryModel.scores
        .firstWhere((element) => element.name == 'Başlama Kilosu')
        .newValue;
    var currentKgString = _summaryModel.scores
        .firstWhere((element) => element.name == 'Şuanki Kilosu')
        .newValue;

    double oldKg = double.parse(oldKgString ?? '0');
    double currentKg = double.parse(currentKgString ?? '0');

    var height = _summaryModel.scores
        .firstWhere((element) => element.name == 'Boy')
        .newValue;
    var bmiString = height == null || height == '' || height == '0'
        ? ''
        : currentKg / pow(double.parse(height) / 100, 2);
    var bmiType = 'Zayıf';

    double bmi = 0;
    if (bmiString is String)
      bmi = double.parse(bmiString == '' ? '0' : bmiString);
    else
      bmi = bmiString;
    if (bmiString == '')
      bmiType = 'Zayıf';
    else if (bmi >= 0 && bmi < 18.5)
      bmiType = 'Zayıf';
    else if (bmi >= 18.5 && bmi < 25.00)
      bmiType = 'Normal';
    else if (bmi >= 25.00 && bmi < 30.00)
      bmiType = 'Kilolu';
    else if (bmi >= 30.00 && bmi < 35.00)
      bmiType = 'Şişman';
    else if (bmi >= 35 && bmi < 45.00)
      bmiType = 'Obez';
    else if (bmi >= 45) bmiType = 'Aşırı Obez';

    return Column(
      children: <Widget>[
        Table(
          children: [
            TableRow(children: [
              CustomText('BMI $bmiType'),
              CustomText(bmi.toStringAsFixed(2))
            ])
          ],
        ),
        Table(
          children: _summaryModel.scores
              .where((element) => element.type == 'middle')
              .map((e) {
            return TableRow(children: [
              CustomText(e.name),
              CustomText(
                e.newValue ?? "Yeni Değer",
                underline: true,
                onClick: () => this.updateScore(context, e),
              )
            ]);
          }).toList(),
        ),
        Table(
          children: [
            TableRow(children: [
              CustomText('Kilo Farkı'),
              CustomText((currentKg - oldKg).toString())
            ])
          ],
        ),
      ],
    );
  }

  Widget middleRight(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _summaryModel.totalPaidPrice == 0
            ? Column(
                children: <Widget>[
                  CustomText(
                    'ÖDEME DURUMU',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  CustomText(
                    'Yapılmadı',
                    color: Colors.red.shade800,
                    fontSize: 20,
                  ),
                  CustomFlatButton('Ödeme Yap',
                      onPressed: () =>
                          goToPaymentScreen(context))
                ],
              )
            : Column(
                children: <Widget>[
                  CustomText('Son Ödeme'),
                  _summaryModel.latestPaidPrice == 0
                      ? CustomText(
                          'Yapılmadı',
                          color: Colors.red.shade800,
                          fontSize: 20,
                        )
                      : CustomText(
                          _summaryModel.latestPaidPrice.toString() + " TL",
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  CustomText('Toplam Ödeme'),
                  CustomText(
                    _summaryModel.totalPaidPrice.toString() + " TL",
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )
                ],
              )
      ],
    );
  }

  Widget footer(BuildContext context, List<PrivateScoreModel> scoreModels) {
    return Column(
      children: <Widget>[
        Table(
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(2),
          },
          children: [
            TableRow(children: [
              CustomText(''),
              CustomText(
                'İlk Veri',
                color: CustomColors.orange,
              ),
              CustomText(
                'Fark',
                color: CustomColors.orange,
              ),
              CustomText(
                'Şuanki Veri',
                color: CustomColors.orange,
              )
            ])
          ],
        ),
        Expanded(
          child: Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(2),
            },
            children: _summaryModel.scores
                .where((element) => element.type == 'footer')
                .map((e) {
              double newValue = StringHelper.isNumeric(e.newValue)
                  ? double.parse(e.newValue)
                  : 0;
              double oldValue = StringHelper.isNumeric(e.oldValue)
                  ? double.parse(e.oldValue)
                  : 0;
              var difference = 0.0;
              if (oldValue == 0) {
                difference = newValue == null ? 0 : newValue;
              } else {
                difference = newValue - oldValue;
              }
              return TableRow(children: [
                CustomText(e.name),
                oldValue == 0
                    ? CustomText(
                        oldValue.toString(),
                        underline: true,
                        onClick: () => updateScore(context, e),
                      )
                    : CustomText(oldValue.toString()),
                CustomText(difference.toString(), color: Colors.red.shade800),
                CustomText(
                  newValue.toString(),
                  underline: true,
                  onClick: () => updateScore(context, e),
                )
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  void init(BuildContext context) {
    _userBloc.summary();
    _userBloc.stream.listen((event) {
      showResult(context, event);
    });
    _scoreBloc.stream.listen((event) {
      if (event is ApiSuccessEvent) {
        _userBloc.summary();
      } else {
        showResult(context, event);
      }
    });
  }

  void updateScore(BuildContext context, PrivateScoreModel score) {
    PromptDialogHelper.show(context, 'Değer', 'Değer giriniz').then((result) {
      if (result != null && result.data != null) {
        _scoreBloc.updateScore(score.id, result.data);
      }
    });
  }

  goToOldPurchases(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            PrivatePurchasedItemsScreen(userModel)));
  }

  goToOldCourses(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PrivateCourseListScreen(userModel)));
  }

  goToSendSms(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            PrivateSendSmsToCoachScreen(userModel)));
  }

  goToNotification(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            PrivateSendNotificationToCoachScreen(userModel)));
  }

  void goToPaymentScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PrivateRenewAccountScreen(this.userModel)));
  }
}