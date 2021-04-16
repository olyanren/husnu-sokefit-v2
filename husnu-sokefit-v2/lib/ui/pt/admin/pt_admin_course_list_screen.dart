import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/course/course_bloc.dart';
import 'package:sokefit/blocs/pt/private_admin_events.dart';
import 'package:sokefit/blocs/pt/private_schedule_bloc.dart';
import 'package:sokefit/blocs/pt/private_schedule_event.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_container.dart';
import 'package:sokefit/themes/custom_date_picker_field.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/ui/formfields/coach_course_edit_field.dart';
import 'package:sokefit/ui/formfields/coach_course_list_field.dart';
import 'package:sokefit/ui/formfields/coach_form_field.dart';
import 'package:sokefit/ui/pt/base_pt_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrivateAdminCourseListScreen extends BasePrivateScreen {
  PrivateAdminCourseListScreen(UserModel userModel) : super(userModel);
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  TextEditingController _userFullNameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PrivateScheduleBloc _scheduleBloc = new PrivateScheduleBloc();
  CourseBloc _courseBloc = new CourseBloc();
  var _refreshBloc = new RefreshBloc();
  CoachModel _selectedCoach;

  @override
  void init(BuildContext context) {
    _startDateController.text = DateHelper.getDateAsTurkish(null, -30);
    _endDateController.text = DateHelper.getDateAsTurkish(null, 0);
    _courseBloc.stream.listen((event) {
      showResult(context, event);
      if (event is ApiSuccessEvent) _refreshBloc.refresh();
    });

    _scheduleBloc.stream.listen((event) {
      if (event is LoadPrivateScheduleFinishedEvent) {
        _refreshBloc.refresh();
      } else {
        showResult(context, event);
      }
    });
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _refreshBloc,
      child: StreamBuilder<ApiEvent>(
          stream: _refreshBloc.stream,
          builder: (context, snapshot) {
            return CustomContainer(
              padding: 8,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: CustomDatePickerField(
                                        _startDateController,
                                        'Başlangıç Tarihi',
                                        'Lütfen tarihi seçiniz'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                  ),
                                  Expanded(
                                    child: CustomDatePickerField(
                                        _endDateController,
                                        'Bitiş Tarihi',
                                        null),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                  ),
                                  CustomFlatButton(
                                    'Ara',
                                    onPressed: () => search(context),
                                    paddingTop: 10,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:8.0,top:0),
                                      child: CoachFormField(
                                          selectedCoach: _selectedCoach,
                                          onChanged: (item) {
                                            _selectedCoach = item;
                                            search(context);
                                          }),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTextFormField(
                                      _userFullNameController,
                                      'Üye Adı ile Arama Yap',
                                      null,
                                      fullBorder: false,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _selectedCoach == null
                      ? Container()
                      : CoachCourseListField(
                          key: UniqueKey(),
                          startDate: _startDateController.text,
                          endDate: _endDateController.text,
                          query: _userFullNameController.text,
                          coachId: _selectedCoach.id)
                ],
              ),
            );
          }),
    );
  }

  @override
  title() {
    return 'Aylık Dersler';
  }

  search(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _refreshBloc.refresh();
    }
  }
}
