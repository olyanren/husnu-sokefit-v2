import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/course/course_bloc.dart';
import 'package:sokefit/blocs/pt/private_admin_events.dart';
import 'package:sokefit/blocs/pt/private_schedule_bloc.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/models/base_model.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/pt/hour_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/custom_container.dart';
import 'package:sokefit/themes/custom_date_picker_field.dart';
import 'package:sokefit/ui/formfields/coach_form_field.dart';
import 'package:sokefit/ui/formfields/course_available_list_field.dart';
import 'package:sokefit/ui/pt/base_pt_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrivateCourseRegisterScreen extends BasePrivateScreen {
  PrivateCourseRegisterScreen(UserModel userModel) : super(userModel);

  final _formKey = GlobalKey<FormState>();
  List<BaseModel> _hours = [];
  HourModel _selectedHour;
  PrivateScheduleBloc _scheduleBloc = new PrivateScheduleBloc();
  CourseBloc _courseBloc = new CourseBloc();
  var _refreshBloc = new RefreshBloc();
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  CoachModel _selectedCoach;

  @override
  void init(BuildContext context) {
    _courseBloc.stream.listen((event) {
      showResult(context, event);
      if (event is ApiSuccessEvent) _refreshBloc.refresh();
    });

    _scheduleBloc.stream.listen((event) {
      if (event is LoadPrivateScheduleFinishedEvent) {
        _hours = event.hours;
        _refreshBloc.refresh();
      } else {
        showResult(context, event);
      }
    });
  }

  void loadAvailableHours() {
    _refreshBloc.refresh();
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
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                        onTap: () => loadAvailableHours(),
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
                  CourseAvailableListField(
                    key: UniqueKey(),
                    coachId:_selectedCoach==null?-1: _selectedCoach.id,
                    startDate: _startDateController.text,
                    endDate: _endDateController.text,
                  )
                ],
              ),
            );
          }),
    );
  }

  @override
  title() {
    return 'Antrenör Ders Seçimi';
  }


}
