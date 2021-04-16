import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/package/package_bloc.dart';
import 'package:sokefit/blocs/package/package_event.dart';
import 'package:sokefit/blocs/payment/payment_bloc.dart';
import 'package:sokefit/blocs/payment/payment_event.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/helpers/loading_helper.dart';
import 'package:sokefit/models/package_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/custom_dropdown_package_model_field.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/my_web_view.dart';
import 'package:sokefit/themes/partial_terms_conditions.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends BaseUserScreen {
  final _formKey = GlobalKey<FormState>();
  final PaymentBloc _paymentBloc = new PaymentBloc();
  PackageBloc _packageBloc = new PackageBloc();

  UserModel _userModel;

  PackageModel _selectedPackageModel;

  PaymentScreen(this._userModel) : super(_userModel);

  @override
  String title() {
    return null;
  }

  hideSubMenu() {
    return true;
  }

  @override
  Widget innerBody(BuildContext context) {
    return Column(
      children: <Widget>[
        defaultInfo(),
        createForm(context),
        Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/odeme.png',
                  height: 20,
                ),
              ],
            ))
      ],
    );
  }

  Widget defaultInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            this._userModel.image == null|| this._userModel.image.isEmpty || this._userModel.image.startsWith('file:///')
                ? Image.asset(
                    'assets/images/avatar.png',
                    height: 150,
                  )
                : CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage("${this._userModel.image}"),
                    backgroundColor: Colors.transparent,
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                        DateHelper.getDateAsTurkish(this._userModel.datePaid),
                        fontSize: 25,
                        color: Colors.yellow.shade600),
                    CustomText('KAYIT TARİHİ'),
                    CustomText(
                        DateHelper.getDateAsTurkish(this._userModel.finishDate),
                        fontSize: 25,
                        color: Colors.yellow.shade600),
                    CustomText('BİTİŞ TARİHİ'),
                    Row(
                      children: <Widget>[
                        CustomText(
                            this._userModel.remainingDay == null
                                ? 0
                                : this._userModel.remainingDay.toString(),
                            fontSize: 30,
                            color: Colors.yellow.shade600),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CustomText('KALAN'),
                              CustomText('GÜN'),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createForm(BuildContext buildContext) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 58.0, right: 58),
        child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.only(top: 10.0),
              shrinkWrap: true,
              children: [
                StreamBuilder(
                    stream: _packageBloc.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<ApiEvent> snapshot) {
                      if (!snapshot.hasData ||
                          !(snapshot.data is PackageFinishedEvent))
                        return Container();
                      return CustomDropdownPackageModelField<PackageModel>(
                          'Paket Seçimi',
                          _selectedPackageModel,
                          'Lütfen paket seçiniz',
                          (snapshot.data as PackageFinishedEvent).packages,
                          (PackageModel packageModel) {
                        _selectedPackageModel = packageModel;
                        _packageBloc.refresh();
                      });
                    }),

                BlocBuilder(
                  root: this,
                  bloc: _paymentBloc,
                  child: GestureDetector(
                      onTap: () => payment(buildContext),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child:
                            Image.asset('assets/images/payment_and_save.png'),
                      )),
                ),
                PartialTermConditions(),
              ],
            )),
      ),
    );
  }

  void init(BuildContext buildContext) {
    _packageBloc.init();
    _paymentBloc.stream.listen((event) {
      showResult(buildContext, event);
    });
  }

  void showResult(BuildContext context, ApiEvent event) {
    if (event is PaymentSuccessEvent) {
      LoadingHelper.hide(context);
      goTo3DPayment(context, event.htmlUrl);
    }
    if (event is ApiFailedEvent) {
      LoadingHelper.hide(context);
      AlertHelper.showToast(context, 'Hata Oluştu', event.message);
    }
  }

  void goTo3DPayment(BuildContext context, htmlUrl) async {

    String result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) => MyWebView(
                title: 'Online Ödeme',
                url: htmlUrl,
                successUrl: 'pay-success',
                errorUrl: 'pay-fail')));
    if(result==null)AlertHelper.show(context, 'Hata', 'Ödeme işlemi iptal edildi');
    else if (result.toLowerCase().startsWith("hata"))
      AlertHelper.showPaymentResult(context, 'Hata Oluştu', result);
    else
      AlertHelper.showPaymentResult(context, 'İşlem Sonucu', result);
  }

  void payment(BuildContext context) {
    if (_formKey.currentState.validate()) {
      ConfirmHelper.showConfirm(
              context, 'Üyeliğinizi yenilemek istediğinize emin misiniz?')
          .then((result) {
        if (result == ConfirmAction.ACCEPT) {
          FocusScope.of(context).unfocus();
          LoadingHelper.show(context);
          _paymentBloc.eventSink
              .add(new PaymentStartedEvent(this._selectedPackageModel.id));
        }
      });
    }
  }
}
