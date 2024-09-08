import "package:json_annotation/json_annotation.dart";

part "category_button.types.g.dart";

@JsonSerializable()
class CategoryButtonData {
  final String campusCategoryId;
  final String name;
  final String urlImage;
  final bool? is_promotion;
  final bool? is_combo;
  final bool? is_menu;

  const CategoryButtonData({
    required this.campusCategoryId,
    required this.name,
    required this.urlImage,
    this.is_promotion,
    this.is_combo,
    this.is_menu,
  });

  factory CategoryButtonData.fromJson(Map<String, dynamic> json) =>
      _$CategoryButtonDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryButtonDataToJson(this);
}
