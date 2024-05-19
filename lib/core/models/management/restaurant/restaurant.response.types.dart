import "package:json_annotation/json_annotation.dart";

part "restaurant.response.types.g.dart";

@JsonSerializable()
class RestaurantResponse {
  final String restaurantId;

  final String name;

  final String? imageUrl;

  final String logoUrl;

  final bool isAvailable;

  RestaurantResponse({
    required this.restaurantId,
    required this.name,
    this.imageUrl,
    required this.logoUrl,
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

@JsonSerializable()
class ListRestaurantResponse {
  final List<RestaurantResponse> restaurants;

  ListRestaurantResponse({required this.restaurants});

  factory ListRestaurantResponse.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          "The JSON argument must be of type Map<String, dynamic>");
    }
    return _$ListRestaurantResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ListRestaurantResponseToJson(this);
}
