import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/size_config.dart';
import 'package:flutter/material.dart';

class CustomPasswordConfirmFormField extends StatelessWidget {
  String hintText;
  String value;
  String emptyMessage;
  TextEditingController _firstPasswordController;
  String _matchFailedMessage;
  TextEditingController _controller;

  CustomPasswordConfirmFormField(
      this._controller,
      this._firstPasswordController,
      this.hintText,
      this.emptyMessage,
      this._matchFailedMessage);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: true,
      style: new TextStyle(
          color:CustomColors.inputTextColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: CustomColors.inputFillColor,
        hintStyle: new TextStyle(
            color: CustomColors.inputHintColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        labelStyle: new TextStyle(
            color: CustomColors.inputLabelColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputEnabledBorderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputFocusedColor),
        ),
        errorStyle: TextStyle(
            fontSize: 12.0 * SizeConfig.safeBlockHorizontal,
            color: Colors.red),
      ),
      validator: (value) {
        this._controller.text = value.trim();
        if (value.trim().isEmpty) {
          return this.emptyMessage;
        }
        if (value != this._firstPasswordController.text) {
          return this._matchFailedMessage;
        }

        return null;
      },
    );
  }
}
