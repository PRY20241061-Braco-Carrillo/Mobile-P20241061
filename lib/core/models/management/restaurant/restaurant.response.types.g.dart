// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantResponse _$RestaurantResponseFromJson(Map<String, dynamic> json) =>
    RestaurantResponse(
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      logoUrl: json['logoUrl'] as String,
      isAvailable: json['isAvailable'] as bool,
    );

Map<String, dynamic> _$RestaurantResponseToJson(RestaurantResponse instance) =>
    <String, dynamic>{
      'restaurantId': instance.restaurantId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'logoUrl': instance.logoUrl,
      'isAvailable': instance.isAvailable,
    };

ListRestaurantResponse _$ListRestaurantResponseFromJson(
        Map<String, dynamic> json) =>
    ListRestaurantResponse(
      restaurants: (json['restaurants'] as List<dynamic>)
          .map(RestaurantResponse.fromJson)
          .toList(),
    );

Map<String, dynamic> _$ListRestaurantResponseToJson(
        ListRestaurantResponse instance) =>
    <String, dynamic>{
      'restaurants': instance.restaurants,
    };
