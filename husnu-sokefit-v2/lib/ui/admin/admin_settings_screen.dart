import 'package:sokefit/constants/screen_type.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/size_config.dart';
import 'package:sokefit/ui/admin/admin_prices_screen.dart';
import 'package:sokefit/ui/admin/onesignal_screen.dart';
import 'package:sokefit/ui/admin/sms_screen.dart';
import 'package:sokefit/ui/admin/wod_hours_create_screen.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminSettingsScreen extends BaseUserScreen {
  AdminSettingsScreen(UserModel userModel) : super(userModel);

  @override
   title() {
    return   CustomText(
      'AYARLAR',
      fontWeight: FontWeight.bold,
      color: CustomColors.titleColor,
      fontSize: 20,
    );
  }

  @override
  Widget innerBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*Padding(
            padding: const EdgeInsets.all(10),
          ),
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.ADMIN_DEFINE_WOD_HOURS),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  child: Image.asset('assets/images/admin/wod_adjust_clock.png'),
                  backgroundColor: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText('WOD SAATLERİ TANIMLAMA',
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

           */
          Padding(
            padding: const EdgeInsets.all(10),
          ),
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.ADMIN_PRICES),
            child: Image.asset('assets/images/admin/admin-member-price.png',fit: BoxFit.fitWidth,),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
          ),
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.SEND_SMS),
            child: Image.asset('assets/images/admin/sms.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
          ),
          GestureDetector(
            onTap: () => goToScreen(context, ScreenType.SEND_ONESIGNAL),
            child: Image.asset('assets/images/admin/notification.png',),
          ),
        ],
      ),
    );
  }

  goToScreen(BuildContext context, ScreenType screenType) {
    if (screenType == ScreenType.ADMIN_DEFINE_WOD_HOURS) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => WodHourCreateScreen(userModel)));
    } else if (screenType == ScreenType.ADMIN_PRICES) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AdminPricesScreen(userModel)));
    } else if (screenType == ScreenType.SEND_SMS) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SmsScreen(userModel)));
    } else if (screenType == ScreenType.SEND_ONESIGNAL) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OnesignalScreen(userModel)));
    }
  }

  @override
  init(BuildContext buildContext) {
    // TODO: implement init
    return null;
  }
}
