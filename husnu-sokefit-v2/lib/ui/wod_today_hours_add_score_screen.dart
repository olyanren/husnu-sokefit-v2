import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/wods/today_wod_hours_detail_bloc.dart';
import 'package:crossfit/blocs/wods/wod_event.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/today_hour_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_dropdown_field.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/custom_text_form_field.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WodTodayHoursAddScoreScreen extends BaseUserScreen {
  final _formKey = GlobalKey<FormState>();
  TodayWodHoursDetailBloc _bloc;
  UserModel _userModel;
  BuildContext _buildContext;
  TodayHourModel _todayHourModel;
  String _selectedCategory;
  List<String> _categories = ['S1', 'S2', 'RX'];
  final TextEditingController _scoreController = TextEditingController();

  WodTodayHoursAddScoreScreen(this._userModel, this._todayHourModel)
      : super(_userModel) {
    _bloc = new TodayWodHoursDetailBloc(_todayHourModel.updatedAt);
  }

  @override
   title() {
    return CustomText('SKOR GİRİŞİ',
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
          if (!snapshot.hasData || snapshot.data is ApiStartedEvent)
            return Container();
          return SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                CustomText(
                                  this._todayHourModel.hour,
                                  color: Colors.yellow.shade800,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText('WOD')
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  this._todayHourModel.total.toString(),
                                  color: Colors.yellow.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText('TOPLAM')
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  this
                                      ._todayHourModel
                                      .registerUserCount
                                      .toString(),
                                  color: Colors.yellow.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText('KATILIM')
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  this
                                      ._todayHourModel
                                      .remainingUserCount
                                      .toString(),
                                  color: Colors.yellow.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText('KALAN')
                              ],
                            )
                          ],
                        ),
                        createForm(context)
                      ])
                ]),
          );
        },
      ),
    );
  }

  Widget createForm(BuildContext buildContext) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(top: 10.0),
            shrinkWrap: true,
            children: [
              CustomDropdownField('Kategori Seçiniz', _selectedCategory,
                  'Kategori seçiniz', _categories, (selectedCategory) {
                _selectedCategory = selectedCategory;
                _bloc.refresh();
              }),
              CustomTextFormField(_scoreController, 'Skor bilgisini giriniz',
                  'Skor bilgisi girilmelidir'),
              GestureDetector(
                  onTap: () => addScore(buildContext),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Image.asset('assets/images/score_save.png'),
                  )),
            ],
          )),
    );
  }

  void init(BuildContext context) {
    _bloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  void addScore(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var updatedAt = this._todayHourModel.updatedAt;
      ConfirmHelper.showConfirm(
              context, 'Skor bilgisi kaydedilecektir. Onaylıyor musunuz?')
          .then((result) {
        if (result == ConfirmAction.ACCEPT) {
          _bloc.addScore(updatedAt, _selectedCategory, _scoreController.text);
        }
      });
    }
  }

  void showResult(BuildContext context, ApiEvent event) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (event is ApiFailedEvent) {
      AlertHelper.showToast(context, 'Hata Oluştu', event.message);
    } else if (event is ApiScoreSavedEvent) {
      AlertHelper.showToast(context, 'İşlem Sonucu',
          'Skor bilgisi başarılı bir şekilde kaydedildi/güncellendi.');
    }
  }
}
