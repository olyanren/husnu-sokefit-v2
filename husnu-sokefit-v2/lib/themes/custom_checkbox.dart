import 'package:sokefit/themes/colors.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomCheckBox extends StatefulWidget {
  String label;
  bool selectedValue;
  ValueChanged<bool> onChanged;

  Color color;
  bool isClickableText;

  CustomCheckBox(this.label, this.selectedValue, this.onChanged,
      {this.color, this.isClickableText = true});

  @override
  State<StatefulWidget> createState() {
    return _InnerState(this.label, this.selectedValue, this.onChanged,
        this.color, this.isClickableText);
  }
}

class _InnerState extends State<CustomCheckBox> {
  String _label;
  bool _selectedValue;
  ValueChanged<bool> _onChanged;
  Color color;
  bool isClickableText;

  _InnerState(this._label, this._selectedValue, this._onChanged, this.color,
      this.isClickableText);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 48.0,
          width: 24.0,
          child: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              onChanged: (value) => this.onChangedEvent(value),
              value: widget.selectedValue ?? _selectedValue,
              checkColor: Colors.white,
              hoverColor: Colors.white,
              activeColor: Colors.red,
            ),
          ),
        ),
        isClickableText == true
            ? CustomText(
              this._label,
              color: CustomColors.titleColor,
              wrapText: true,
              onClick:()=>this.onChangedEvent(!_selectedValue)
            )
            : CustomText(
                this._label,
                color: CustomColors.titleColor,
                wrapText: true,
              )
      ],
    );
  }

  void onChangedEvent(value) {
    setState(() {
      this._selectedValue = value;
      widget.selectedValue = value;
    });
    _onChanged(value);
  }
}
