import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/user/notification_bloc.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/string_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:sokefit/ui/formfields/coach_form_field.dart';
import 'package:sokefit/ui/formfields/topic_form_field.dart';
import 'package:sokefit/ui/pt/base_pt_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrivateSendSmsToCoachScreen extends BasePrivateScreen {
  CoachModel _selectedCoach;
  StringModel _selectedTopic;
  var _formKey = GlobalKey<FormState>();
  var _notificationBloc = new NotificationBloc();
  var _messageController = new TextEditingController();

  PrivateSendSmsToCoachScreen(UserModel userModel) : super(userModel);

  @override
  void init(BuildContext context) {
    _notificationBloc.stream.listen((event) => showResult(context, event));
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _notificationBloc,
      child: Container(
          padding: EdgeInsets.all(8),
          child: Form(
              key: _formKey,
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView(

                  children: <Widget>[
                    CoachFormField(
                      selectedCoach: _selectedCoach,
                      onChanged: (item) => _selectedCoach = item,
                      showAllOption: true,
                    ),
                    TopicFormField(
                      selectedTopic: _selectedTopic,
                      onChanged: (item) => _selectedTopic = item,
                    ),
                    Padding(padding: EdgeInsets.all(8),),
                    CustomText('Mesaj'),
                    CustomTextFormField(
                        _messageController, '', 'Bu alan bo?? olamaz',
                        multiline: 5, fullBorder: true, paddingTop: 10),
                    GestureDetector(
                        onTap: () => sendSms(context),
                        child: Image.asset('assets/images/send_sms.png'))
                  ],
                ),
              ))),
    );
  }

  @override
  title() {
    return "Sms G??nder";
  }

  sendSms(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      ConfirmHelper.showConfirm(
              context, 'Sms g??ndermek istedi??inize emin misiniz?')
          .then((result) {
        if (result == ConfirmAction.ACCEPT) {
          _notificationBloc.sendSmsToCoach(
              _selectedCoach.id, 'G??nderen: ${userModel.name}, Konu: ${_selectedTopic.value}, Mesaj: ${_messageController.text.trim()}');
        }
      });
    }
  }
}
