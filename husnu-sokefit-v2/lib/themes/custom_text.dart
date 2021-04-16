import 'package:sokefit/themes/size_config.dart';

import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String value;
  TextStyle style;
  Color color;
  double fontSize;
  bool autoSize = true;
  bool wrapText = false;
  FontWeight fontWeight;
  TextDecoration textDecoration;
  FontStyle fontStyle;
  String fontFamily;
  double padding;
  double paddingLeft;
  double paddingTop;
  double paddingRight;
  double paddingBottom;
  bool center;
  TextAlign textAlign;
  Function onClick;
  bool underline;

  CustomText(this.value,
      {this.style,
        this.color,
        this.fontSize,
        this.fontWeight,
        this.textDecoration,
        this.autoSize,
        this.fontStyle,
        this.fontFamily,
        this.wrapText = false,
        this.padding = 0,
        this.paddingLeft = 0,
        this.paddingTop = 0,
        this.paddingRight = 0,
        this.paddingBottom = 0,
        this.center = false,
        this.textAlign = TextAlign.left,
        this.onClick,
        this.underline});

  @override
  Widget build(BuildContext context) {
    if (this.wrapText) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: padding != 0
                  ? EdgeInsets.all(padding)
                  : EdgeInsets.only(
                  left: this.paddingLeft,
                  top: this.paddingTop,
                  right: this.paddingRight,
                  bottom: this.paddingBottom),
              child: center == true ? Center(child: buildText()) : buildText(),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: padding != 0
            ? EdgeInsets.all(padding)
            : EdgeInsets.only(
            left: this.paddingLeft,
            top: this.paddingTop,
            right: this.paddingRight,
            bottom: this.paddingBottom),
        child: center == true ? Center(child: buildText()) : buildText(),
      );
    }
  }

  Widget buildText() {
    if (this.onClick != null)
      return GestureDetector(
          onTap: () => this.onClick(), child: _buildTextInner());
    return _buildTextInner();
  }

  Text _buildTextInner() {
    return Text(
      this.value,
      style: getStyle(),
      maxLines: 20,
      textAlign: this.textAlign,
    );
  }

  TextStyle getStyle() {
    return this.style != null
        ? this.style
        : TextStyle(
        color: this.color?? Colors.white,
        fontSize: this.fontSize != null
            ? this.fontSize * SizeConfig.safeBlockHorizontal
            : 12 * SizeConfig.safeBlockHorizontal,
        decoration: this.textDecoration != null
            ? this.textDecoration
            : this.underline == true
            ? TextDecoration.underline
            : TextDecoration.none,
        fontWeight:
        this.fontWeight != null ? this.fontWeight : FontWeight.normal,
        fontFamily: this.fontFamily != null ? this.fontFamily : 'Turkcell',
        fontStyle:
        this.fontStyle != null ? this.fontStyle : FontStyle.normal);
  }
}
