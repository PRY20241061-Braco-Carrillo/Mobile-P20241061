import 'package:json_annotation/json_annotation.dart';

part 'restaurant.types.g.dart';

@JsonSerializable()
class CampusResponse {
  final String campusId;
  final String name;
  final String address;
  final String phoneNumber;
  final Map<String, OpenHour> openHour;
  final bool toTakeHome;
  final bool toDelivery;
  final Restaurant restaurant;
  final String regexTableCode;
  final String urlImage;
  final bool isAvailable;

  CampusResponse({
    required this.campusId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.openHour,
    required this.toTakeHome,
    required this.toDelivery,
    required this.restaurant,
    required this.regexTableCode,
    required this.urlImage,
    required this.isAvailable,
  });

  factory CampusResponse.fromJson(Map<String, dynamic> json) =>
      _$CampusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CampusResponseToJson(this);
}

@JsonSerializable()
class OpenHour {
  final MealTime breakfast;
  final MealTime lunch;
  final MealTime? dinner;

  OpenHour({required this.breakfast, required this.lunch, this.dinner});

  factory OpenHour.fromJson(Map<String, dynamic> json) =>
      _$OpenHourFromJson(json);

  Map<String, dynamic> toJson() => _$OpenHourToJson(this);
}

@JsonSerializable()
class MealTime {
  final String opening;
  final String closing;

  MealTime({required this.opening, required this.closing});

  factory MealTime.fromJson(Map<String, dynamic> json) =>
      _$MealTimeFromJson(json);

  Map<String, dynamic> toJson() => _$MealTimeToJson(this);
}

@JsonSerializable()
class Restaurant {
  final String restaurantId;
  final String name;
  final String logoUrl;
  final bool isAvailable;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.logoUrl,
    required this.isAvailable,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
