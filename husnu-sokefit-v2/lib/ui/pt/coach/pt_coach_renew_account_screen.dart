import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/payment/payment_bloc.dart';
import 'package:sokefit/blocs/payment/payment_event.dart';
import 'package:sokefit/blocs/register/register_bloc.dart';
import 'package:sokefit/blocs/register/register_event.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/pt/private_package_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/themes/my_web_view.dart';
import 'package:sokefit/themes/partial_terms_conditions.dart';
import 'package:sokefit/ui/formfields/coach_form_field.dart';
import 'package:sokefit/ui/formfields/package_form_field.dart';
import 'package:sokefit/ui/pt/pt_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../formfields/private_users_form_field.dart';
import '../base_pt_screen.dart';



class PrivateCoachRenewAccountScreen extends BasePrivateScreen {
  CoachModel _selectedCoach;
  UserModel _selectedUser;
  PrivatePackageModel _selectedPackage;
  final _registerBloc = new RegisterBloc();
  final PaymentBloc _paymentBloc = new PaymentBloc();
  TextEditingController _nameController = new TextEditingController();
  PrivateCoachRenewAccountScreen(UserModel userModel) : super(userModel);

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
                                PrivateUsersFormField(
                                  selectedUser: _selectedUser,
                                  onChanged: (item) => _selectedUser = item,
                                ),
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
        //startPayment();
        AlertHelper.showToast(
            context, 'Sonuç', 'Başarılı bir şekilde üyelik yenilediniz.');
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
            context, 'Üyelik yenileme işlemi yapılacaktır. Onaylıyor musunuz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        if (_formKey.currentState.validate()) {
          _registerBloc.privateRenewAccount(
              _selectedCoach.id, _selectedPackage.id,userId: _selectedUser.id);
        }
      }
    });
  }
}
