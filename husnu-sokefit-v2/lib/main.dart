import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_future_builder.dart';
import 'package:sokefit/themes/custom_progress_bar.dart';
import 'package:sokefit/themes/size_config.dart';
import 'package:sokefit/ui/login_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ui/video_player_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const int _blackPrimaryValue = 0xFF0C1325;
  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF0C1325),
      200: Color(0xFF0C1325),
      300: Color(0xFF0C1325),
      400: Color(0xFF0C1325),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF0C1325),
      700: Color(0xFF0C1325),
      800: Color(0xFF0C1325),
      900: Color(0xFF0C1325),
    },
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Söke Fit',
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.dark,),

        unselectedWidgetColor:Colors.white,
        buttonColor: CustomColors.primary,
        indicatorColor: Colors.white,
        primaryColor: CustomColors.primary,
        accentColor:  CustomColors.primary,
        dividerColor: Colors.grey,

        fontFamily: 'Turkcell',
        canvasColor: CustomColors.background,
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor:  CustomColors.primary,

        ),

        // for others(Android, Fuchsia)
        cursorColor:  CustomColors.primary,
      ),

      home: CustomFutureBuilder(
          initialData: false,
          future: checkIntroShowed(context),
          // this is where the magic happens
          rememberFutureResult: true,
          whenDone: (bool isIntroShowed) => whenDoneResult(isIntroShowed),
          whenNotDone: (BuildContext context) => whenNotDoneResult(context)),
    );
  }

  Future<bool> checkIntroShowed(BuildContext context) async {
    return true;
  }

  whenNotDoneResult(BuildContext context) {
    if (!SizeConfig.isInit()) SizeConfig().init(context);
    return Container(
        color: Colors.yellow.shade800,
        child: Center(child: CustomProgressBar()));
  }

  whenDoneResult(bool isIntroShowed) {
    return isIntroShowed ? VideoPlayerScreen() : Container();
  }
}
