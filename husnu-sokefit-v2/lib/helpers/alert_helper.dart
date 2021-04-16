import 'package:sokefit/helpers/toast_helper.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../themes/size_config.dart';

class AlertHelper {
  // user defined function
  static void show(BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: CustomColors.background,
          title: Column(
            children: <Widget>[
              title.toLowerCase().contains("hata")
                  ? Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 100,
                    )
                  : Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
            ],
          ),
          content: title.toLowerCase().contains("hata")
              ? CustomText(title + ": " + message)
              : CustomText(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new CustomText("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showPaymentResult(
      BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            children: <Widget>[
              title.toLowerCase().contains("hata")
                  ? Image.asset(
                      'assets/images/payment-fail.png',
                    )
                  : Image.asset(
                      'assets/images/payment-success.png',
                    ),
              new FlatButton(
                child: new CustomText(
                  "KAPAT",
                  fontWeight: FontWeight.bold,
                  color: CustomColors.titleColor,
                  fontSize: 15,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void showToast(BuildContext context, String title, String message) {
    if (title == null) return;
    if (title.toLowerCase().contains("hata"))
      ToastHelper.showErrorMessage(message);
    else
      ToastHelper.showSuccessMessage(message);
  }

  static Future<bool> showWithResult(
      BuildContext context, String title, String message) async {
    // flutter defined function
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: CustomColors.background,
          title: title.toLowerCase().contains("hata")
              ? Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 100,
                )
              : Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
          content: new CustomText(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new CustomText("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showHtml(BuildContext context, String title, String html,
      {Color color}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: CustomColors.background,
          title: new CustomText(title),
          content: Container(
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Html(
                    data: html,
                    style: {
                      "p": Style(
                          color: color,
                          fontSize:
                              FontSize(10 * SizeConfig.safeBlockHorizontal)),
                      "div": Style(
                          color: color,
                          fontSize:
                              FontSize(10 * SizeConfig.safeBlockHorizontal)),
                      "ul": Style(
                          color: color,
                          fontSize:
                              FontSize(10 * SizeConfig.safeBlockHorizontal)),
                      "li": Style(
                          color: color,
                          fontSize:
                              FontSize(10 * SizeConfig.safeBlockHorizontal)),
                    },
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new CustomText("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
