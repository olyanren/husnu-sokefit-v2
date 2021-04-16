import 'package:sokefit/themes/custom_text.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>> items;
  final List<V> initialSelectedValues;
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String okButtonLabel;
  final String cancelButtonLabel;

  MultiSelectDialog(
      {Key key,
      this.items,
      this.initialSelectedValues,
      this.title,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.okButtonLabel,
      this.cancelButtonLabel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = List<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.background,
      title: CustomText(
        widget.title,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: CustomText(widget.cancelButtonLabel),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: CustomText(widget.okButtonLabel),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return Theme(
        data: ThemeData(unselectedWidgetColor: widget.color),
        child: CheckboxListTile(
          checkColor: widget.color,
          value: checked,
          title: CustomText(
            item.label,
            fontWeight: widget.fontWeight,
            fontSize: widget.fontSize,
            color: widget.color,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (checked) => _onItemCheckedChange(item.value, checked),
        ));
  }
}
