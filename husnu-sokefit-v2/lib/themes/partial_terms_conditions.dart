import 'package:sokefit/helpers/alert_helper.dart';
import 'package:sokefit/helpers/loading_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class PartialTermConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          'assets/images/tick.png',
          height: 80,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                    onTap: () => openPrivacy(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: CustomText('Gizlilik ve Güvenlik Politikası'),
                    )),
                GestureDetector(
                    onTap: () => openDistanceSellingContract(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: CustomText('Mesafeli Satış Sözleşmesi'),
                    )),
                GestureDetector(
                    onTap: () => openKVKKTerms(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: CustomText('KVKK Şartları'),
                    )),
                GestureDetector(
                    onTap: () => openCancellationRefundConditions(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: CustomText('İptal/İade Şartları'),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
  openPrivacy(BuildContext context) {
    LoadingHelper.show(context);
    DefaultAssetBundle.of(context)
        .loadString("assets/html/privacy.html")
        .then((result) {
      LoadingHelper.hide(context);
      AlertHelper.showHtml(context, 'Gizlilik ve Güvenlik Politikası', result,color: Colors.white);
    });
  }
  openDistanceSellingContract(BuildContext context) {
    LoadingHelper.show(context);
    DefaultAssetBundle.of(context)
        .loadString("assets/html/distance_selling_contract.html")
        .then((result) {
      LoadingHelper.hide(context);
      AlertHelper.showHtml(context, 'Mesafeli Satış Sözleşmesi', result,color: Colors.white);
    });
  }

  openKVKKTerms(BuildContext context) {
    LoadingHelper.show(context);
    DefaultAssetBundle.of(context)
        .loadString("assets/html/kvkk_terms.html")
        .then((result) {
      LoadingHelper.hide(context);
      AlertHelper.showHtml(context, 'KVKK Şartları', result,color: Colors.white);
    });
  }

  openCancellationRefundConditions(BuildContext context) {
    LoadingHelper.show(context);
    DefaultAssetBundle.of(context)
        .loadString("assets/html/cancellation_refund.html")
        .then((result) {
      LoadingHelper.hide(context);
      AlertHelper.showHtml(context, 'İptal/İade Şartları', result,color: Colors.white);
    });
  }
}
