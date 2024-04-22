import "package:json_annotation/json_annotation.dart";

part "restaurant.response.types.g.dart";

@JsonSerializable()
class RestaurantResponse {
  final String restaurantId;
  final String name;
  final String imageUrl;
  final bool isAvailable;

  RestaurantResponse({
    required this.restaurantId,
    required this.name,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory RestaurantResponse.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          "The JSON argument must be of type Map<String, dynamic>");
    }
    return _$RestaurantResponseFromJson(json);
  }
}
