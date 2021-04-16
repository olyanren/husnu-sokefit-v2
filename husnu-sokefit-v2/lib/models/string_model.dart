import 'package:crossfit/models/base_model.dart';

class StringModel extends BaseModel{
  String value;

  StringModel(this.value);
  @override
  String toString() {
    // TODO: implement toString
    return this.value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringModel &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}