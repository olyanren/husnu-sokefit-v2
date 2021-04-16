import 'package:crossfit/models/base_model.dart';
import 'package:crossfit/themes/multiselect/multi_select_form_field.dart';
import 'package:flutter/material.dart';

class CustomMultiSelectDropdownBaseModelField<T extends BaseModel>
    extends StatefulWidget {
  final String title;
  final String hintText;
  List<T> selectedValues;
  final String emptyMessage;
  final List<T> items;
  final FormFieldSetter<dynamic> onSaved;
  Color color;
  double fontSize;
  FontWeight fontWeight;

  CustomMultiSelectDropdownBaseModelField({
    @required this.title,
    this.hintText,
    @required this.selectedValues,
    this.emptyMessage,
    @required this.items,
    @required this.onSaved,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  _InnerState<T> createState() {
    // TODO: implement createState
    return _InnerState<T>(
        title: this.title,
        hintText: this.hintText,
        selectedValues: this.selectedValues,
        emptyMessage: this.emptyMessage,
        items: this.items,
        onSaved: this.onSaved,
        color: this.color,
        fontSize: this.fontSize,
        fontWeight: this.fontWeight);
  }
}

class _InnerState<T> extends State<CustomMultiSelectDropdownBaseModelField> {
  final String title;
  final String hintText;
  List<T> selectedValues;
  final String emptyMessage;
  final List<T> items;
  final FormFieldSetter<dynamic> onSaved;
  Color color;
  double fontSize;
  FontWeight fontWeight;

  _InnerState({
    @required this.title,
    this.hintText,
    @required this.selectedValues,
    this.emptyMessage,
    @required this.items,
    @required this.onSaved,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).unfocus(),
        child: MultiSelectFormField(
          value: selectedValues,
          autovalidate: false,
          titleText: this.title,
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'Tamam',
          cancelButtonLabel: 'İptal',
          color: this.color,
          fontSize: this.fontSize,
          fontWeight: this.fontWeight,
          // required: true,
          hintText: this.hintText,

          onSaved: (value) => this.onSavedEvent(value),
          dataSource: items != null
              ? items.map((T model) {
                  return {"display": model.toString(), "value": model};
                }).toList()
              : [],
          validator: (value) {
            this.selectedValues = List<T>.from(value);
            if (this.emptyMessage == null) return null;
            if (value == null || value.length == 0) {
              return this.emptyMessage;
            }
            return null;
          },
        ),
      ),
    );
  }
  void onSavedEvent(value) {
    setState(() {
      this.selectedValues = List<T>.from(value);
    });
    onSaved(List<T>.from(value));
  }
}
