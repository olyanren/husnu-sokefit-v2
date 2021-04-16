import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/wods/today_wod_bloc.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/themes/custom_container.dart';
import 'package:crossfit/themes/custom_date_picker_field.dart';
import 'package:crossfit/themes/custom_flat_button.dart';
import 'package:crossfit/themes/custom_text.dart';
import 'package:crossfit/ui/base_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:html_editor/html_editor.dart';

class WodTodayCreateScreen extends BaseUserScreen {
  TextEditingController _datePickerController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  TodayWodBloc _todayWodBloc=new TodayWodBloc();

  WodTodayCreateScreen(UserModel userModel) : super(userModel);

  @override
  Widget innerBody(BuildContext context) {
    return BlocBuilder(
      root: this,
      bloc: _todayWodBloc,
      child: CustomContainer(
        padding: 20,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomDatePickerField(
                    _datePickerController, 'Tarih Seçiniz', 'Tarih kısmı boş olamaz'),
                Container(
                  color: Colors.white,
                  child: HtmlEditor(

                    hint: "Wod bilgisi...",
                    //value: "text content initial, if any",
                    key: keyEditor,
                    height: 400,
                  ),
                ),
                CustomFlatButton('Wod Kaydet',onPressed: ()=>this.registerTodayWod(context),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  title() {
    return CustomText('WOD OlUŞTURMA',
        color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold);
  }

  registerTodayWod(BuildContext context) async {
    if(_formKey.currentState.validate()){

      var content = await keyEditor.currentState.getText();
      var date=_datePickerController.text;
      _todayWodBloc.storeWod(date,content);
    }
  }

  @override
  void init(BuildContext context) {
    _todayWodBloc.stream.listen((event) {   showResult(context, event); });

  }
}
