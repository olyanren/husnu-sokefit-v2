import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/refresh_bloc.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/location_model.dart';
import 'package:sokefit/ui/base_bloc_screen.dart';
import 'package:sokefit/ui/formfields/location_form_field.dart';
import 'package:flutter/cupertino.dart';

import 'coach_form_field.dart';

class LocationWithCoachFormField extends BaseBlocScreen {
  RefreshBloc _refreshBloc = new RefreshBloc();
  Function onChanged;
  LocationModel selectedLocation;
  CoachModel selectedCoach;
  bool showCoachOptions = false;

  LocationWithCoachFormField(
      {@required this.selectedLocation,
      @required this.selectedCoach,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _refreshBloc,
      child: StreamBuilder(
          stream: _refreshBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
            return Column(
              children: [
                LocationFormField(
                    selectedLocation: selectedLocation,
                    onChanged: (item) {
                      selectedLocation = item;
                      showCoachOptions = true;
                      selectedCoach = null;
                      _refreshBloc.refresh();
                    }),
                showCoachOptions
                    ? CoachFormField(
                        key: UniqueKey(),
                        locationId: selectedLocation.id,
                        selectedCoach: selectedCoach,
                        onChanged: (item) {
                          selectedCoach = item;
                          onChanged(selectedLocation, selectedCoach);
                        })
                    : Container(),
              ],
            );
          }),
    );
  }

  @override
  void init(BuildContext context) {}

  @override
  void dispose() {}
}
