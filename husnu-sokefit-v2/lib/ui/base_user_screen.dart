import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/base_screen.dart';
import 'package:sokefit/ui/payment_screen.dart';
import 'package:sokefit/ui/user_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/custom_text.dart';
import 'login_screen.dart';

abstract class BaseUserScreen extends BaseScreen {
  final UserModel userModel;

  bool hideSubMenu() {
    return false;
  }

  BaseUserScreen(this.userModel);

  Widget appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(
        color: Colors.red, //change your color here
      ),
      actions: [
        enableUserAccountNavigation() == true
            ? GestureDetector(
                onTap: () => goToUserInfoScreen(context),
                child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, right: 8),
                    child: CustomText('Bilgilerim',
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              )
            : Container(),
        GestureDetector(
          onTap: () => goToLogin(context),
          child: Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 8),
              child: CustomText('Çıkış Yap',
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        )
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: BaseScreen.appBarHeight + 20),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/login-logo.gif',
                        height: 70,
                      )),
                  title() is CustomText
                      ? title()
                      : Column(
                          children: <Widget>[
                            CustomText(this.userModel.name,
                                fontSize: 20,
                                color: CustomColors.titleColor,
                                fontWeight: FontWeight.bold),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  userModel.joinedCount == null ||
                                          userModel.joinedCount == 0
                                      ? Container()
                                      : CustomText(
                                          '${userModel.joinedCount} Katılım',
                                          color: Colors.redAccent,
                                          fontSize: 20,
                                        ),
                                  CustomText(
                                      DateHelper.currentDate('dd/MM/yyyy'))
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
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
                                          color: Colors.yellow),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomText(
                                          ' ${Constants.LOCATION_NAME}',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.yellow),
                                    ),
                                    this.userModel.remainingDay <= 15
                                        ? CustomFlatButton('Üyelik Yenile',
                                            color: CustomColors.button,
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => UserInfoScreen(this.userModel)));
  }

  void goToLogin(BuildContext context) {
    Constants.ACCESS_TOKEN = '';
    Constants.USER_ROLES = '';
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

  Widget build(BuildContext context) {
    if (userModel.role.contains("admin")) {
      return Stack(
        children: <Widget>[
          new Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
              backgroundColor: Colors.transparent,
              //klavye acildiginda pixel overflow olmasini engelliyor.
              //fakat keyboard acildiginde scroll olmuyor. Bundan dolayi
              //register sayfasinda scrolling yapildi
              resizeToAvoidBottomPadding: resizeToAvoidBottomPadding(),
              extendBodyBehindAppBar: true,
              appBar: appbar(context),
              body: body(context))
        ],
      );
    } else {
      return super.build(context);
    }
  }
}
