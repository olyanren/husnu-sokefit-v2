
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/base_screen.dart';
import 'package:sokefit/ui/pt/pt_register_screen.dart';
import 'package:sokefit/ui/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forms/login_form.dart';

class LoginScreen extends BaseScreen {
  @override
  String title() {
    // TODO: implement title
    return null;
  }
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/background_login.jpg"),
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

            appBar: appbar(context),
            body: body(context))
      ],
    );
  }
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:30),
      child: Container(
        color: Colors.transparent,
        child: innerBody(context),
      ),
    );
  }
  Widget appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [

        GestureDetector(
          onTap: () => goToRegister(context),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                'Yeni Üyelik',
                color: CustomColors.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => goToPtRegister(context),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                'Yeni Private Üyelik',
                color: CustomColors.remainingDay,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  innerBody(BuildContext context) {
    return LoginForm();
  }

  void goToRegister(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }
  void goToPtRegister(BuildContext context){
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => PtRegisterScreen()));
  }

  @override
  void init(BuildContext context) {
    // TODO: implement init
  }


}
