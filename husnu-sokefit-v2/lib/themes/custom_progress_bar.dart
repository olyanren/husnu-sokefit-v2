import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomProgressBar extends StatelessWidget {
  String text;
  CustomProgressBar([this.text='Yükleniyor...']);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: new CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.white))),
              flex: 1,
            ),
            this.text!=null
                ? new Flexible(
              child: new Container(

                  child: new CustomText(this.text,paddingLeft: 5,)),
              flex: 1,
            )
                : Container()
          ]),
    );
  }
}
