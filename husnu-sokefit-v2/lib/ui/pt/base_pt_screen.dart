import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/date_helper.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/base_screen.dart';
import 'package:crossfit/ui/payment_screen.dart';
import 'package:crossfit/ui/pt/admin/pt_admin_coach_info_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_info_screen.dart';
import 'package:crossfit/ui/pt/pt_user_info_screen.dart';
import 'package:crossfit/ui/user_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';

abstract class BasePrivateScreen extends BaseScreen {
  final UserModel userModel;

  bool hideSubMenu() {
    return false;
  }

  BasePrivateScreen(this.userModel);

  Widget appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: Colors.red, //change your color here
      ),
      title: title() is String
          ? CustomText(
              title(),
              color: CustomColors.turquoise,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              paddingTop: 0,
            )
          : CustomText(''),
      actions: [
        enableUserAccountNavigation() == true
            ? GestureDetector(
                onTap: () => goToUserInfoScreen(context),
                child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, right: 8),
                    child: CustomText('Bilgilerim',
                        color: CustomColors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              )
            : Container(),
        GestureDetector(
          onTap: () => goToLogin(context),
          child: Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 8),
              child: CustomText('Çıkış Yap',
                  color: CustomColors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        )
      ],
    );
  }
   AssetImage backgroundImage() => new AssetImage("assets/images/background.jpg");
  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: BaseScreen.appBarHeight + 20),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              title() is CustomText || title() is String
                  ? (title() is String ? CustomText("") : title())
                  : Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset('assets/images/login-logo.gif',height: 70,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              CustomText(this.userModel.name,
                                  fontSize: 15,
                                  color: CustomColors.orange,
                                  fontWeight: FontWeight.bold),
                              Row(
                                children: [
                                  CustomText(
                                    Constants.LOCATION_NAME??'',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    paddingRight: 10,
                                  ),
                                  CustomText(
                                    DateHelper.currentDateAsTurkish(),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                  ),
              hideSubMenu()
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        this.userModel.role != 'user'
                            ? Container()
                            : Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomText(
                                          'Kalan Gün: ${this.userModel.remainingDay}',
                                          fontWeight: FontWeight.normal,
                                          color: CustomColors.orange),
                                    ),
                                    this.userModel.remainingDay <= 15
                                        ? CustomFlatButton('Üyelik Yenile',
                                            onPressed: () =>
                                                goToPaymentScreen(context))
                                        : Container(),
                                  ],
                                ),
                              ),
                      ],
                    ),
              Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ],
          ),
          Expanded(child: innerBody(context))
        ],
      ),
    );
  }

  void goToUserInfoScreen(BuildContext context) {
    BaseScreen screen = PrivateUserInfoScreen(this.userModel);
    if (userModel.role.contains('pt_coach'))
      screen = PrivateCoachInfoScreen(userModel);
    if (userModel.role.contains('pt_admin'))
      screen = PrivateAdminCoachInfoScreen(userModel);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => screen));
  }

  void goToLogin(BuildContext context) {
    Constants.ACCESS_TOKEN = '';
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  void goToPaymentScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PaymentScreen(this.userModel)));
  }

  bool enableUserAccountNavigation() {
    return false;
  }
}
