import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/location/location_bloc.dart';
import 'package:sokefit/blocs/location/location_event.dart';
import 'package:sokefit/blocs/payment/payment_bloc.dart';
import 'package:sokefit/blocs/payment/payment_event.dart';
import 'package:sokefit/blocs/register/register_bloc.dart';
import 'package:sokefit/blocs/register/register_event.dart';
import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/helpers/loading_helper.dart';
import 'package:sokefit/models/location_model.dart';
import 'package:sokefit/models/package_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_password_confirm_form_field.dart';
import 'package:sokefit/themes/custom_password_form_field.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/themes/my_web_view.dart';
import 'package:sokefit/themes/partial_terms_conditions.dart';
import 'package:sokefit/ui/formfields/location_form_field.dart';
import 'package:sokefit/ui/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _registerBloc = new RegisterBloc();

  final PaymentBloc _paymentBloc = new PaymentBloc();
  PackageModel _selectedPackageModel;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
 LocationModel _selectedLocation;
  _RegisterFormState() {
    _registerBloc.stream.listen((event) {
      showResult(event);
    });
    _paymentBloc.stream.listen((event){
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
                    padding: EdgeInsets.only(top:10.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: CustomText('KAYIT ????LEM??',
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: CustomColors.titleColor)),
                      Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 48.0, right: 48.00),
                        child: Column(children: <Widget>[
                          CustomTextFormField(
                            _fullNameController,
                            'Ad Soyad',
                            'L??tfen ad??n??z?? giriniz',
                          ),
                          CustomTextFormField(
                              _emailController,
                              'E-Posta Adresi',
                              'L??tfen e-posta adresinizi giriniz',
                          keyboardType: TextInputType.emailAddress,),
                          CustomTextFormField(
                              _phoneController,
                              'Telefon Numaras??',
                              'L??tfen telefon numaran??z?? giriniz',
                              keyboardType: TextInputType.phone),
                          CustomPasswordFormField(_passwordController,
                              '??ifre Belirle', 'L??tfen ??ifrenizi giriniz'),
                          CustomPasswordConfirmFormField(
                              _confirmPasswordController,
                              _passwordController,
                              '??ifre Tekrar??',
                              'L??tfen ??ifrenizi tekrar giriniz',
                              '??ifreler uyu??muyor'),
                          LocationFormField(
                            selectedLocation: _selectedLocation,
                            onChanged: (item) => _selectedLocation = item,
                          ),
                          Padding(padding: const EdgeInsets.all(8.0)),
                          PartialTermConditions(),
                          Padding(padding: const EdgeInsets.all(8.0)),

                          GestureDetector(
                              onTap: () => register(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Image.asset('assets/images/register.png'),
                              )),
                        ]),
                      ),
                    ],
                  )),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/odeme.png',
                    height: 20,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  register() {
    if (_formKey.currentState.validate()) {
      ConfirmHelper.showConfirm(
              context, 'Kay??t olmak istedi??inize emin misiniz?')
          .then((result) {
        if (result == ConfirmAction.ACCEPT) {
          FocusScope.of(context).unfocus();
          // If the form is valid, display a Snackbar.
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: CustomText('Kay??t olunuyor...')));
          var userModel = new UserModel();
          userModel.name = this._fullNameController.text;
          userModel.password = this._passwordController.text;
          userModel.phone = this._phoneController.text;
          userModel.email = this._emailController.text;
          userModel.locationId = this._selectedLocation.id;
          userModel.packageId = 0;
          _registerBloc.register(userModel);
          LoadingHelper.show(context);
        }
      });
    }
  }

  void showResult(ApiEvent event) {
    if (event is RegisterSuccess) {
      AlertHelper.showToast(context, 'Sonu??', 'Kay??t i??lemi tamamland??.??imdi giri?? sayfas??na y??nlendiriliyorsunuz');
      goToLogin();
    }else if (event is ApiFailedEvent) {
      LoadingHelper.hide(context);
      AlertHelper.showToast(context, 'Hata Olu??tu', event.message);
    }
  }

  void startPayment(UserModel userModel) {
    Constants.ACCESS_TOKEN=userModel.accessToken;
    _paymentBloc.eventSink
        .add(new PaymentStartedEvent(this._selectedPackageModel.id));
  }
  void goTo3DPayment(htmlUrl) async {

    String result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) => MyWebView(
                title: 'Online ??deme',
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
