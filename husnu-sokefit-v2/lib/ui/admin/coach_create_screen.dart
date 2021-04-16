import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/coach/coach_bloc.dart';
import 'package:sokefit/blocs/location/location_bloc.dart';
import 'package:sokefit/blocs/location/location_event.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/location_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_dropdown_package_model_field.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/themes/size_config.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoachCreateScreen extends BaseUserScreen {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _levelController = new TextEditingController();
  TextEditingController _ratioController = new TextEditingController();

  final CoachBloc _coachBloc = new CoachBloc();
  final _formKey = GlobalKey<FormState>();
  LocationBloc _locationBloc = new LocationBloc();
  var _refreshBloc = new RefreshBloc();
  LocationModel _locationModel;

  CoachCreateScreen(UserModel userModel) : super(userModel);

  @override
  title() {
    return CustomText(
      'ANTRENÖR TANIMLAMA',
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
        BlocBuilder(root: this, bloc: _refreshBloc, child: createForm(context))
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
            CustomTextFormField(
                _nameController, 'Adı Soyadı', 'Ad soyad kısmı boş olamaz',
                keyboardType: TextInputType.text),
            CustomTextFormField(
                _phoneController, 'Telefon No', 'Telefon numarası boş olamaz',
                keyboardType: TextInputType.phone),
            CustomTextFormField(
                _emailController, 'E-Posta Adresi', 'E-Posta adresi boş olamaz',
                keyboardType: TextInputType.emailAddress),
            CustomTextFormField(
                _levelController, 'CF Level', 'Level kısmı boş olamaz',
                keyboardType: TextInputType.text),
            CustomTextFormField(_ratioController, 'Yüzde Tanımlama (%)',
                'Yüzde kısmı boş olamaz',
                keyboardType: TextInputType.text),
            StreamBuilder(
                stream: _locationBloc.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
                  if (!snapshot.hasData ||
                      !(snapshot.data is LocationFinishedEvent))
                    return Container();
                  return CustomDropdownPackageModelField<LocationModel>(
                      'Lokasyon Seçimi',
                      _locationModel,
                      'Lütfen lokasyon seçiniz',
                      (snapshot.data as LocationFinishedEvent).locations,
                      (LocationModel locationModel) {
                    _locationModel = locationModel;
                    _locationBloc.refresh();
                  });
                }),
            GestureDetector(
                onTap: () => createCoach(context),
                child: Image.asset('assets/images/add.png'))
          ],
        ),
      ),
    );
  }

  createCoach(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var coachModel = new CoachModel();
      coachModel.name = _nameController.text;
      coachModel.phone = _phoneController.text;
      coachModel.email = _emailController.text;
      coachModel.level = _levelController.text;
      coachModel.ratio = _ratioController.text;
      coachModel.locationId = _locationModel.id;
      _coachBloc.createCoach(coachModel);
    }
  }

  @override
  init(BuildContext buildContext) {
    _coachBloc.stream.listen((event) {
      showResult(buildContext, event);
    });

    _locationBloc.stream.listen((event) {
      showResult(buildContext, event);
      if (event is ApiSuccessEvent) _locationBloc.init();
    });
    _locationBloc.init();
  }
}
