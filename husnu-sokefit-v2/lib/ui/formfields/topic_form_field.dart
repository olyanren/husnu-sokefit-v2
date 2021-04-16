import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc_builder.dart';
import 'package:crossfit/blocs/coach/coach_bloc.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/string_model.dart';
import 'package:crossfit/themes/custom_dropdown_base_model_field.dart';
import 'package:crossfit/themes/custom_progress_bar.dart';
import 'package:crossfit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';

class TopicFormField extends BaseBlocScreen {
  Function onChanged;
  StringModel selectedTopic;

  TopicFormField({@required this.selectedTopic, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    List<StringModel> topics = [
      StringModel("Ders İptal Talebi"),
      StringModel("Gecikme Bildirimi"),
      StringModel("Antrenöre Mesaj")
    ];

    return CustomDropdownBaseModelField<StringModel>(
      hintText: 'Gönderim Konusu',
      selectedValue: selectedTopic,
      items: topics,
      emptyMessage: 'Bu alan boş olamaz',
      onChanged: (item) {
        selectedTopic = item;
        onChanged(item);
      },
    );
  }

  @override
  void init(BuildContext context) {}

  @override
  void dispose() {}
}
