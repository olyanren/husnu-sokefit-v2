import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/course/course_bloc.dart';
import 'package:crossfit/blocs/pt/private_admin_events.dart';
import 'package:crossfit/blocs/pt/private_schedule_bloc.dart';
import 'package:crossfit/blocs/pt/private_schedule_event.dart';
import 'package:crossfit/blocs/refresh_bloc.dart';
import 'package:crossfit/helpers/date_helper.dart';
import 'package:crossfit/models/base_model.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/pt/hour_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_container.dart';
import 'package:crossfit/themes/custom_date_picker_field.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/formfields/coach_form_field.dart';
import 'package:crossfit/ui/formfields/course_list_field.dart';
import 'package:crossfit/ui/pt/base_pt_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrivateCourseListScreen extends BasePrivateScreen {
  PrivateCourseListScreen(UserModel userModel) : super(userModel);
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CoachModel _selectedCoach;

  CourseBloc _courseBloc = new CourseBloc();
  var _refreshBloc = new RefreshBloc();

  @override
  void init(BuildContext context) {

    _courseBloc.stream.listen((event) {
      showResult(context, event);
      if (event is ApiSuccessEvent) _refreshBloc.refresh();
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
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: CoachFormField(
                                      selectedCoach: _selectedCoach,
                                      onChanged: (item) {
                                        _selectedCoach = item;

                                      },
                                      showAllOption: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () => search(context),
                                        child: Container(
                                          padding: EdgeInsets.only(top:10),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: Image.asset(
                                              'assets/images/search.png'),
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CourseListField(
                    key: UniqueKey(),
                    coachId:_selectedCoach==null?-1: _selectedCoach.id,
                    startDate:_startDateController.text,
                    endDate:_endDateController.text,
                  )
                ],
              ),
            );
          }),
    );
  }

  @override
  title() {
    return 'Derslerim';
  }

  search(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _refreshBloc.refresh();
    }
  }
}
