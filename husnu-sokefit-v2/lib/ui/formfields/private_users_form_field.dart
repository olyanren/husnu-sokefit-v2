import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/user/user_bloc.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/custom_dropdown_base_model_field.dart';
import 'package:sokefit/themes/custom_progress_bar.dart';
import 'package:sokefit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';

class PrivateUsersFormField extends BaseBlocScreen{
  final UserBloc _bloc = new UserBloc();
  Function onChanged;
  UserModel selectedUser;
  PrivateUsersFormField({@required this.selectedUser,@required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _bloc,
      child: StreamBuilder(
          stream: _bloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
            if (!snapshot.hasData ||
                snapshot.data is ApiFailedEvent ||
                snapshot.data is ApiStartedEvent) return CustomProgressBar();

            List<UserModel> users =
            (snapshot.data as ApiFinishedResponseModelEvent)
                .responseModel
                .data;


            return CustomDropdownBaseModelField<UserModel>(
              hintText: 'Kullanıcı Seçiniz',
              selectedValue: selectedUser,
              items: users,
              emptyMessage: 'Bu alan boş olamaz',
              onChanged: (item) {
                selectedUser = item;
                onChanged(item);
              },
            );
          }),
    );
  }

  @override
  void init(BuildContext context) {
    _bloc.loadPrivateUsers();
    _bloc.stream.listen((event) {
      showResult(context,event);
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
  }
}