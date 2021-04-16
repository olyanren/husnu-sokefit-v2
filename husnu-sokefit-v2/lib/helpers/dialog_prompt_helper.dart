import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PromptResult {
  bool status;
  String data;

  PromptResult(this.status,this.data);
}
class PromptDialogHelper {
  static final TextEditingController _textFieldController =
      TextEditingController();

  static  Future<PromptResult> show(BuildContext context, String title, String hintText) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.background,
            title: CustomText(title),
            content:   CustomTextFormField(
              _textFieldController,
              hintText,
                'Değer giriniz',
                keyboardType:TextInputType.text),
            actions: <Widget>[
              FlatButton(
                child: CustomText('Onayla'),
                onPressed: () {

                  Navigator.of(context, rootNavigator: true).pop(new PromptResult(true,_textFieldController.value.text));
                },
              ),
              FlatButton(
                child:  CustomText('İptal'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(new PromptResult(false, null));
                },
              ),
            ],
          );
        });
  }
}
