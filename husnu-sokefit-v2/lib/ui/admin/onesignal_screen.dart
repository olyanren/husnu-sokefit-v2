import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/user/notification_bloc.dart';
import 'package:sokefit/blocs/user/user_active_list_bloc.dart';
import 'package:sokefit/blocs/user/user_summary_bloc.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/models/user_summary.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_multi_select_dropdown_base_model_field.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnesignalScreen extends BaseUserScreen {
  List _selectedUsers;
  TextEditingController _controllerTotal = new TextEditingController();
  final UserSummaryBloc _userSummaryBloc = new UserActiveListBloc();
  final NotificationBloc _notificationBloc = new NotificationBloc();
  final _formKey = GlobalKey<FormState>();

  OnesignalScreen(UserModel userModel) : super(userModel);

  @override
   title() {
    return CustomText(
      'BİLDİRİM GÖNDER',
      fontWeight: FontWeight.bold,
      color: CustomColors.titleColor,
      fontSize: 20,
    );
  }

  @override
  Widget innerBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, left: 38.0, right: 38.0),
      child: createForm(context),
    );
  }

  Widget createForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        shrinkWrap: true,
        children: <Widget>[
          getUsers(),
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: CustomTextFormField(_controllerTotal,
                'Bildirim içeriğini giriniz', 'Bildirim içeriği boş olamaz',
                keyboardType: TextInputType.text, multiline: 5),
          ),
          Padding(padding: EdgeInsets.all(8),),
          GestureDetector(
              onTap: () => sendNotification(context),
              child: Image.asset('assets/images/send_notification.png'))
        ],
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

  sendNotification(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _notificationBloc.sendOneSignalNotification(
          _selectedUsers.map((e) => e.id).join(', '), _controllerTotal.text);
    }
  }

  @override
  init(BuildContext buildContext) {
    _userSummaryBloc.initUsers();
    _notificationBloc.stream.listen((event) {
      showResult(buildContext, event);
    });
  }


}
