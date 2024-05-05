import "package:json_annotation/json_annotation.dart";

part "category_button.types.g.dart";

@JsonSerializable()
class CategoryButtonData {
  final String campusCategoryId;
  final String name;
  final String urlImage;

  const CategoryButtonData({
    required this.campusCategoryId,
    required this.name,
    required this.urlImage,
  });

  factory CategoryButtonData.fromJson(Map<String, dynamic> json) =>
      _$CategoryButtonDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryButtonDataToJson(this);
}
