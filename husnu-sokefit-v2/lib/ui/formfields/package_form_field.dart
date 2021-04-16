import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/pt/private_package_bloc.dart';
import 'package:sokefit/models/pt/private_package_model.dart';
import 'package:sokefit/themes/custom_dropdown_base_model_field.dart';
import 'package:sokefit/themes/custom_progress_bar.dart';
import 'package:sokefit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';

class PackageFormField extends BaseBlocScreen{
  final PrivatePackageBloc _packageBloc = new PrivatePackageBloc();
  Function onChanged;
  PrivatePackageModel selectedPackage;
  PackageFormField({@required this.selectedPackage,@required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _packageBloc,
      child: StreamBuilder(
          stream: _packageBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
            if (!snapshot.hasData ||
                snapshot.data is ApiFailedEvent ||
                snapshot.data is ApiStartedEvent) return CustomProgressBar();

            List<PrivatePackageModel> users =
            (snapshot.data as ApiFinishedResponseModelEvent)
                .responseModel
                .data;


            return CustomDropdownBaseModelField<PrivatePackageModel>(
              hintText: 'PT Paket Seçiniz',
              selectedValue: selectedPackage,
              items: users,
              emptyMessage: 'Bu alan boş olamaz',
              onChanged: (item) {
                selectedPackage = item;
                onChanged(item);
              },
            );
          }),
    );
  }

  @override
  void init(BuildContext context) {
    _packageBloc.stream.listen((event) {
      showResult(context,event);
    });
  }

  @override
  void dispose() {
    _packageBloc.dispose();
  }
}