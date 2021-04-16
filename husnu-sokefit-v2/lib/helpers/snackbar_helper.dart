import 'package:sokefit/themes/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarHelper {
  static BuildContext _buildContext;

  static void show(BuildContext context, String message,
      [int dismissSecond = 20]) {
    _buildContext = context;
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: dismissSecond),
        backgroundColor: Colors.amber,
        content: CustomText(
          message,
          fontSize: 12,
          color: Colors.black,
        )));
  }

  static void hide() {
    try {
      if (_buildContext != null) Scaffold.of(_buildContext).hideCurrentSnackBar();
    } catch (e) {

    }
  }
}
