import 'package:sokefit/models/base_model.dart';
import 'package:sokefit/themes/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'custom_text.dart';

class CustomDropdownBaseModelField<T extends BaseModel> extends StatefulWidget {
  String hintText;
  T selectedValue;
  String emptyMessage;
  List<T> items;
  ValueChanged<T> onChanged;

  CustomDropdownBaseModelField(
      {Key key,
      @required this.items,
      @required this.hintText,
      @required this.selectedValue,
      this.emptyMessage,
      @required this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InnerState<T>(this.hintText,
      this.selectedValue, this.emptyMessage, this.items, this.onChanged);
}

class _InnerState<T extends BaseModel>
    extends State<CustomDropdownBaseModelField> {
  String _hintText;
  T _selectedValue;
  String _emptyMessage;
  List<T> _items;
  ValueChanged<T> onChanged;

  _InnerState(this._hintText, this._selectedValue, this._emptyMessage,
      this._items, this.onChanged);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: (widget.selectedValue ?? _selectedValue) != null &&
                (widget.selectedValue ?? _selectedValue).toString() != ''
            ? getDropDown()
            : getDropDownWithoutValue(),
      ),
    );
  }

  Widget getDropDown() {
    return DropdownButtonFormField<T>(
      isDense: true,
      value: widget.selectedValue ?? _selectedValue,
      decoration: InputDecoration(
        hintStyle: new TextStyle(
            color: CustomColors.inputHintColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        labelStyle: new TextStyle(
            color: CustomColors.inputLabelColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputEnabledBorderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputFocusedColor),
        ),
        errorStyle: TextStyle(
            fontSize: 12.0 * SizeConfig.safeBlockHorizontal,
            color: Colors.red),
      ),
      isExpanded: true,
      hint: new CustomText(
        this._hintText,
        color: CustomColors.inputHintColor,
      ),
      selectedItemBuilder: (BuildContext context) {
        return _items.map<Widget>((T item) {
          return CustomText(item.toString(), color: Colors.white);
        }).toList();
      },
      items: _items != null
          ? _items.map((T model) {
              return new DropdownMenuItem<T>(
                value: model,
                child: new CustomText(
                  model.toString(),
                ),
              );
            }).toList()
          : [],
      validator: (value) {
        if (this._selectedValue == null &&
            value == null &&
            widget.selectedValue == null) {
          return this._emptyMessage;
        }
        if (value != null) this._selectedValue = value;
        return null;
      },
      onChanged: (value) => this.onChangedEvent(value),
    );
  }

  Widget getDropDownWithoutValue() {
    return DropdownButtonFormField<T>(
      isDense: true,
      decoration: InputDecoration(
        hintStyle: new TextStyle(
            color: CustomColors.inputHintColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        labelStyle: new TextStyle(
            color:CustomColors.inputLabelColor, fontSize: 12 * SizeConfig.safeBlockHorizontal),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputEnabledBorderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.inputFocusedColor),
        ),
        errorStyle: TextStyle(
            fontSize: 12.0 * SizeConfig.safeBlockHorizontal, color: Colors.red),
      ),
      isExpanded: true,
      hint: new CustomText(
        this._hintText,
        color: CustomColors.inputHintColor,
      ),
      items: _items != null
          ? _items.map((T model) {
              return new DropdownMenuItem<T>(
                value: model,
                child: new CustomText(
                  model.toString(),
                  color: CustomColors.inputDropDownItemColor,
                ),
              );
            }).toList()
          : [],
      validator: (value) {
        if (this._selectedValue == null &&
            value == null &&
            widget.selectedValue == null) {
          return this._emptyMessage;
        }
        if (value != null) this._selectedValue = value;
        return null;
      },
      onChanged: (value) => this.onChangedEvent(value),
    );
  }

  void onChangedEvent(value) {
    setState(() {
      this._selectedValue = value;
      widget.selectedValue = value;
    });
    onChanged(value);
  }
}
