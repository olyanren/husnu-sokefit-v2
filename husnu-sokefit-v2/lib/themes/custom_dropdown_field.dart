import 'dart:core';

import 'package:sokefit/themes/size_config.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'custom_text.dart';

class CustomDropdownField extends StatefulWidget {
  var _hintText;
  var _selectedValue;
  var _emptyMessage;
  List<String> _items;
  ValueChanged<String> onChanged;

  CustomDropdownField(this._hintText, this._selectedValue, this._emptyMessage,
      this._items, this.onChanged);


  @override
  State<StatefulWidget> createState() {
    return  _InnerState(this._hintText, this._selectedValue,
        this._emptyMessage, this._items, this.onChanged);
  }
}
class _InnerState extends State<CustomDropdownField>{
  var _hintText;
  var _selectedValue;
  var _emptyMessage;
  List<String> _items;
  ValueChanged<String> onChanged;

  _InnerState(this._hintText, this._selectedValue, this._emptyMessage,
      this._items, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).unfocus(),
      child: DropdownButtonFormField<String>(
          value: widget._selectedValue??_selectedValue,
          decoration: InputDecoration(
            hintStyle: new TextStyle(
                color: Colors.white,
                fontSize: 12 * SizeConfig.safeBlockHorizontal),
            labelStyle: new TextStyle(
                color: Colors.white,
                fontSize: 12 * SizeConfig.safeBlockHorizontal),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.underline),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.underlineFocused),
            ),
            errorStyle: TextStyle(
              fontSize: 12.0 * SizeConfig.safeBlockHorizontal,
            ),
          ),
          isExpanded: true,
          hint: new CustomText(
            this._hintText,
          ),
          items: _items != null
              ? _items.map((String value) {
            return new DropdownMenuItem(
              value: value,
              child: new CustomText(
                '$value',
              ),
            );
          }).toList()
              : [],
          validator: (value) {
            if (this._selectedValue == null && value == null && widget._selectedValue==null) {
              return this._emptyMessage;
            }
            this._selectedValue = value;
            return null;
          },
       onChanged: (value)=>this.onChangedEvent(value),
    ));
  }

  onChangedEvent(String value) {
    setState(() {
      this._selectedValue = value;
    });
    onChanged(value);
  }

}