import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'custom_text.dart';

class CustomAssetImage extends StatelessWidget {
  String image;
  Function onPressed;
  double width;
  double height;
  String label;
  double paddingTop;
  double paddingBottom;

  CustomAssetImage(this.image,
      {this.width, this.height, this.onPressed, this.label, this.paddingTop,this.paddingBottom});

  @override
  Widget build(BuildContext context) {
    if (this.onPressed != null)
      return GestureDetector(
          onTap: () => this.onPressed(), child: _buildInner());
    return _buildInner();
  }

  Widget _buildInner() {

    if (this.label != null) {
      return Padding(
        padding:  EdgeInsets.only(top:this.paddingTop??8,bottom: this.paddingBottom??0),
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/' + this.image,
              width: this.width,
              height: this.height,
            ),
            CustomText(
              this.label,
              color: Colors.white,
              paddingTop: 5,
            )
          ],
        ),
      );
    }else{
      return Padding(
        padding:  EdgeInsets.only(top:this.paddingTop??8,bottom: this.paddingBottom??0),
        child: Image.asset(
          'assets/images/' + this.image,
          width: this.width,
          height: this.height,
        ),
      );
    }

  }
}
