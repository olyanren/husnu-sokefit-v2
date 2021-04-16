import 'package:sokefit/models/today_hour_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/size_config.dart';
import 'package:sokefit/ui/formfields/private_users_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ConfirmAction { CANCEL, ACCEPT }
class SmsConfirmationForUserResult{
  ConfirmAction confirmResult;
  UserModel user;

  SmsConfirmationForUserResult(this.confirmResult, this.user);
}
class ConfirmHelper {
  static Future<ConfirmAction> showConfirm(
      BuildContext context, String message) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.background,
          title: CustomText(message),
          actions: <Widget>[
            FlatButton(
              child: CustomText('Evet'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
            FlatButton(
              child: CustomText('İptal'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
          ],
        );
      },
    );
  }
  static Future<SmsConfirmationForUserResult> showSmsConfirmationForUser(
      BuildContext context, String message) async {
    UserModel selectedUser;
    return showDialog<SmsConfirmationForUserResult>(
      context: context,
      barrierDismissible:
      false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.background,
          title: CustomText('SMS Onayı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PrivateUsersFormField(
                selectedUser: selectedUser,
                onChanged: (item) => selectedUser = item,
              ),
              CustomText(
                message,
                color: Colors.white,
                paddingTop: 40,
                paddingBottom: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: CustomText('Evet'),
                    onPressed: () {
                      Navigator.of(context).pop(SmsConfirmationForUserResult(ConfirmAction.ACCEPT,selectedUser));
                    },
                  ),
                  FlatButton(
                    child: CustomText('Hayır'),
                    onPressed: () {
                      Navigator.of(context).pop(SmsConfirmationForUserResult(ConfirmAction.CANCEL,selectedUser));
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  static Future<SmsConfirmationForUserResult> showSmsConfirmation(
      BuildContext context, String message) async {
    UserModel selectedUser;
    return showDialog<SmsConfirmationForUserResult>(
      context: context,
      barrierDismissible:
      false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.background,
          title: CustomText('SMS Onayı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              CustomText(
                'Gidecek SMS: $message',
                color: Colors.white,
                paddingTop: 40,
                paddingBottom: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: CustomText('Evet'),
                    onPressed: () {
                      Navigator.of(context).pop(SmsConfirmationForUserResult(ConfirmAction.ACCEPT,selectedUser));
                    },
                  ),
                  FlatButton(
                    child: CustomText('Hayır'),
                    onPressed: () {
                      Navigator.of(context).pop(SmsConfirmationForUserResult(ConfirmAction.CANCEL,selectedUser));
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  static Future<ConfirmAction> showWodConfirm(
      BuildContext context, TodayHourModel todayHourModel, bool isExit) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        var division = SizeConfig.screenWidth > 600 ? 2 : 1;
        double fromBottom = 30.0 * division;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              FittedBox(
                child: Image.asset(
                  'assets/images/wod_background.png',
                  scale: 1.0 / division,
                ),
                fit: BoxFit.fill,
              ),
              Positioned(
                  bottom: fromBottom + 180,
                  child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          CustomText(
                            'Wod Saati | ',
                            fontSize: 12.0 * division,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            todayHourModel.hour,
                            fontSize: 15.0 * division,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ))),
              Positioned(
                  bottom: fromBottom + 160,
                  child: CustomText(
                    'Antrenör | '+todayHourModel.coach,
                    fontSize: 12.0 * division,
                    fontWeight: FontWeight.bold,
                  )),
              Positioned(
                  bottom: fromBottom + 120,
                  child: CustomText(
                    isExit ? 'Wod\'tan çıkmak' : 'Wod\'a katılmak',
                    fontSize: 12.0 * division,
                  )),
              Positioned(
                  bottom: fromBottom + 100,
                  child: CustomText(
                    ' istediğinize emin misiniz?',
                    fontSize: 12.0 * division,
                  )),
              Positioned(
                bottom: fromBottom+50,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: CustomText(
                          'EVET',
                          fontSize: 12.0 * division,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(ConfirmAction.ACCEPT);
                        },
                      ),
                      FlatButton(
                        child: CustomText(
                          'HAYIR',
                          color: Colors.red,
                          fontSize: 12.0 * division,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(ConfirmAction.CANCEL);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
