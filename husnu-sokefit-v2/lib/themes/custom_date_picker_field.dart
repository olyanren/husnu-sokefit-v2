
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'custom_text_form_field.dart';

class CustomDatePickerField extends StatefulWidget {
  TextEditingController _controller;
  String hintText;
  String emptyMessage;
  TextInputType keyboardType = TextInputType.text;
  int multiline = 1;
  DateTime currentDate;
  String dateFormat;

  CustomDatePickerField(this._controller, this.hintText, this.emptyMessage,
      {this.keyboardType, this.multiline, this.currentDate, this.dateFormat}) {
    if (currentDate != null) {
      this._controller.text =
          DateFormat(this.dateFormat ?? 'dd/MM/yyyy').format(currentDate);
    }
  }

  @override
  State<StatefulWidget> createState() =>
      _InnerState(this._controller, this.hintText, this.emptyMessage,
          keyboardType: this.keyboardType,
          multiline: this.multiline,
          currentDate: this.currentDate,
          dateFormat: this.dateFormat);
}

class _InnerState extends State<CustomDatePickerField> {
  TextEditingController _controller;
  String hintText;
  String emptyMessage;
  TextInputType keyboardType = TextInputType.text;
  int multiline = 1;
  DateTime currentDate;
  String dateFormat;

  _InnerState(this._controller, this.hintText, this.emptyMessage,
      {this.keyboardType, this.multiline, this.currentDate, this.dateFormat}) {
    if (currentDate != null) {
      this._controller.text =
          DateFormat(this.dateFormat ?? 'dd/MM/yyyy').format(currentDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Below line stops keyboard from appearing
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
        // Show Date Picker Here
      },
      child: IgnorePointer(
        child: CustomTextFormField(
          _controller,
          this.hintText,
          this.emptyMessage,
          keyboardType: TextInputType.datetime,
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != currentDate) {
      this._controller.text =
          DateFormat(this.dateFormat ?? 'dd/MM/yyyy').format(picked);
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
}
