import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/pt/private_purchase_bloc.dart';
import 'package:crossfit/helpers/date_helper.dart';
import 'package:crossfit/models/pt/private_purchase_model.dart';
import 'package:crossfit/models/pt/purchase_pagination_model.dart';
import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_pagination.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_pt_screen.dart';


class PrivatePurchasedItemsScreen extends BasePrivateScreen {
  final PrivatePurchaseBloc _bloc = new PrivatePurchaseBloc();

  PrivatePurchasedItemsScreen(userModel) : super(userModel);

  @override
  title() {
    return 'Satın Alınan Dersler';
  }

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
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
                Expanded(
                  child: new CustomPagination<PrivatePurchasePaginationModel>(
                      key: UniqueKey(),
                      bloc: _bloc,
                      header: getHeader(),
                      builder: (item) => this.rowBuild(context, item),
                      items: paginationModel.data.data),
                )
              ]);
        },
      ),
    );
  }

  void init(BuildContext context) {
    _bloc.loadPurchasedItems(1, 30);
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
            'Tarih',
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'Paket',
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'Antrenör',
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            'Tutar',
            fontSize: 13,
            color: CustomColors.orange,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
