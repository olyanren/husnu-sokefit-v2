import 'package:sokefit/models/base_model.dart';

class ImageModel extends BaseModel {
  int id;
  String image;
  String description;

  ImageModel({this.image, this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'description': description,
    };
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(image: json["image"], description: json["description"]);
  }
}
