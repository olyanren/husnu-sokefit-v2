class PrivateScoreModel {
  int id;
  String name;
  String description;
  int position;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String oldValue;
  String newValue;
  String type;

  PrivateScoreModel(
      {this.id,
        this.name,
        this.description,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.oldValue,
        this.newValue});

  PrivateScoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description =json['description']??'';
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    oldValue = json['old_value'];
    newValue = json['new_value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['position'] = this.position;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['old_value'] = this.oldValue;
    data['new_value'] = this.newValue;
    data['type'] = this.type;
    return data;
  }
}