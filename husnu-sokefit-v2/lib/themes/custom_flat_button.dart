import 'package:sokefit/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomFlatButton extends StatelessWidget {
  String value;
  TextStyle style;
  Color color;
  Color backgroundColor;
  Color borderColor;
  double fontSize;
  FontWeight fontWeight;
  Function onPressed;
  double padding;
  double paddingLeft;
  double paddingTop;
  double paddingRight;
  double paddingBottom;
  double paddingText;
  double paddingTextLeft;
  double paddingTextTop;
  double paddingTextRight;
  double paddingTextBottom;
  Icon leftIcon;
  Icon rightIcon;

  CustomFlatButton(this.value,
      {@required this.onPressed,
        this.style,
        this.color,
        this.backgroundColor,
        this.fontSize,
        this.fontWeight,
        this.borderColor,
        this.padding = 0,
        this.paddingLeft = 0,
        this.paddingTop = 0,
        this.paddingRight = 0,
        this.paddingBottom = 0,
        this.paddingText: 8,
        this.leftIcon,
        this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != 0
          ? EdgeInsets.all(padding)
          : EdgeInsets.only(
          left: this.paddingLeft,
          top: this.paddingTop,
          right: this.paddingRight,
          bottom: this.paddingBottom),
      child: FlatButton(
          padding: EdgeInsets.all(2),
          color: backgroundColor ?? CustomColors.titleColor,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(
                  color: borderColor ?? backgroundColor ?? CustomColors.titleColor)),
          child: buildBody(),
          onPressed: () => onPressedEvent(context)),
    );
  }

  Widget buildBody() {
    if (leftIcon == null && rightIcon == null)
      return Align(alignment: Alignment.center, child: textBody());
    if (leftIcon != null && rightIcon != null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[leftIcon, Expanded(child: textBody()), rightIcon],
      );
    if (rightIcon != null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Expanded(child: textBody()), rightIcon],
      );
    if (leftIcon != null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: leftIcon,
                  ),
                  textBody(),
                ],
              )),
        ],
      );
    else
      return Container();
  }

  Widget textBody() {
    return CustomText(
      this.value,
      padding: this.paddingText,
      paddingLeft: this.paddingTextLeft,
      paddingTop: this.paddingTextTop,
      paddingRight: this.paddingTextRight,
      paddingBottom: this.paddingTextBottom,
      style: this.style,
      color: this.color == null ? CustomColors.background : this.color,
      fontSize: this.fontSize,
      fontWeight: this.fontWeight,
    );
  }

  onPressedEvent(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    this.onPressed();
  }
}
