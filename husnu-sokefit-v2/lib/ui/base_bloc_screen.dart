import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseBlocScreen extends StatelessWidget{
  BaseBlocScreen({ Key key }):super(key:key);
  void init(BuildContext context);
  void dispose();
  void showResult(BuildContext context, ApiEvent event) {
    if (event is ApiFailedEvent) {
      SnackBarHelper.hide();
      AlertHelper.show(context, 'Hata', event.message??'Beklenmeyen bir hata oluştu');
    }  else if (event is ApiSuccessEvent) {
      SnackBarHelper.hide();
      AlertHelper.showToast(context, 'Sonuç', event.message??'İşlem başarılı');
    }
  }
}