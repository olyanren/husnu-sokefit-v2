import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/coach/coach_bloc.dart';
import 'package:crossfit/blocs/wods/today_wod_create_bloc.dart';
import 'package:crossfit/helpers/alert_helper.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_date_picker_field.dart';
import 'package:crossfit/themes/custom_dropdown_base_model_field.dart';
import 'package:crossfit/themes/custom_dropdown_field.dart';
import 'package:crossfit/themes/custom_progress_bar.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/custom_text_form_field.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WodHourCreateScreen extends BaseUserScreen {
  TextEditingController _datePickerController = new TextEditingController();

  String _selectedHour;
  CoachModel _selectedCoach;
  TextEditingController _controllerTotal = new TextEditingController();
  final List<String> _days = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar'
  ];
  final List<String> _hours = [
    '06.00',
    '06.30',
    '07.00',
    '07.30',
    '08.00',
    '08.30',
    '09.00',
    '09.30',
    '10.00',
    '10.30',
    '11.00',
    '11.30',
    '12.00',
    '12.30',
    '13.00',
    '13.30',
    '14.00',
    '14.30',
    '15.00',
    '15.30',
    '16.00',
    '16.30',
    '17.00',
    '17.30',
    '18.00',
    '18.30',
    '19.00',
    '19.30',
    '20.00',
    '20.30',
    '21.00',
    '21.30',
    '22.00',
    '22.30',
    '23.00',
    '23.30',
  ];

  final TodayWodCreateBloc _todayWodCreateBloc = new TodayWodCreateBloc();
  final _formKey = GlobalKey<FormState>();
  final CoachBloc _coachBloc = new CoachBloc();

  WodHourCreateScreen(UserModel userModel) : super(userModel);

  @override
   title() {
    return CustomText(
      'WOD SAATLERİ TANIMLAMA',
      fontWeight: FontWeight.bold,
      color: CustomColors.titleColor,
      fontSize: 20,
    );
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _todayWodCreateBloc,
      child: StreamBuilder(
        stream: _todayWodCreateBloc.stream,
        builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
          return Padding(
            padding: const EdgeInsets.only(top: 28, left: 38.0, right: 38.0),
            child: Column(children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(10),
              ),
              createForm(context)
            ]),
          );
        },
      ),
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
            CustomDatePickerField(
                _datePickerController, 'Tarih Seçiniz', 'Tarih kısmı boş olamaz'),

            CustomDropdownField(
                'Saati Seçiniz', _selectedHour, 'Saati Seçiniz', _hours,
                (selectedCategory) {
              _selectedHour = selectedCategory;
              _todayWodCreateBloc.refresh();
            }),
            CustomTextFormField(
                _controllerTotal,
                'Sayı Giriniz (0 silme anlamına gelir)',
                'Kişi sayısı boş olamaz',
                keyboardType: TextInputType.number),
            getCoaches(),
            Padding(
              padding: const EdgeInsets.all(10),
            ),
            GestureDetector(
                onTap: () => saveWodHour(context),
                child: Image.asset('assets/images/add.png'))
          ],
        ),
      ),
    );
  }

  getCoaches() {
    return BlocBuilder(
        root: this,
        bloc: _coachBloc,
        child: StreamBuilder(
            stream: _coachBloc.stream,
            builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data is ApiFailedEvent ||
                  snapshot.data is ApiStartedEvent) return CustomProgressBar();

              List<CoachModel> users =
                  (snapshot.data as ApiFinishedResponseModelEvent)
                      .responseModel
                      .data;

              return CustomDropdownBaseModelField<CoachModel>(
                hintText: 'Antrenör Seçiniz',
                selectedValue: _selectedCoach,
                items: users,
                onChanged: (item) {
                  _selectedCoach = item;
                },
              );
            }));
  }

  saveWodHour(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _todayWodCreateBloc.saveWodHour(_datePickerController.text, _selectedHour,
          int.parse(_controllerTotal.text), _selectedCoach.id);
    }
  }

  @override
  init(BuildContext buildContext) {
    _todayWodCreateBloc.stream.listen((event) {
      showResult(buildContext, event);
    });
  }

  void showResult(BuildContext context, ApiEvent event) {
    if (event is ApiFailedEvent) {
      AlertHelper.showToast(context, 'Hata Oluştu', event.message);
    } else if (event is ApiFinishedResponseModelEvent) {
      AlertHelper.showToast(context, 'Sonuç', event.responseModel.message);
    }
  }
}
