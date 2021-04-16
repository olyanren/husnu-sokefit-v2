import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/user/notification_bloc.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/string_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/custom_text_form_field.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:crossfit/ui/formfields/coach_form_field.dart';
import 'package:crossfit/ui/formfields/topic_form_field.dart';
import 'package:crossfit/ui/pt/base_pt_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrivateSendNotificationToCoachScreen extends BasePrivateScreen {
  CoachModel _selectedCoach;
  StringModel _selectedTopic;
  var _formKey = GlobalKey<FormState>();
  var _notificationBloc = new NotificationBloc();
  var _messageController = new TextEditingController();

  PrivateSendNotificationToCoachScreen(UserModel userModel) : super(userModel);

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
                      showAllOption:false
                    ),
                    TopicFormField(
                      selectedTopic: _selectedTopic,
                      onChanged: (item) => _selectedTopic = item,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    CustomText(
                      'Bilgilendirme Mesaj',
                      color: CustomColors.orange,
                    ),
                    CustomTextFormField(
                        _messageController, '', 'Bu alan boş olamaz',
                        multiline: 5, fullBorder: true, paddingTop: 10),
                    GestureDetector(
                        onTap: () => sendNotification(context),
                        child:
                            Image.asset('assets/images/send_notification.png'))
                  ],
                ),
              ))),
    );
  }

  @override
  title() {
    return "BİLDİRİM GÖNDER";
  }

  sendNotification(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      ConfirmHelper.showConfirm(
              context, 'Bildirim göndermek istediğinize emin misiniz?')
          .then((result) {
        if (result == ConfirmAction.ACCEPT) {
          _notificationBloc.sendOneSignalNotification(
              _selectedCoach.id.toString(),
              'Gönderen: ${userModel.name}, Konu: ${_selectedTopic.value}, Mesaj: ${_messageController.text.trim()}','coachId');
        }
      });
    }
  }
}
