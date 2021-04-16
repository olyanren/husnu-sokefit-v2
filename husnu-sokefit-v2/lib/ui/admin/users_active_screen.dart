import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/user/notification_bloc.dart';
import 'package:crossfit/blocs/user/user_active_list_bloc.dart';
import 'package:crossfit/blocs/user/user_summary_bloc.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/models/user_pagination_model.dart';
import 'package:crossfit/models/user_summary.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_pagination.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/custom_text_form_field.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserActiveScreen extends BaseUserScreen {
  final UserSummaryBloc _bloc = new UserActiveListBloc();
  final NotificationBloc _smsBloc = new NotificationBloc();
  final UserModel _userModel;
  final TextEditingController _searchController = new TextEditingController();
  final FocusNode _focusNode = new FocusNode();

  UserActiveScreen(this._userModel) : super(_userModel);

  @override
  title() {
    return CustomText('AKTİF ÜYELER',
        color: CustomColors.titleColor,
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _bloc,
      child: StreamBuilder(
        stream: _bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
          if (!snapshot.hasData || !(snapshot.data is PaginationEvent))
            return CustomProgressBarWave();
          var paginationModel =
              (snapshot.data as PaginationEvent).paginationModel;

          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(16.0)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                          child: CustomText(
                        'ÜYE SAYISI',
                        color: Colors.orange.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                      CustomText(
                        paginationModel.data.total.toString(),
                        fontSize: 20,
                        color: Colors.orange.shade800,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomTextFormField(
                          _searchController,
                          'Arama Yap',
                          null,
                          borderRadius: 50,
                          focusNode: _focusNode,
                          leftIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          rightIcon: GestureDetector(
                              onTap: () => {_searchController.text = ''},
                              child: Icon(Icons.close, color: Colors.white)),
                          fullBorder: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: new CustomPagination<UserPaginationModel>(
                      key: UniqueKey(),
                      bloc: _bloc,
                      header: getHeader(),
                      builder: (item) => this.rowBuild(context, item),
                      items: paginationModel.data.data),
                )
              ]);
        },
      ),
    );
  }

  void init(BuildContext context) {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        search(context, _searchController.text);
      }
    });
    _bloc.loadActiveUsers(1, 30);
    _bloc.stream.listen((event) {
      showResult(context, event);
    });
    _smsBloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  Widget rowBuild(BuildContext context, UserSummary userSummary) {
    return Column(
      children: <Widget>[
        Divider(thickness: 1, color: Colors.white60),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: CustomText(
              userSummary.name,
              fontSize: 10,
            )),
            Expanded(
                child: CustomText(
              userSummary.phone,
              fontSize: 10,
            )),
            Expanded(
                child: CustomText(
                  userSummary.remainingDay.toString(),
                  fontSize: 10,
                )),
            GestureDetector(
                onTap: () => this.sendSms(context, userSummary),
                child: Icon(
                  Icons.textsms,
                  color: Colors.white,
                )),
          ],
        ),
      ],
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomText(
          'Üye',
          fontSize: 13,
          color: Colors.amber,
        ),
        CustomText(
          'Telefon',
          fontSize: 13,
          color: Colors.amber,
        ),
        CustomText(
          'Kalan',
          fontSize: 13,
          color: Colors.amber,
        ),
        CustomText(
          'İşlem',
          fontSize: 13,
          color: Colors.amber,
        ),
      ],
    );
  }

  void sendSms(BuildContext context, UserSummary userSummary) {
    ConfirmHelper.showConfirm(
            context, 'Sms göndermek istediğinize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        _smsBloc.sendSms(userSummary.id.toString(),
            'Sayın ${userSummary.name}, Üyeliğiniz ${userSummary.remainingDay} '
                'gün sonra bitecektir. '
                'Üyeliğinizi Crossfit Backstreet uygulamamız üzerinden yenileyebilirsiniz.');
      }
    });
  }

  void search(BuildContext context, String query) {
    _bloc.searchActiveUsers(query, 1, 30);
  }
}
