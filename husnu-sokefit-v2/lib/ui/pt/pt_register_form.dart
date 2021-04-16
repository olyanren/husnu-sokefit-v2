import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/payment/payment_bloc.dart';
import 'package:sokefit/blocs/payment/payment_event.dart';
import 'package:sokefit/blocs/register/register_bloc.dart';
import 'package:sokefit/blocs/register/register_event.dart';
import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/helpers/loading_helper.dart';
import 'package:sokefit/helpers/snackbar_helper.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/location_model.dart';
import 'package:sokefit/models/pt/private_package_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_password_confirm_form_field.dart';
import 'package:sokefit/themes/custom_password_form_field.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/themes/my_web_view.dart';
import 'package:sokefit/themes/partial_terms_conditions.dart';
import 'package:sokefit/ui/formfields/coach_form_field.dart';
import 'package:sokefit/ui/formfields/location_form_field.dart';
import 'package:sokefit/ui/formfields/location_with_coach_form_field.dart';
import 'package:sokefit/ui/formfields/package_form_field.dart';
import 'package:sokefit/ui/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';

class PtRegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<PtRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _registerBloc = new RegisterBloc();

  final PaymentBloc _paymentBloc = new PaymentBloc();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  CoachModel _selectedCoach;
  LocationModel _selectedLocation;
  PrivatePackageModel _selectedPackage;

  _RegisterFormState() {
    _registerBloc.stream.listen((event) {
      showResult(event);
    });
    _paymentBloc.stream.listen((event) {
      showResult(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.00),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: CustomText('PT KAYDI',
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: CustomColors.turquoise)),
                      Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            DateHelper.getDateAsTurkish(),
                            color: CustomColors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            'ÜYE KAYIT TARİHİ',
                            color: Colors.white,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 48.0, right: 48),
                            child: Column(children: <Widget>[
                              CustomTextFormField(
                                _fullNameController,
                                'Ad Soyad',
                                'Lütfen adınızı giriniz',
                              ),
                              CustomTextFormField(
                                _emailController,
                                'E-Posta Adresi',
                                'Lütfen e-posta adresinizi giriniz',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              CustomTextFormField(
                                  _phoneController,
                                  'Telefon (Ör: 05305300000)',
                                  'Lütfen telefon numaranızı giriniz',
                                  keyboardType: TextInputType.phone),
                              CustomPasswordFormField(_passwordController,
                                  'Şifre Belirle', 'Lütfen şifrenizi giriniz'),
                              CustomPasswordConfirmFormField(
                                  _confirmPasswordController,
                                  _passwordController,
                                  'Şifre Tekrarı',
                                  'Lütfen şifrenizi tekrar giriniz',
                                  'Şifreler uyuşmuyor'),
                              PackageFormField(
                                selectedPackage: _selectedPackage,
                                onChanged: (item) => _selectedPackage = item,
                              ),
                              LocationWithCoachFormField(
                                  selectedLocation: _selectedLocation,
                                  selectedCoach: _selectedCoach,
                                  onChanged: (location, coach) {
                                    _selectedLocation = location;
                                    _selectedCoach = coach;
                                  }),


                              // PartialTermConditions(),
                              Padding(padding: const EdgeInsets.all(8.0)),
                              GestureDetector(
                                  onTap: () => register(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Image.asset(
                                        'assets/images/sign_up.png'),
                                  )),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          )
          /*Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/odeme.png',
                    height: 20,
                  ),
                ],
              ))*/
        ],
      ),
    );
  }

  register() {
    if (_formKey.currentState.validate()) {
      ConfirmHelper.showConfirm(
              context, 'Kayıt olmak istediğinize emin misiniz?')
          .then((result) {
        if (result == ConfirmAction.ACCEPT) {
          FocusScope.of(context).unfocus();
          SnackBarHelper.show(context, 'Kayıt olunuyor...');
          var userModel = new UserModel();
          userModel.name = this._fullNameController.text;
          userModel.password = this._passwordController.text;
          userModel.phone = this._phoneController.text;
          userModel.email = this._emailController.text;
          userModel.packageId = this._selectedPackage.id;
          userModel.coachId = this._selectedCoach.id;
          userModel.locationId = this._selectedLocation.id;
          _registerBloc.privateRegister(userModel);
          LoadingHelper.show(context);
        }
      });
    }
  }

  void showResult(ApiEvent event) {
    SnackBarHelper.hide();
    if (event is RegisterSuccess) {
      AlertHelper.showWithResult(context, 'Sonuç',
              'Kayıt işlemi tamamlandı. Giriş yapabilirsiniz.')
          .then((onValue) {
        goToLogin();
      });
    } else if (event is PaymentSuccessEvent) {
      LoadingHelper.hide(context);
      goTo3DPayment(event.htmlUrl);
    } else if (event is ApiFailedEvent) {
      LoadingHelper.hide(context);
      AlertHelper.showToast(context, 'Hata Oluştu', event.message);
    }
  }

  void startPayment(UserModel userModel) {
    Constants.ACCESS_TOKEN = userModel.accessToken;
    _paymentBloc.startPrivatePayment(
        this._selectedPackage.id, this._selectedCoach.id);
  }

  void goTo3DPayment(htmlUrl) async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyWebView(
            title: 'Online Ödeme',
            url: htmlUrl,
            successUrl: 'pay-success',
            errorUrl: 'pay-fail')));
    AlertHelper.showToast(context, result, result);
    goToLogin();
  }

  void goToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _registerBloc.dispose();
    _paymentBloc.dispose();
  }
}
