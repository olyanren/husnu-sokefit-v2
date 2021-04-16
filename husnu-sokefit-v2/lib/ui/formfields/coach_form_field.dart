import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/coach/coach_bloc.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/themes/custom_dropdown_base_model_field.dart';
import 'package:crossfit/themes/custom_progress_bar.dart';
import 'package:crossfit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';

class CoachFormField extends BaseBlocScreen {
  final CoachBloc _coachBloc = new CoachBloc();
  Function onChanged;
  CoachModel selectedCoach;
  bool showAllOption;
  int locationId;
  Key key;

  CoachFormField(
      {this.key,
      this.locationId,
      @required this.selectedCoach,
      @required this.onChanged,
      this.showAllOption = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      key: key,
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
            var isAllOptionExist = users != null &&
                users.length != 0 &&
                users.where((element) => element.id == -1).length != 0;

            if (showAllOption && !isAllOptionExist) {
              var coachModel = CoachModel();
              coachModel.id = -1;
              coachModel.name = 'Hepsi';
              users.insert(0, coachModel);
            }

            return CustomDropdownBaseModelField<CoachModel>(
              hintText: 'Antrenör Seçiniz',
              selectedValue: selectedCoach,
              items: users,
              emptyMessage: null,
              onChanged: (item) {
                selectedCoach = item;
                onChanged(item);
              },
            );
          }),
    );
  }

  @override
  void init(BuildContext context) {
    if (locationId == null) locationId = Constants.LOCATION_ID;
    _coachBloc.initByLocationId(locationId);
    _coachBloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  @override
  void dispose() {
    _coachBloc.dispose();
  }
}
