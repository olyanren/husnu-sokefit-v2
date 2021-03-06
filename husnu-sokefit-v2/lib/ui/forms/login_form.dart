import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/helpers/loading_helper.dart';
import 'package:sokefit/models/today_hour_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/login/login_bloc.dart';
import 'package:sokefit/blocs/login/login_event.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/dialog_prompt_helper.dart';
import 'package:sokefit/helpers/dialog_prompt_phone_helper.dart';
import 'package:sokefit/helpers/snackbar_helper.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/repositories/user_repository.dart';
import 'package:sokefit/themes/custom_checkbox.dart';
import 'package:sokefit/themes/custom_password_form_field.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/ui/admin/admin_home_choose_pt_or_wod_screen.dart';
import 'package:sokefit/ui/admin/admin_home_screen.dart';
import 'package:sokefit/ui/pt/admin/pt_admin_home_screen.dart';
import 'package:sokefit/ui/pt/coach/pt_coach_home_screen.dart';
import 'package:sokefit/ui/pt/pt_home_screen.dart';

import 'package:sokefit/ui/wod_today_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _loginBloc = new LoginBloc();
  bool _selectedRememberMe = false;
  bool _selectedKvk = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc.stream.listen((event) {
      showResult(event);
    });
    _loginBloc.init();
  }

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Center(
      child: Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 28.00),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                        padding: EdgeInsets.all(0.0),
                        shrinkWrap: true,
                        children: <Widget>[
                          Image.asset("assets/images/login-logo.gif",
                              height: 170),
                          Padding(
                            padding: EdgeInsets.all(30),
                          ),
                          CustomTextFormField(
                              _phoneController,
                              'Telefon Numaras??',
                              'L??tfen telefon numaran??z?? giriniz',
                              keyboardType: TextInputType.phone),
                          CustomPasswordFormField(_passwordController, '??ifre',
                              'L??tfen ??ifrenizi giriniz'),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: CustomCheckBox('Beni Hat??rla',
                                    _selectedRememberMe, rememberMe),
                              ),
                              GestureDetector(
                                onTap: () => openForgetPasswordDialog(context),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                          "assets/images/forget-password.png",
                                          height: 25),
                                      CustomText(
                                        '??ifremi Unuttum',
                                        color: CustomColors.titleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () => login(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Image.asset('assets/images/login.png'),
                              )),
                        ]),
                  ),
                  CustomCheckBox(
                      'Bilgilendirme Metni (KVKK)', _selectedKvk, openKVKKTerms)
                ],
              ))),
    );
  }

  void openKVKKTerms(bool isChecked) {
    if (isChecked) {
      LoadingHelper.show(context);
      DefaultAssetBundle.of(context)
          .loadString("assets/html/kvkk_terms.html")
          .then((result) {
        LoadingHelper.hide(context);
        AlertHelper.showHtml(context, 'KVKK ??artlar??', result,
            color: Colors.white);
      });
    }

    setState(() {
      _selectedKvk = isChecked;
    });
  }

  openForgetPasswordDialog(BuildContext context) {
    PromptDialogTelephoneHelper.show(context, 'Telefon numaran??z:',
            'Sistemde kay??tl?? olan telefon numaran??z')
        .then((PromptResult result) {
      if (result.status) {
        var userRepository = new UserRepository();
        userRepository.forgetPassword(result.data).then((result) {
          if (result.status) {
            AlertHelper.showToast(context, '????lem Sonucu',
                '??ifreniz ba??ar??l?? bir ??ekilde telefonunuza g??nderildi');
          } else {
            AlertHelper.showToast(context, 'Hata', result.message);
          }
        });
      }
    });
  }

  login() {
    if (_selectedKvk == false) {
      AlertHelper.show(context, "Hata", "KVKK ??artlar??n?? kabul etmelisiniz");
    } else if (_formKey.currentState.validate()) {
      SnackBarHelper.show(context, 'Giri?? yap??l??yor');
      _loginBloc.loginEventSink.add(new LoginStartedEvent(
          this._phoneController.text,
          this._passwordController.text,
          this._selectedRememberMe));
    }
  }

  void showResult(ApiEvent event) {
    if (event is LoginInitializeFinishedEvent) {
      var user = event.user;
      if (user != null) {
        _phoneController.text = user.phone;
        _passwordController.text = user.password;
        setState(() {
          _selectedRememberMe = true;
        });
      }
    } else if (event is LoginSuccessEvent) {
      SnackBarHelper.hide();
      goToTodayWodScreen(event.user);
    } else if (event is ApiFailedEvent) {
      SnackBarHelper.hide();
      AlertHelper.showToast(context, 'Hata Olu??tu', event.message);
    }
  }

  void goToTodayWodScreen(UserModel userModel) {
    if (userModel.role.contains('admin')) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              AdminHomeChoosePTOrWodScreen(userModel)));
    } else if (userModel.role == 'pt') {
      initOneSignal(userModel);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => PrivateHomeScreen(userModel)));
    } else if (userModel.role.contains('pt_coach')) {
      initOneSignal(userModel, tag: 'coachId');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              PrivateCoachHomeScreen(userModel)));
    } else if (userModel.role.contains('pt_admin')) {
      initOneSignal(userModel, tag: 'adminId');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              PrivateAdminHomeScreen(userModel)));
    } else {
      initOneSignal(userModel);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => WodTodayScreen(userModel)));
    }
  }

  void initOneSignal(UserModel userModel, {String tag: 'userId'}) {
    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.init(Constants.ONESIGNAL_APP_ID, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    }).then((value) {
      OneSignal.shared
          .setInFocusDisplayType(OSNotificationDisplayType.notification);
      OneSignal.shared.sendTag(tag, userModel.id);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loginBloc.dispose();
  }

  void rememberMe(bool isChecked) {
    setState(() {
      _selectedRememberMe = isChecked;
    });
  }
}
