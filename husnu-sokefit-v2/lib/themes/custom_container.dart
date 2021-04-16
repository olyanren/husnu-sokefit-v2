
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class CustomContainer extends StatelessWidget {
  Widget child;
  bool showBorder;
  Color color;
  Color borderColor;
  double radius;
  double padding;
  bool center;
  double height;

  CustomContainer(
      {@required this.child,
        this.showBorder = false,
        this.color = Colors.transparent,
        this.borderColor = CustomColors.orange,
        this.radius = 5,
        this.height,
        this.padding = 8.0,
        this.center = false});

  @override
  Widget build(BuildContext context) {
    if (this.center)
      return Center(child: getBody());
    else
      return getBody();
  }

  Container getBody() {
    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: showBorder == false
          ? null
          : BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: new Radius.circular(this.radius),
              bottomLeft: new Radius.circular(this.radius),
              bottomRight: new Radius.circular(this.radius),
              topRight: new Radius.circular(this.radius)),
          border: Border.all(width: 2, color: borderColor)),
      child: this.child,
    );
  }
}
