import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/blocs/wods/today_wod_bloc.dart';
import 'package:sokefit/constants/screen_type.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/admin/admin_settings_screen.dart';
import 'package:sokefit/ui/admin/coach_create_screen.dart';
import 'package:sokefit/ui/admin/coaches_screen.dart';
import 'package:sokefit/ui/admin/users_active_screen.dart';
import 'package:sokefit/ui/admin/users_passive_screen.dart';
import 'package:sokefit/ui/admin/wod_hours_screen.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:sokefit/ui/wod_today_hours_summary_screen.dart';
import 'package:sokefit/ui/wod_today_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends BaseUserScreen {
  TodayWodBloc _bloc = new TodayWodBloc();

  AdminHomeScreen(UserModel userModel) : super(userModel);

  @override
  Widget title() {
    return CustomText('Yönetim',fontWeight: FontWeight.bold,fontSize: 20,color: CustomColors.titleColor);
  }

  @override
  Widget innerBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, left: 28.0, right: 28.0),
      child: getContent(context),
    );
  }

  Widget getContent(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () => goToScreen(context, ScreenType.ADMIN_USERS),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    child: Image.asset('assets/images/admin/active-members.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  CustomText(
                    'Aktif Üyeler',
                    color: CustomColors.adminTextColor,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.ADMIN_USERS_PASSIVE),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  child: Image.asset('assets/images/admin/admin-passive-members.png'),
                  backgroundColor: Colors.transparent,
                ),
                CustomText(
                  'Pasif Üyeler',
                  color:CustomColors.adminTextColor,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),

        ]),
        TableRow(children: [
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () => goToScreen(context, ScreenType.ADMIN_WOD_TODAY),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    child: Image.asset('assets/images/admin/admin-weekly-program.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  CustomText(
                    'Haftalık Program',
                    color: CustomColors.adminTextColor,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.WOD_PARTICIPATE),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  child: Image.asset('assets/images/admin/admin-joined-list.png'),
                  backgroundColor: Colors.transparent,
                ),
                CustomText(
                  'WOD Kayıtları',
                  color: CustomColors.adminTextColor,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),

        ]),
        TableRow(children: [
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () => goToScreen(context, ScreenType.ADMIN_CREATE_COACH),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      child: Image.asset('assets/images/admin/admin-coach-add.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                    ),
                    CustomText(
                      'Antrenör Ekleme',
                      color: CustomColors.adminTextColor,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.WOD_TODAY),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  child: Image.asset('assets/images/admin/admin-today-wods.png'),
                  backgroundColor: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                ),
                CustomText(
                  'Günün Wodu',
                  color: CustomColors.adminTextColor,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),

        ]),
        TableRow(children: [
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.ADMIN_COACH_LIST),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  child: Image.asset('assets/images/admin/admin-coach-list.png'),
                  backgroundColor: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                ),
                CustomText(
                  'Antrenör Listesi',
                  color: CustomColors.adminTextColor,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),

          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.ADMIN_SETTINGS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  child: Image.asset('assets/images/settings.png'),
                  backgroundColor: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                ),
                CustomText(
                  'Ayarlar',
                  color: CustomColors.adminTextColor,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),
        ]),
      ],
    );
  }

  goToScreen(BuildContext context, ScreenType screenType) {
    if (screenType == ScreenType.ADMIN_SETTINGS) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AdminSettingsScreen(userModel)));
    } else if (screenType == ScreenType.ADMIN_WOD_TODAY) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => WodHoursScreen(userModel)));
    } else if (screenType == ScreenType.WOD_TODAY) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => WodTodayScreen(userModel)));
    } else if (screenType == ScreenType.WOD_PARTICIPATE) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              WodTodayHoursSummaryScreen(userModel)));
    } else if (screenType == ScreenType.ADMIN_USERS) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => UserActiveScreen(userModel)));
    } else if (screenType == ScreenType.ADMIN_USERS_PASSIVE) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => UserPassiveScreen(userModel)));
    } else if (screenType == ScreenType.ADMIN_CREATE_COACH) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CoachCreateScreen(userModel)));
    } else if (screenType == ScreenType.ADMIN_COACH_LIST) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CoachSummaryScreen(userModel)));
    }
  }

  @override
  init(BuildContext buildContext) {
    // TODO: implement init
    return null;
  }
}
