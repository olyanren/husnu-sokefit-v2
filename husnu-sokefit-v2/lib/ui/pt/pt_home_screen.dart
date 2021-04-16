import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/constants/screen_type.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/custom_asset_image.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_container.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/base_screen.dart';
import 'package:sokefit/ui/pt/private_send_notification_to_coach_screen.dart';
import 'package:sokefit/ui/pt/pt_course_list_screen.dart';
import 'package:sokefit/ui/pt/pt_course_register_screen.dart';
import 'package:sokefit/ui/pt/pt_renew_account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'base_pt_screen.dart';
import 'private_send_sms_to_coach_screen.dart';

class PrivateHomeScreen extends BasePrivateScreen {
  PrivateHomeScreen(UserModel userModel) : super(userModel);

  @override
  void init(BuildContext context) {}

  @override
  Widget innerBody(BuildContext context) {
    // TODO: implement innerBody
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CustomText(
                    'Toplam Ders: ',
                    color: Colors.white,
                  ),
                  CustomText(
                    (userModel.joinedCount + userModel.remainingDay).toString(),
                    color: CustomColors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  CustomText(
                    'Kalan Ders: ',
                    color: Colors.white,
                  ),
                  CustomText(
                    userModel.remainingDay.toString(),
                    color: CustomColors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomAssetImage(
                    'user/btn_course_select.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_CHOOSE_DAY_HOUR),
                    paddingBottom: 0,
                    paddingTop: 0,
                  ),
                  CustomAssetImage(
                    'user/btn_courses.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_LIST_DAY_HOUR),
                  ),
                  CustomAssetImage(
                    'user/btn_renew_course.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_RENEW_PT_COURSE),
                  ),
                  CustomAssetImage(
                    'user/btn_sms.png',
                    onPressed: () =>
                        goToPage(context, ScreenType.PT_SEND_SMS_TO_COACH),
                  ),
                  CustomAssetImage(
                    'user/btn_notification.png',
                    onPressed: () => goToPage(
                        context, ScreenType.PT_SEND_NOTIFICATION_TO_COACH),
                  ),
                ],
              ),
            ),
          ),
          //   Spacer(),
        ],
      ),
    );
  }

  @override
  title() {
    return null;
  }

  bool enableUserAccountNavigation() {
    return true;
  }

  goToPage(BuildContext context, ScreenType screenType) {
    BaseScreen page = PrivateCourseRegisterScreen(userModel);
    if (screenType == ScreenType.PT_CHOOSE_DAY_HOUR)
      page = PrivateCourseRegisterScreen(userModel);
    else if (screenType == ScreenType.PT_LIST_DAY_HOUR)
      page = PrivateCourseListScreen(userModel);
    else if (screenType == ScreenType.PT_RENEW_PT_COURSE)
      page = PrivateRenewAccountScreen(userModel);
    else if (screenType == ScreenType.PT_SEND_SMS_TO_COACH)
      page = PrivateSendSmsToCoachScreen(userModel);
    else if (screenType == ScreenType.PT_SEND_NOTIFICATION_TO_COACH)
      page = PrivateSendNotificationToCoachScreen(userModel);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => page));
  }
}
