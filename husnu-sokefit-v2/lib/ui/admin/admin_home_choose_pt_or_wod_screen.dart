import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/blocs/wods/today_wod_bloc.dart';
import 'package:crossfit/constants/screen_type.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/admin/admin_home_screen.dart';
import 'package:crossfit/ui/admin/admin_settings_screen.dart';
import 'package:crossfit/ui/admin/coach_create_screen.dart';
import 'package:crossfit/ui/admin/coaches_screen.dart';
import 'package:crossfit/ui/admin/users_active_screen.dart';
import 'package:crossfit/ui/admin/users_passive_screen.dart';
import 'package:crossfit/ui/admin/wod_hours_screen.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:crossfit/ui/pt/admin/pt_admin_home_screen.dart';
import 'package:crossfit/ui/wod_today_hours_summary_screen.dart';
import 'package:crossfit/ui/wod_today_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminHomeChoosePTOrWodScreen extends BaseUserScreen {


  AdminHomeChoosePTOrWodScreen(UserModel userModel) : super(userModel);

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
    return Center(
      child: Column(children: [
        GestureDetector(
          onTap: () => goToScreen(context, ScreenType.ADMIN_PT_PAGE),
          child: Image.asset('assets/images/admin/pt_option.png',),
        ),
        GestureDetector(
          onTap: () => goToScreen(context, ScreenType.ADMIN_WOD_PAGE),
          child:  Image.asset('assets/images/admin/wod_option.png')

        ),
      ],),
    );
  }

  goToScreen(BuildContext context, ScreenType screenType) {
    if (screenType == ScreenType.ADMIN_PT_PAGE) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PrivateAdminHomeScreen(userModel)));
    } else if (screenType == ScreenType.ADMIN_WOD_PAGE) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AdminHomeScreen(userModel)));
    }

  }

  @override
  init(BuildContext buildContext) {
    // TODO: implement init
    return null;
  }
}
