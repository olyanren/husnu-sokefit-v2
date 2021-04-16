import 'package:package_info/package_info.dart';
import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/pt/private_admin_private_register_bloc.dart';
import 'package:sokefit/blocs/pt/private_coach_bloc.dart';
import 'package:sokefit/blocs/pt/private_score_bloc.dart';
import 'package:sokefit/blocs/user/notification_bloc.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/helpers/dialog_prompt_helper.dart';
import 'package:sokefit/models/pt/private_admin_private_register_pagination_model.dart';
import 'package:sokefit/models/pt/pt_admin_private_register_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_pagination.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:sokefit/ui/pt/admin/pt_admin_purchased_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base_screen.dart';

class PrivateAdminPrivateRegisterScreen extends BaseUserScreen {
  final PrivateCoachBloc _userBloc = new PrivateCoachBloc();
  final PrivateScoreBloc _scoreBloc = new PrivateScoreBloc();
  final NotificationBloc _notificationBloc = new NotificationBloc();
  UserModel _userModel;
  final PrivateAdminPrivateRegisterBloc _bloc =
      new PrivateAdminPrivateRegisterBloc();
  TextEditingController _queryController = new TextEditingController();

  PrivateAdminPrivateRegisterScreen(this._userModel) : super(_userModel);

  @override
  String title() {
    return null;
  }

  hideSubMenu() {
    return true;
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _userBloc,
      child: StreamBuilder<ApiEvent>(
          stream: _userBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
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
                StreamBuilder<ApiEvent>(
                    stream: _bloc.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          !(snapshot.data is PaginationEvent))
                        return CustomProgressBarWave();

                      var paginationModel =
                          (snapshot.data as PaginationEvent).paginationModel;

                      return Column(
                        children: <Widget>[
                          filter(context),
                          SizedBox(
                            height: bodyHeight / 2.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: new CustomPagination<
                                          PrivateAdminPrivateRegisterPaginationModel>(
                                      key: UniqueKey(),
                                      bloc: _bloc,
                                      header: getHeader(),
                                      builder: (item) =>
                                          this.rowBuild(context, item),
                                      items: paginationModel.data.data),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget filter(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: CustomTextFormField(
                        _queryController,
                        'Üye Adını Giriniz',
                        null,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomFlatButton(
                        'Sorgula',
                        onPressed: () => search(context),
                        paddingLeft: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void init(BuildContext context) {
    _bloc.search("", 1, 30);
    _bloc.stream.listen((event) {
      showResult(context, event);
    });

    _scoreBloc.stream.listen((event) {
      if (event is ApiSuccessEvent) {
      } else {
        showResult(context, event);
      }
    });
    _notificationBloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  Widget rowBuild(BuildContext context, PrivateAdminPrivateRegisterModel item) {
    return Column(
      children: <Widget>[
        Divider(thickness: 1, color: Colors.white60),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: CustomText(
              item.account,
              textAlign: TextAlign.center,
              color: CustomColors.turquoise,
              onClick: () => goToDetail(context, item),
                  fontSize: 10,
            )),
            Expanded(
                child: CustomText(
              item.totalDays.toString(),
              textAlign: TextAlign.center,
                  fontSize: 10,
            )),
            Expanded(
                child: CustomText(
              (item.totalDays - item.availableDays).toString(),
              textAlign: TextAlign.center,
                  fontSize: 10,
            )),
            Expanded(
              child: Column(
                children: <Widget>[
                  (item.totalDays - item.availableDays) <= 5
                      ? CustomText(
                          'SMS',
                          color: Colors.red,
                          textAlign: TextAlign.center,
                          onClick: () => sendSMS(context, item),
                    fontSize: 10,
                        )
                      : CustomText(''),
                  CustomText(
                    'Kısa Not',
                    color: Colors.red,
                    textAlign: TextAlign.center,
                    onClick: () => sendMessage(context, item),
                    fontSize: 10,
                  ),
                  CustomText(
                    'Boşalan Ders',
                    color: Colors.red,
                    textAlign: TextAlign.center,
                    onClick: () => sendAvailableCourse(context, item),
                    fontSize: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: CustomText(
            'ÜYE',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'ALINAN DERS',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'KALAN DERS',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'İŞLEM',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  search(BuildContext context) {
    _bloc.search(_queryController.text, 1, 30);
  }

  sendSMS(BuildContext context, PrivateAdminPrivateRegisterModel item) {
    ConfirmHelper.showConfirm(
            context, 'Sms göndermek istediğinize emin misiniz?')
        .then((result) {
      if (result == ConfirmAction.ACCEPT) {
        _notificationBloc.sendSms(
            item.id.toString(),
            'Sayın ${item.account}, PT dersinizden '
            '${item.totalDays - item.availableDays} gün kalmıştır, '
            'ders yenilemenizi APP ve Box\'tan yapabilirsiniz');
      }
    });
  }

  sendMessage(BuildContext context, PrivateAdminPrivateRegisterModel item) {
    ConfirmHelper.showConfirm(
            context, 'Sms göndermek istediğinize emin misiniz?')
        .then((result) {
      if (result == ConfirmAction.ACCEPT) {
        PromptDialogHelper.show(context, 'İçerik', 'Mesajınızı buraya yazınız')
            .then((result) {
          if (result != null && result.data != null) {
            _notificationBloc.sendSms(
                item.id.toString(), 'Sayın ${item.account}, ${result.data}');
          }
        });
      }
    });
  }

  sendAvailableCourse(
      BuildContext context, PrivateAdminPrivateRegisterModel item) {
    ConfirmHelper.showConfirm(
            context, 'Sms göndermek istediğinize emin misiniz?')
        .then((result) {
      if (result == ConfirmAction.ACCEPT) {
        PromptDialogHelper.show(
                context, 'İçerik', 'Boş olan saat ve ders bilgisini yazınız')
            .then((result) {
          if (result != null && result.data != null) {
            PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
              String appName = packageInfo.appName;
              String packageName = packageInfo.packageName;
              String version = packageInfo.version;
              String buildNumber = packageInfo.buildNumber;
              _notificationBloc.sendSms(
                  item.id.toString(),
                  'Sayın ${item.account}, ${result.data} müsaittir. '
                  'Randevu alabilirsiniz. '
                  'Android: https://play.google.com/store/apps/details?id=$packageName,'
                      ' IOS: https://apps.apple.com/us/app/crossfit-backstreet/id1508289944');
            });
          }
        });
      }
    });
  }

  goToDetail(BuildContext context, PrivateAdminPrivateRegisterModel item) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            PrivateAdminPurchasedItemsScreen(userModel, item.id)));
  }
}
