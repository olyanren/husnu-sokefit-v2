import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/coach/coach_bloc.dart';
import 'package:crossfit/blocs/location/location_bloc.dart';
import 'package:crossfit/blocs/location/location_event.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/location_model.dart';
import 'package:crossfit/themes/custom_dropdown_base_model_field.dart';
import 'package:crossfit/themes/custom_progress_bar.dart';
import 'package:crossfit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';

class LocationFormField extends BaseBlocScreen {
  final LocationBloc _locationBloc = new LocationBloc();
  Function onChanged;
  LocationModel selectedLocation;
  bool showAllOption;

  LocationFormField(
      {@required this.selectedLocation,
      @required this.onChanged,
      this.showAllOption = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _locationBloc,
      child: StreamBuilder(
          stream: _locationBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
            if (!snapshot.hasData ||
                snapshot.data is ApiFailedEvent)
              return CustomProgressBar();
            var locations = (snapshot.data as LocationFinishedEvent).locations;

            return CustomDropdownBaseModelField<LocationModel>(
              hintText: 'Lokasyon Seçiniz',
              selectedValue: selectedLocation,
              items: locations,
              emptyMessage: null,
              onChanged: (item) {
                selectedLocation = item;
                onChanged(item);
              },
            );
          }),
    );
  }

  @override
  void init(BuildContext context) {
    _locationBloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  @override
  void dispose() {
    _locationBloc.dispose();
  }
}
