import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showSuccessMessage(String message) {
    _show(message, true);
  }

  static void _show(String message, bool isSuccess) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 4,
        backgroundColor: isSuccess ? Colors.lightGreen : Colors.red,
        textColor: Colors.white);
  }

  static void showErrorMessage(String message) {
    _show(message, false);
  }
}
