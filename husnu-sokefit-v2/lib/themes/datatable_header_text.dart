import 'package:crossfit/themes/custom_text.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class DataTableHeaderText extends StatelessWidget {
  String value;
  TextStyle style;
  double fontSize;
  DataTableHeaderText(this.value, {this.style,this.fontSize});

  @override
  Widget build(BuildContext context) {
    return new CustomText(
      this.value,
      color: CustomColors.turquoise,
      fontWeight: FontWeight.bold,
      fontSize: this.fontSize??15,
      textDecoration: TextDecoration.none,
    );
  }
}
