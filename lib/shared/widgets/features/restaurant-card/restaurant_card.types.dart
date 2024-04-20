import "package:json_annotation/json_annotation.dart";

part "restaurant_card.types.g.dart";

@JsonSerializable()
class RestaurantCardData {
  final String title;
  final String logo;
  final String bgImage;
  final String path;

  factory RestaurantCardData.fromJson(Map<String, dynamic> json) =>
      _$RestaurantCardDataFromJson(json);

  RestaurantCardData({
    required this.title,
    required this.logo,
    required this.bgImage,
    required this.path,
  });
}
