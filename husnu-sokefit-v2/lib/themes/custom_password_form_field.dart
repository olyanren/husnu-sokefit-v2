import 'package:crossfit/themes/size_config.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class CustomPasswordFormField extends StatelessWidget {
  TextEditingController _controller;
  String hintText;
  String emptyMessage;

  CustomPasswordFormField(this._controller, this.hintText, this.emptyMessage);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: true,
      style: new TextStyle(
          color: Colors.white, fontSize: 12 * SizeConfig.safeBlockHorizontal),
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: CustomColors.inputFillColor,
        hintStyle: new TextStyle(
            color:  CustomColors.inputHintColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        labelStyle: new TextStyle(
            color:  CustomColors.inputLabelColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputEnabledBorderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputFocusedColor),
        ),
        errorStyle: TextStyle(
          fontSize: 12.0 * SizeConfig.safeBlockHorizontal,
        ),
      ),
      validator: (value) {
        this._controller.text=value.trim();
        if (value.trim().isEmpty) {
          return this.emptyMessage;
        } else if (value.length < 8) {
          return 'Şifreniz minimum 8 karakter olmalıdır';
        }

        return null;
      },
    );
  }
}
