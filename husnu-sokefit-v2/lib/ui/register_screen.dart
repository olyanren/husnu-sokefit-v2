import 'package:crossfit/blocs/counter_bloc_rxdart.dart';
import 'package:crossfit/blocs/location/location_bloc.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/base_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forms/register_form.dart';
import 'login_screen.dart';

class RegisterScreen extends BaseScreen {

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
                  color: Colors.yellow, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  @override
  innerBody(BuildContext context) {
    return RegisterForm();
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
