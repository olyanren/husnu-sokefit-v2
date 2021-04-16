import 'package:sokefit/themes/custom_text.dart';
import 'package:sokefit/themes/multiselect/multi_select_dialog_item.dart';
import 'package:flutter/material.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  MultiSelectFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      int initialValue,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Tap to select one or more',
      this.required = false,
      this.errorText = 'Please select one or more options',
      this.value,
      this.leading,
      this.dataSource,
      this.textField,
      this.valueField,
      this.change,
      this.open,
      this.close,
      this.okButtonLabel = 'OK',
      this.cancelButtonLabel = 'CANCEL',
      this.trailing,
      this.color,
      this.fontWeight,
      this.fontSize})
      : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autovalidate,
          builder: (FormFieldState<dynamic> state) {
            List<Widget> _buildSelectedOptions(dynamic values, state) {
              List<Widget> selectedOptions = [];

              if (values != null) {
                values.forEach((item) {
                  var existingItem = dataSource.singleWhere(
                      (itm) => itm[valueField] == item,
                      orElse: () => null);
                  selectedOptions.add(Chip(
                    label: Text(
                      existingItem[textField],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color,
                          fontSize: fontSize != null ? fontSize : 13,
                          fontWeight: fontWeight == null
                              ? FontWeight.normal
                              : fontWeight),
                    ),
                  ));
                });
              }

              return selectedOptions;
            }

            return InkWell(
              onTap: () async {
                List initialSelected = value;
                if (initialSelected == null) {
                  initialSelected = List();
                }

                final items = List<MultiSelectDialogItem<dynamic>>();
                dataSource.forEach((item) {
                  items.add(
                      MultiSelectDialogItem(item[valueField], item[textField]));
                });

                List selectedValues = await showDialog<List>(
                  context: state.context,
                  builder: (BuildContext context) {
                    return MultiSelectDialog(
                      title: titleText,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: color,
                      okButtonLabel: okButtonLabel,
                      cancelButtonLabel: cancelButtonLabel,
                      items: items,
                      initialSelectedValues: initialSelected,
                    );
                  },
                );

                if (selectedValues != null) {
                  state.didChange(selectedValues);
                  state.save();
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  errorText: state.hasError ? state.errorText : null,
                  errorMaxLines: 4,
                ),
                isEmpty: state.value == null || state.value == '',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: CustomText(
                            titleText,
                          )),
                          required
                              ? Padding(
                                  padding: EdgeInsets.only(top: 5, right: 5),
                                  child: CustomText(
                                    ' *',
                                    color: Colors.red.shade700,
                                    fontSize: 17.0,
                                  ),
                                )
                              : Container(),
                          Icon(
                            Icons.arrow_drop_down,
                            color: color?? Colors.black87,
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                    value != null && value.length > 0
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 0.0,
                            children: _buildSelectedOptions(value, state),
                          )
                        :hintText!=null? new Container(
                            padding: EdgeInsets.only(top: 4, left: 0),
                            child: CustomText(
                              hintText,
                            ),
                          ):Container()
                  ],
                ),
              ),
            );
          },
        );
}
