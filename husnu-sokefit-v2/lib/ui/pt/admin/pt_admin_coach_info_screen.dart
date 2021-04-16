import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/pt/private_admin_bloc.dart';
import 'package:sokefit/blocs/pt/private_coach_purchase_bloc.dart';
import 'package:sokefit/blocs/pt/private_score_bloc.dart';
import 'package:sokefit/blocs/pt/private_user_event.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/models/coach_model.dart';
import 'package:sokefit/models/pt/private_admin_summary_model.dart';
import 'package:sokefit/models/pt/private_coach_purchase_model.dart';
import 'package:sokefit/models/pt/private_coach_purchase_pagination_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_date_picker_field.dart';
import 'package:sokefit/themes/custom_flat_button.dart';
import 'package:sokefit/themes/custom_pagination.dart';
import 'package:sokefit/themes/custom_progress_bar.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:sokefit/ui/formfields/coach_form_field.dart';
import 'package:sokefit/ui/formfields/user_photo_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base_screen.dart';

class PrivateAdminCoachInfoScreen extends BaseUserScreen {
  final PrivateAdminBloc _userBloc = new PrivateAdminBloc();
  final PrivateScoreBloc _scoreBloc = new PrivateScoreBloc();
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  UserModel _userModel;
  PrivateAdminSummaryModel _summaryModel;
  final PrivateCoachPurchaseBloc _bloc = new PrivateCoachPurchaseBloc();
  TextEditingController _queryController = new TextEditingController();

  PrivateAdminCoachInfoScreen(this._userModel) : super(_userModel);
  String _filteredPrice = '';
  String _filteredPrim = '';
  CoachModel _selectedCoach;
  var _formKey = new GlobalKey<FormState>();

  @override
  String title() {
    return null;
  }

  hideSubMenu() {
    return true;
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _userBloc,
      child: StreamBuilder<ApiEvent>(
          stream: _userBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
            if (!snapshot.hasData ||
                !(snapshot.data is PrivateAdminSummaryFinishedEvent))
              return CustomProgressBar();

            _summaryModel = (snapshot.data as PrivateAdminSummaryFinishedEvent)
                .summaryModel;

            return SingleChildScrollView(
              child: defaultInfo(context),
            );
          }),
    );
  }

  Widget defaultInfo(BuildContext context) {
    var bodyHeight =
        MediaQuery.of(context).size.height - BaseScreen.appBarHeight;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        partImage(context),
                      ],
                    ),
                    summary(context),
                  ],
                ),

                StreamBuilder<ApiEvent>(
                    stream: _bloc.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          !(snapshot.data is PaginationEvent))
                        return CustomProgressBarWave();

                      var paginationModel =
                          (snapshot.data as PaginationEvent).paginationModel;
                      var paginationModelPurchased = paginationModel
                          as PrivateCoachPurchasePaginationModel;
                      _filteredPrice = paginationModelPurchased.price;
                      _filteredPrim = paginationModelPurchased.prim;
                      return Column(
                        children: <Widget>[
                          filter(context),
                          SizedBox(
                            height: bodyHeight / 2.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: new CustomPagination<
                                          PrivateCoachPurchasePaginationModel>(
                                      key: UniqueKey(),
                                      bloc: _bloc,
                                      header: getHeader(),
                                      builder: (item) =>
                                          this.rowBuild(context, item),
                                      items: paginationModel.data.data),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget partImage(BuildContext context) {
    return UserPhotoField(_userModel.image);
  }

  Widget filter(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  CoachFormField(
                      selectedCoach: _selectedCoach,
                      onChanged: (item) {
                        _selectedCoach = item;
                        search(context);
                      }),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomDatePickerField(
                          _startDateController,
                          'Başlangıç',
                          null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                      ),
                      Expanded(
                          child: CustomDatePickerField(
                              _endDateController, 'Bitiş', null)),
                      Padding(
                        padding: EdgeInsets.all(8),
                      ),
                      Expanded(
                        child: CustomTextFormField(
                          _queryController,
                          'Üye Adı  İle',
                          null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: CustomFlatButton(
                          'Sorgula',
                          onPressed: () => search(context),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            CustomText(
                              'Toplam Fiyat: $_filteredPrice',
                              color: Colors.orange.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.right,
                            ),
                            CustomText(
                              'Prim: $_filteredPrim',
                              color: Colors.orange.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.right,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summary(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            children: [
              TableRow(children: [
                CustomText('SON ALINAN PT'),
                CustomText(
                  '${_summaryModel.latestDayCount} DERS',
                  color: CustomColors.orange,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                )
              ]),
              TableRow(children: [
                CustomText('SON ÜYE'),
                CustomText(
                  _summaryModel.latestUserFullName,
                  color: CustomColors.orange,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                )
              ]),
              TableRow(children: [
                CustomText('TOPLAM DERS'),
                CustomText(
                  _summaryModel.totalCourseCount.toString(),
                  color: CustomColors.orange,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                )
              ]),
              TableRow(children: [
                CustomText('KALAN DERS'),
                CustomText(
                  _summaryModel.remainingCourseCount.toString(),
                  color: CustomColors.orange,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                )
              ]),
              TableRow(children: [
                CustomText('GENEL TOPLAM'),
                CustomText(
                  '${_summaryModel.totalPaidPrice} TL',
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                  fontSize: 20,
                )
              ]),
            ],
          )),
    );
  }

  void init(BuildContext context) {
    _bloc.search(null, null, null, 1, 30, coachId: 1);
    _bloc.stream.listen((event) {
      showResult(context, event);
    });
    _userBloc.summary();
    _scoreBloc.stream.listen((event) {
      if (event is ApiSuccessEvent) {
      } else {
        showResult(context, event);
      }
    });
  }

  Widget rowBuild(
      BuildContext context, PrivateCoachPurchaseModel purchaseModel) {
    return Column(
      children: <Widget>[
        Divider(thickness: 1, color: Colors.white60),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: CustomText(
              DateHelper.getDateAsTurkish(purchaseModel.createdAt),
              textAlign: TextAlign.center,
            )),
            Expanded(
                child: CustomText(
              '${purchaseModel.dayCount} GÜN',
              textAlign: TextAlign.center,
            )),
            Expanded(
                child: CustomText(
              purchaseModel.user.name,
              textAlign: TextAlign.center,
            )),
            Expanded(
                child: CustomText(
              (purchaseModel.price / 100).toStringAsFixed(2) + " TL",
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ],
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: CustomText(
            'TARİH',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'PAKET',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'ÜYE',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'TUTAR',
            fontSize: 11,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  search(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var startDate = _startDateController.text;
      var endDate = _endDateController.text;
      var query = _queryController.text;
      _bloc.search(startDate, endDate, query, 1, 30,
          coachId: _selectedCoach.id);
    }
  }
}
