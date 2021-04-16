import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/coach/coach_bloc.dart';
import 'package:crossfit/blocs/coach/coach_event.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/dialog_confirm_helper.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/datatable_header_text.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoachSummaryScreen extends BaseUserScreen {
  final CoachBloc _bloc = new CoachBloc();
  final UserModel _userModel;

  CoachSummaryScreen(this._userModel) : super(_userModel);

  @override
   title() {
    return CustomText('ANTRENÖR LİSTESİ',
        color:CustomColors.titleColor,
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

              !(snapshot.data is ApiFinishedResponseModelEvent)) return CustomProgressBarWave();
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(padding: const EdgeInsets.all(16.0)),
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FittedBox(
                    child: DataTable(
                      columns: [
                        DataColumn(label: DataTableHeaderText('AD SOYAD')),
                        DataColumn(label: DataTableHeaderText('TELEFON')),
                        DataColumn(label: DataTableHeaderText('LEVEL')),
                        DataColumn(label: DataTableHeaderText('ORAN')),
                        DataColumn(label: DataTableHeaderText('İŞLEM')),
                      ],
                      rows: (snapshot.data as ApiFinishedResponseModelEvent)
                          .responseModel
                          .data
                          .map<DataRow>((item) {

                        return DataRow(
                          key: Key(item.id.toString()),
                          cells: <DataCell>[
                            DataCell(
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    item.name,
                                    fontSize: 15,
                                  )),
                            ),
                            DataCell(
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    item.phone,
                                    fontSize: 15,
                                  )),
                            ),
                            DataCell(
                              Align(
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    item.level.toString(),
                                    fontSize: 15,
                                  )),
                            ),
                            DataCell(
                              Align(
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    item.ratio??'',
                                    fontSize: 15,
                                  )),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => deleteCoach(context,item.id),
                                child: Align(
                                    alignment: Alignment.center,
                                    child:Icon(Icons.delete,color:Colors.white,size: 30,)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ))
              ]);
        },
      ),
    );
  }

  BoxDecoration myBoxDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
    );
  }

  void init(BuildContext context) {
    _bloc.initByLocationId(Constants.LOCATION_ID);
    _bloc.stream.listen((event) {
      showResult(context, event);
      if (event is ApiSuccessEvent) _bloc.init();
    });
  }


  deleteCoach(BuildContext context, int coachId) {
    ConfirmHelper.showConfirm(context, 'Silmek istediğinize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        _bloc.eventSink.add(new CoachDeleteEvent(coachId));
      }
    });
  }
}
