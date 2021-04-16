import 'package:crossfit/constants/screen_type.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_course_empty_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_purchased_items_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_users_screen.dart';
import '../../../constants/screen_type.dart';

import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_asset_image.dart';
import 'package:crossfit/themes/custom_container.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/base_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_course_edit_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_course_list_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_info_screen.dart';
import 'package:crossfit/ui/pt/coach/pt_coach_renew_account_screen.dart';
import 'package:crossfit/ui/pt/pt_course_register_screen.dart';
import 'package:crossfit/ui/pt/pt_renew_account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../base_pt_screen.dart';

class PrivateCoachHomeScreen extends BasePrivateScreen {
  PrivateCoachHomeScreen(UserModel userModel) : super(userModel);

  @override
  void init(BuildContext context) {
    // TODO: implement init
  }

  @override
  Widget innerBody(BuildContext context) {
    // TODO: implement innerBody
    return CustomContainer(
      padding: 20,
      child: Column(
        children: <Widget>[
          Table(
            children: [
              TableRow(children: [
                CustomAssetImage('coach/renew_account.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_RENEW_PT_COURSE),
                    label: 'Üyelik Yenileme'),
                CustomAssetImage('coach/calculate.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_COACH_CALCULATE),
                    label: 'Aylık Hesaplama'),
              ]),
              TableRow(children: [
                CustomAssetImage('coach/courses.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_COACH_COURSE_LIST),
                    label: 'Antrenör Dersleri',
                    paddingTop: 40),
                CustomAssetImage('coach/course_operations.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_COACH_COURSE_EDIT),
                    label: 'Ders İşlemleri',
                    paddingTop: 40),
              ]),
              TableRow(children: [
                CustomAssetImage('coach/users.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_COACH_USERS),
                    label: 'Üyeler',
                    paddingTop: 40),
                CustomAssetImage('coach/users.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_COACH_EMPTY_COURSES),
                    label: 'Boş Ders Durumu',
                    paddingTop: 40),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  @override
  title() {}

  bool enableUserAccountNavigation() {
    return false;
  }

  goToPage(BuildContext context, ScreenType screenType) {
    BaseScreen page = PrivateCourseRegisterScreen(userModel);
    if (screenType == ScreenType.PT_COACH_INFO)
      page = PrivateCoachInfoScreen(userModel);
    else if (screenType == ScreenType.PT_COACH_CALCULATE)
      page = PrivateCoachPurchasedItemsScreen(userModel);
    else if (screenType == ScreenType.PT_COACH_USERS)
      page = PrivateCoachUsersScreen(userModel);
    else if (screenType == ScreenType.PT_RENEW_PT_COURSE)
      page = PrivateCoachRenewAccountScreen(userModel);
    else if (screenType == ScreenType.PT_COACH_COURSE_LIST)
      page = PrivateCoachCourseListScreen(userModel);
    else if (screenType == ScreenType.PT_COACH_COURSE_EDIT)
      page = PrivateCoachCourseEditScreen(userModel);
    else if (screenType == ScreenType.PT_COACH_EMPTY_COURSES)
      page = PrivateCoachCourseEmptyScreen(userModel);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => page));
  }
}
