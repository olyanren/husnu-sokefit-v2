import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/wods/today_wod_hours_bloc.dart';
import 'package:sokefit/blocs/wods/wod_list_bloc.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/today_hour_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/models/wod_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/datatable_header_text.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:sokefit/ui/wod_today_hours_detail_screen.dart';
import 'package:sokefit/ui/wod_today_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WodListScreen extends BaseUserScreen {
  WodListBloc _bloc = new WodListBloc();
  UserModel _userModel;

  WodListScreen(this._userModel) : super(_userModel);

  @override
  title() {
    return CustomText('TÜM WOD LİSTESİ',
        color: CustomColors.titleColor,
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _bloc,
      child: StreamBuilder(
        stream: _bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
          if (!snapshot.hasData ||
              snapshot.data is ApiFailedEvent ||
              snapshot.data is ApiStartedEvent) return CustomProgressBarWave();
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(16.0)),
                Padding(padding: const EdgeInsets.all(16.0)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: DataTable(
                        dataRowHeight: 70,
                        columns: [
                          DataColumn(label: DataTableHeaderText('WOD GÜNÜ')),
                        ],
                        rows: (snapshot.data as ApiFinishedResponseModelEvent)
                            .responseModel
                            .data
                            .map<DataRow>((item) {
                          var model = WodModel.fromJson(item);
                          return DataRow(
                            key: Key(model.id.toString()),
                            cells: <DataCell>[
                              DataCell(
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      model.day,
                                      textDecoration: TextDecoration.none,
                                      fontSize: 20,
                                    )),
                                onTap: () {
                                  goToWodDetailScreen(
                                      context, _userModel, model);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              ]);
        },
      ),
    );
  }

  void init(BuildContext context) {
    _bloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  void goToWodDetailScreen(
      BuildContext context, UserModel userModel, WodModel wodModel) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            WodTodayScreen(userModel, wodModel)));
  }

  void showResult(BuildContext context, ApiEvent event) {
    if (event is ApiFailedEvent) {
      AlertHelper.showToast(context, 'Hata Oluştu', event.message);
    }
  }
}
