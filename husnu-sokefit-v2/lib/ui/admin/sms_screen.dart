import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/user/notification_bloc.dart';
import 'package:crossfit/blocs/user/user_active_list_bloc.dart';
import 'package:crossfit/blocs/user/user_summary_bloc.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/models/user_summary.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_multi_select_dropdown_base_model_field.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/custom_text_form_field.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmsScreen extends BaseUserScreen {
  List _selectedUsers;
  TextEditingController _controllerTotal = new TextEditingController();
  final UserSummaryBloc _userSummaryBloc = new UserActiveListBloc();
  final NotificationBloc _smsBloc = new NotificationBloc();
  final _formKey = GlobalKey<FormState>();

  SmsScreen(UserModel userModel) : super(userModel);

  @override
  title() {
    return CustomText(
      'SMS GÖNDER',
      fontWeight: FontWeight.bold,
      color: CustomColors.titleColor,
      fontSize: 20,
    );
  }

  @override
  Widget innerBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, left: 38.0, right: 38.0),
      child: Column(children: <Widget>[
        createForm(context)
      ]),
    );
  }

  Widget createForm(BuildContext context) {
    return Expanded(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          shrinkWrap: true,
          children: <Widget>[
            getUsers(),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: CustomTextFormField(_controllerTotal,
                  'SMS metnini giriniz', 'Sms metni boş olamaz',
                  keyboardType: TextInputType.text, multiline: 5),
            ),

            GestureDetector(
                onTap: () => sendSms(context),
                child: Image.asset('assets/images/send_sms.png'))
          ],
        ),
      ),
    );
  }

  getUsers() {
    return BlocBuilder(
        root: this,
        bloc: _userSummaryBloc,
        child: StreamBuilder(
            stream: _userSummaryBloc.stream,
            builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data is ApiFailedEvent ||
                  snapshot.data is ApiStartedEvent)
                return CustomProgressBarWave();

              List<UserSummary> users =
                  (snapshot.data as ApiFinishedResponseModelEvent)
                      .responseModel
                      .data
                      .map<UserSummary>((document) {
                return UserSummary.fromJson(document);
              }).toList();
              var user = new UserSummary();
              user.id = -1;
              user.name = 'HERKESE GÖNDER';
              users.insert(0, user);
              /*return CustomDropdownBaseModelField<UserSummary>(
                  'Kişi Seçiniz', _selectedUser, 'Kişi Seç', users,
                  (selectedUser) {
                _selectedUser = selectedUser;
                _userSummaryBloc.refresh();
              });

               */
              return CustomMultiSelectDropdownBaseModelField<UserSummary>(
                title: 'Kişi Seçiniz',
                selectedValues: _selectedUsers,
                hintText: '',
                items: users,
                onSaved: (items) {
                  _selectedUsers = items;
                },
                color: Colors.yellow,
              );
            }));
  }

  sendSms(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _smsBloc.sendSms(
          _selectedUsers.map((e) => e.id).join(', '), _controllerTotal.text);
    }
  }

  @override
  init(BuildContext buildContext) {
    _userSummaryBloc.initUsers();
    _smsBloc.stream.listen((event) {
      showResult(buildContext, event);
    });
  }
}
