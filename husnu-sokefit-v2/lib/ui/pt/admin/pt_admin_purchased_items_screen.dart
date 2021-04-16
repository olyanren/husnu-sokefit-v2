import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/pt/private_purchase_bloc.dart';
import 'package:sokefit/blocs/pt/private_user_bloc.dart';
import 'package:sokefit/blocs/pt/private_user_event.dart';
import 'package:sokefit/helpers/date_helper.dart';
import 'package:sokefit/models/pt/private_purchase_model.dart';
import 'package:sokefit/models/pt/private_user_summary_model.dart';
import 'package:sokefit/models/pt/purchase_pagination_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_pagination.dart';
import 'package:sokefit/themes/custom_progress_bar.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:sokefit/ui/formfields/user_photo_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base_screen.dart';

class PrivateAdminPurchasedItemsScreen extends BaseUserScreen {
  final PrivatePurchaseBloc _bloc = new PrivatePurchaseBloc();
  PrivateUserSummaryModel _summaryModel;
  final PrivateUserBloc _userBloc = new PrivateUserBloc();
  int userId;

  PrivateAdminPurchasedItemsScreen(userModel, this.userId) : super(userModel);

  @override
  title() {
    return CustomText('Satın Alınan Öğeler',
        color: CustomColors.turquoise,
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  @override
  Widget innerBody(BuildContext context) {
    var bodyHeight =
        MediaQuery.of(context).size.height - BaseScreen.appBarHeight;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            partImage(context),
            Expanded(child: summary(context)),
          ],
        ),
        BlocBuilder(
          root: this,
          bloc: _bloc,
          child: StreamBuilder(
            stream: _bloc.stream,
            builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
              if (!snapshot.hasData || !(snapshot.data is PaginationEvent))
                return CustomProgressBarWave();
              var paginationModel =
                  (snapshot.data as PaginationEvent).paginationModel;
              var paginationModelPurchased =
                  paginationModel as PrivatePurchasePaginationModel;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.all(16.0)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Center(
                              child: CustomText(
                            'TOPLAM FİYAT',
                            color: Colors.orange.shade800,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                          CustomText(
                            paginationModelPurchased.price.toString(),
                            fontSize: 20,
                            color: Colors.orange.shade800,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        height: bodyHeight / 2.4,
                        child: new CustomPagination<
                                PrivatePurchasePaginationModel>(
                            key: UniqueKey(),
                            bloc: _bloc,
                            header: getHeader(),
                            builder: (item) => this.rowBuild(context, item),
                            items: paginationModel.data.data)),
                  ]);
            },
          ),
        ),
      ],
    );
  }

  Widget partImage(BuildContext context) {
    return UserPhotoField();
  }

  Widget summary(BuildContext context) {
    return StreamBuilder<ApiEvent>(
        stream: _userBloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              !(snapshot.data is PrivateUserSummaryFinishedEvent))
            return CustomProgressBar();

          _summaryModel =
              (snapshot.data as PrivateUserSummaryFinishedEvent).summaryModel;

          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                children: [
                  TableRow(children: [
                    CustomText('KAYIT TARİHİ'),
                    CustomText(
                      _summaryModel.registerDate,
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                  TableRow(children: [
                    CustomText('SON ALINAN PT'),
                    CustomText(
                      '${_summaryModel.lastDayCount} DERS',
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                  TableRow(children: [
                    CustomText('KOÇ'),
                    CustomText(
                      _summaryModel.coach,
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                  TableRow(children: [
                    CustomText('TOPLAM DERS'),
                    CustomText(
                      _summaryModel.totalDays.toString(),
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                  TableRow(children: [
                    CustomText('KALAN DERS'),
                    CustomText(
                      _summaryModel.remainingDayCount.toString(),
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                  TableRow(children: [
                    CustomText('İPTAL DERS'),
                    CustomText(
                      _summaryModel.cancelledDayCount.toString(),
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                  TableRow(children: [
                    CustomText('GELDİ'),
                    CustomText(
                      _summaryModel.availableDayCount.toString(),
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                  TableRow(children: [
                    CustomText('GELMEDİ'),
                    CustomText(
                      _summaryModel.absentDayCount.toString(),
                      color: CustomColors.orange,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    )
                  ]),
                ],
              ));
        });
  }

  void init(BuildContext context) {
    _userBloc.summary(userId: this.userId);
    _bloc.loadPurchasedItems(1, 30, userId: this.userId);
    _bloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  Widget rowBuild(BuildContext context, PrivatePurchaseModel purchaseModel) {
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
              purchaseModel.coach.name,
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
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'PAKET',
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'KOÇ',
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'TUTAR',
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
