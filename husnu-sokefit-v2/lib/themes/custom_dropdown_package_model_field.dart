import 'package:sokefit/models/base_model.dart';
import 'package:sokefit/themes/colors.dart';
import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/size_config.dart';
import 'package:flutter/material.dart';

class CustomDropdownPackageModelField<T extends BaseModel>
    extends StatelessWidget {
  String _hintText;
  T _selectedValue;
  String _emptyMessage;
  List<T> _items;
  ValueChanged<T> onChanged;

  CustomDropdownPackageModelField(this._hintText, this._selectedValue,
      this._emptyMessage, this._items, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).unfocus(),
      child: DropdownButtonFormField<T>(
        isDense: true,
        value: _selectedValue,
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
            borderSide: BorderSide(color:CustomColors.underlineFocused),
          ),
          errorStyle: TextStyle(
            fontSize: 16.0 * SizeConfig.safeBlockHorizontal,
          ),
        ),
        isExpanded: true,
        hint: new CustomText(
          this._hintText,
        ),
        items: _items != null
            ? _items.map((T packageModel) {
                return new DropdownMenuItem<T>(
                  value: packageModel,
                  child: new CustomText(
                      packageModel.toString(),
                      fontSize: 12),
                );
              }).toList()
            : [],
        validator: (value) {
          if (value == null) {
            return this._emptyMessage;
          }
          this._selectedValue = value;
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }
}
