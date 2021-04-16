import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/base_screen.dart';
import 'package:sokefit/ui/login_screen.dart';

import 'package:sokefit/ui/pt/pt_register_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PtRegisterScreen extends BaseScreen {

  @override
  String title() {
    // TODO: implement title
    return null;
  }

  Widget appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        GestureDetector(
          onTap: () => goToLogin(context),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText('Giriş Yap',
                  color: CustomColors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  @override
  innerBody(BuildContext context) {
    return PtRegisterForm();
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  void init(BuildContext context) {
    // TODO: implement init
  }
}
