
import 'package:crossfit/themes/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController _controller;
  String hintText;
  String emptyMessage;
  TextInputType keyboardType = TextInputType.text;
  int multiline = 1;
  double paddingLeft;
  double paddingTop;
  double paddingRight;
  double paddingBottom;
  double width;
  bool autoFocus;
  Color textColor;
  Color labelColor;
  Color errorColor;
  Color hintColor;
  FocusNode focusNode;
  int maxCharacter;
  Widget leftIcon;
  Widget rightIcon;
  bool fullBorder;
  double borderRadius;
  bool disabled;
  CustomTextFormField(this._controller, this.hintText, this.emptyMessage,
      {this.keyboardType = TextInputType.text,
        this.multiline,
        this.paddingLeft = 0,
        this.paddingTop = 0,
        this.paddingRight = 0,
        this.paddingBottom = 0,
        this.width = 0,
        this.autoFocus = false,
        this.textColor,
        this.labelColor,
        this.errorColor,
        this.hintColor,
        this.focusNode,
        this.maxCharacter,
        this.fullBorder = false,
        this.leftIcon,
        this.rightIcon,
        this.borderRadius=8,
        this.disabled=false});

  @override
  Widget build(BuildContext context) {
    return this.width == 0
        ? _innerBuild()
        : Container(
      width: this.width,
      child: _innerBuild(),
    );
  }

  Widget _innerBuild() {
    return Padding(
        padding: EdgeInsets.only(
            left: paddingLeft,
            top: paddingTop,
            right: paddingRight,
            bottom: paddingBottom),
        child: getTextFormField());
  }

  TextFormField getTextFormField() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(this.maxCharacter ?? 10000),
      ],
      focusNode: disabled?new AlwaysDisabledFocusNode():this.focusNode,
      enableInteractiveSelection: disabled,
      maxLines: this.multiline,
      controller: _controller,
      keyboardType: keyboardType,
      autofocus: this.autoFocus,

      style: new TextStyle(
          color: this.textColor ?? Colors.white,
          fontSize: 12 * SizeConfig.safeBlockHorizontal),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: this.leftIcon,
        suffixIcon: this.rightIcon,
        fillColor: this.hintColor ?? CustomColors.inputFillColor,
        hintStyle: new TextStyle(
            color: CustomColors.inputHintColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        labelStyle: new TextStyle(
            color: this.labelColor ?? CustomColors.inputLabelColor,
            fontSize: 12 * SizeConfig.safeBlockHorizontal),
        enabledBorder: this.fullBorder == true
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(this.borderRadius??0),
          borderSide: BorderSide(color: CustomColors.inputEnabledBorderColor),
        )
            : UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputEnabledBorderColor),
        ),
        focusedBorder: this.fullBorder == true
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(this.borderRadius??0),
          borderSide: BorderSide(color: CustomColors.inputFocusedColor),
        )
            : UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputFocusedColor),
        ),
        errorStyle: TextStyle(
            fontSize: 12.0 * SizeConfig.safeBlockHorizontal,
            color: this.errorColor ?? Colors.red),
      ),
      validator: (value) {
        if (this.emptyMessage != null && value.trim().isEmpty) {
          return this.emptyMessage;
        }
        return null;
      },
    );
  }

}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}