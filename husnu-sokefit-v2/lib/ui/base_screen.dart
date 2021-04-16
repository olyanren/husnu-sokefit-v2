import 'package:crossfit/themes/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/custom_text.dart';
import 'base_bloc_screen.dart';

abstract class BaseScreen extends BaseBlocScreen {
  title();

  static const double appBarHeight = 56 + 20.0;

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            //klavye acildiginda pixel overflow olmasini engelliyor.
            //fakat keyboard acildiginde scroll olmuyor. Bundan dolayi
            //register sayfasinda scrolling yapildi
            resizeToAvoidBottomPadding: resizeToAvoidBottomPadding(),
            extendBodyBehindAppBar: true,
            appBar: appbar(context),
            body: body(context))
      ],
    );
  }

  bool resizeToAvoidBottomPadding() {
    return true;
  }

  Widget appbar(BuildContext context) {
    if (title() == null) return null;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      title: title() is CustomText
          ? Align(alignment: Alignment.center, child: title())
          : new CustomText(
              title(),

            ),
    );
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: appBarHeight),
      child: Container(
        color: Colors.transparent,
        child: innerBody(context),
      ),
    );
  }

  Widget innerBody(BuildContext context);

  void dispose() {}

  void init(BuildContext context);
}
