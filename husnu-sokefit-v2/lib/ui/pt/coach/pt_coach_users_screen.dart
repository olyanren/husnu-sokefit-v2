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
import 'package:sokefit/ui/formfields/coach_course_user_list_field.dart';

import 'package:sokefit/ui/formfields/coach_form_field.dart';
import 'package:sokefit/ui/pt/base_pt_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrivateCoachUsersScreen extends BasePrivateScreen {
  PrivateCoachUsersScreen(UserModel userModel) : super(userModel);

  TextEditingController _userFullNameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PrivateScheduleBloc _scheduleBloc = new PrivateScheduleBloc();
  CourseBloc _courseBloc = new CourseBloc();
  var _refreshBloc = new RefreshBloc();

  @override
  void init(BuildContext context) {

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
                                    child: CustomTextFormField(
                                      _userFullNameController,
                                      'Üye Adı ile Arama Yap',
                                      null,
                                      fullBorder: false,
                                      borderRadius: 2,
                                    ),
                                  ),
                                  CustomFlatButton(
                                    'Ara',
                                    onPressed: () => search(context),
                                    paddingTop: 10,
                                    paddingLeft: 8,
                                  ),
                                ],
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20),),
                  CoachCourseUserListField(
                      key: UniqueKey(),
                      startDate: null,
                      endDate: DateHelper.getDateAsTurkish(null,1000),
                      query: _userFullNameController.text)
                ],
              ),
            );
          }),
    );
  }

  @override
  title() {
    return 'Üyeler';
  }

  search(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _refreshBloc.refresh();
    }
  }
}
