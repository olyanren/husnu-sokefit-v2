import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingHelper {
  static Future<String> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,

      builder:(_) => new Dialog(
        backgroundColor: CustomColors.background,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.00),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: new CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white))),
                flex: 1,
              ),
              new Flexible(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new CustomText("Yükleniyor....")),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}
