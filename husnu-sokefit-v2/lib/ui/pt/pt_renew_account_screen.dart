import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/payment/payment_bloc.dart';
import 'package:crossfit/blocs/payment/payment_event.dart';
import 'package:crossfit/blocs/register/register_bloc.dart';
import 'package:crossfit/blocs/register/register_event.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/helpers/date_helper.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/pt/private_package_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/custom_text_form_field.dart';
import 'package:crossfit/themes/my_web_view.dart';
import 'package:crossfit/themes/partial_terms_conditions.dart';
import 'package:crossfit/ui/formfields/coach_form_field.dart';
import 'package:crossfit/ui/formfields/package_form_field.dart';
import 'package:crossfit/ui/pt/pt_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_user_screen.dart';
import 'base_pt_screen.dart';

class PrivateRenewAccountScreen extends BasePrivateScreen {
  CoachModel _selectedCoach;
  PrivatePackageModel _selectedPackage;
  final _registerBloc = new RegisterBloc();
  final PaymentBloc _paymentBloc = new PaymentBloc();
  TextEditingController _nameController = new TextEditingController();
  PrivateRenewAccountScreen(UserModel userModel) : super(userModel);

  final _formKey = GlobalKey<FormState>();

  @override
  title() {
    return 'Üyelik Yenileme';
  }

  @override
  innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _registerBloc,
      child: Center(
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
                        Padding(
                          padding: const EdgeInsets.only(left: 48.0, right: 48),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomTextFormField(_nameController,'İsim','',disabled:true),
                                CoachFormField(
                                  selectedCoach: _selectedCoach,
                                  onChanged: (item) => _selectedCoach = item,
                                ),
                                PackageFormField(
                                  selectedPackage: _selectedPackage,
                                  onChanged: (item) => _selectedPackage = item,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                ),
                                //PartialTermConditions(),
                                Padding(padding: const EdgeInsets.all(8.0)),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: ()=>register(context),
                                    child: Image.asset('assets/images/save.png'),

                                  ),
                                )

                              ]),
                        ),
                      ],
                    )),
              ),
            ),
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
      ),
    );
  }

  @override
  void init(BuildContext context) {
    _nameController.text=userModel.name;
    _registerBloc.stream.listen((event) {
      if (event is PrivateAccountRenewFinishedEvent) {
        startPayment();
        /*
        AlertHelper.showToast(
            context, 'Sonuç', 'Başarılı bir şekilde üyelik yenilediniz.');

         */
      } else
        showResult(context, event);
    });

    _paymentBloc.stream.listen((event) {
      if (event is PaymentSuccessEvent) {
        goTo3DPayment(context, event.htmlUrl);
      } else if (event is ApiFailedEvent) {
        showResult(context, event);
      }
    });
  }

  void startPayment() {
    _paymentBloc.startPrivatePayment(
        this._selectedPackage.id, this._selectedCoach.id);
  }

  void goTo3DPayment(BuildContext context, htmlUrl) async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyWebView(
            title: 'Online Ödeme',
            url: htmlUrl,
            successUrl: 'pay-success',
            errorUrl: 'pay-fail')));
    AlertHelper.showToast(context, result, result);
    goToPtHomeScreen(context);
  }

  void goToPtHomeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PrivateHomeScreen(userModel)));
  }

  register(BuildContext context) {
    ConfirmHelper.showConfirm(
            context, 'Üyeliğinizi yenilemek istediğinize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        if (_formKey.currentState.validate()) {
          _registerBloc.privateRenewAccount(
              _selectedCoach.id, _selectedPackage.id);
        }
      }
    });
  }
}
