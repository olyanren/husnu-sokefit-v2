import 'package:crossfit/themes/colors.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/themes/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog_prompt_helper.dart';

class PromptDialogTelephoneHelper {
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
              'Lütfen telefon numaranızı giriniz',
                keyboardType: TextInputType.phone),
            actions: <Widget>[
              FlatButton(
                child: CustomText('Onayla'),
                onPressed: () {
                  Navigator.of(context).pop(new PromptResult(true,_textFieldController.value.text));
                },
              ),
              FlatButton(
                child:  CustomText('İptal'),
                onPressed: () {
                  Navigator.of(context).pop(new PromptResult(false, null));
                },
              ),
            ],
          );
        });
  }
}
