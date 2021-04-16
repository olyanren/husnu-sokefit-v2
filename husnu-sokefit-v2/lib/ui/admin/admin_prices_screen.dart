import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc_builder.dart';
import 'package:sokefit/blocs/package/package_bloc.dart';
import 'package:sokefit/blocs/package/package_event.dart';
import 'package:sokefit/helpers/dialog_confirm_helper.dart';
import 'package:sokefit/models/package_model.dart';
import 'package:sokefit/models/user_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_progress_bar_wave.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/ui/base_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPricesScreen extends BaseUserScreen {
  AdminPricesScreen(UserModel userModel) : super(userModel);
  final PackageBloc _bloc = new PackageBloc();

  @override
  title() {
    return CustomText(
      'ÜYELİK ÜCRETLERİ',
      fontWeight: FontWeight.bold,
      color: CustomColors.titleColor,
      fontSize: 20,
    );
  }

  @override
  Widget innerBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, left: 38.0, right: 38.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[getPrices()],
      ),
    );
  }

  Widget getPrices() {
    return BlocBuilder(
      root: this,
      bloc: _bloc,
      child: StreamBuilder(
        stream: _bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
          if (!snapshot.hasData || !(snapshot.data is PackageFinishedEvent))
            return CustomProgressBarWave();
          var packages = (snapshot.data as PackageFinishedEvent).packages;
          var size = MediaQuery.of(context).size;

          /*24 is for notification bar on Android*/
          final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
          final double itemWidth = size.width / 3;

          return Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0),
              child: GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(packages.length, (index) {
                    return new Center(
                        child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomText(
                              packages[index].name,
                              color: Colors.amber,
                              fontSize: 15,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CustomText(
                              (packages[index].price / 100).toString()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/tl-icon-png-5.png',
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  this.deletePrice(context, packages[index]),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        )
                      ],
                    ));
                  })),
            ),
          );
        },
      ),
    );
  }

  @override
  init(BuildContext buildContext) {
    _bloc.stream.listen((event) {
      showResult(buildContext, event);
      if (event is ApiSuccessEvent) _bloc.init();
    });
  }

  deletePrice(BuildContext context, PackageModel packageModel) {
    ConfirmHelper.showConfirm(context, 'Silmek istediğinize emin misiniz?')
        .then((value) {
      if (value == ConfirmAction.ACCEPT) {
        _bloc.eventSink.add(new PackageDeleteEvent(packageModel.id));
      }
    });
  }
}
