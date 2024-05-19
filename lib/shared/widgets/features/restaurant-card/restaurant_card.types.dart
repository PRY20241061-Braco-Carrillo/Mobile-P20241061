import "package:json_annotation/json_annotation.dart";

part "restaurant_card.types.g.dart";

@JsonSerializable()
class RestaurantCardData {
  final String name;
  final String logoUrl;
  final String? imageUrl;
  final bool isAvailable;
  final String restaurantId;

  factory RestaurantCardData.fromJson(Map<String, dynamic> json) =>
      _$RestaurantCardDataFromJson(json);

  RestaurantCardData({
    required this.name,
    required this.logoUrl,
    this.imageUrl,
    required this.isAvailable,
    required this.restaurantId,
  });
}
