import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/payment/payment_bloc.dart';
import 'package:crossfit/blocs/payment/payment_event.dart';
import 'package:crossfit/blocs/register/register_bloc.dart';
import 'package:crossfit/blocs/register/register_event.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/helpers/date_helper.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/pt/private_package_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/formfields/coach_form_field.dart';
import 'package:crossfit/ui/formfields/package_form_field.dart';
import 'package:crossfit/ui/formfields/private_users_form_field.dart';
import 'package:crossfit/ui/pt/pt_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base_user_screen.dart';

class PrivateAdminRenewAccountScreen extends BaseUserScreen {
  UserModel _selectedUser;
  CoachModel _selectedCoach;
  PrivatePackageModel _selectedPackage;
  final _registerBloc = new RegisterBloc();
  final PaymentBloc _paymentBloc = new PaymentBloc();


  PrivateAdminRenewAccountScreen(UserModel userModel) : super(userModel);

  final _formKey = GlobalKey<FormState>();

  @override
  title() {
    return CustomText('PT KAYDI',
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: CustomColors.turquoise);
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
                              'ÜYELİK YENİLEME TARİHİ',
                              color: Colors.white,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 48.0, right: 48),
                              child: Column(children: <Widget>[
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
                                Padding(padding: const EdgeInsets.all(8.0)),
                                CustomFlatButton(
                                  'ÜYELİK YENİLE',
                                  onPressed: () => register(context),
                                ),
                              ]),
                            ),
                          ],
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
      ),
    );
  }

  @override
  void init(BuildContext context) {
    _registerBloc.stream.listen((event) {
      if (event is PrivateAccountRenewFinishedEvent) {
        AlertHelper.show(context, 'Sonuç', 'Başarılı bir şekilde yenilendi');
      }
    });

    _paymentBloc.stream.listen((event) {
      if (event is PaymentSuccessEvent) {

        AlertHelper.showWithResult(
            context, 'Sonuç', 'Hesap yenileme işlemi başarılı');
      } else if (event is ApiFailedEvent) {

        showResult(context, event);
      }
    });
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
              _selectedCoach.id, _selectedPackage.id,userId:_selectedUser.id);
        }
      }
    });
  }
}
