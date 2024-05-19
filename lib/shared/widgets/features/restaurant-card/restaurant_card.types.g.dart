// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_card.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantCardData _$RestaurantCardDataFromJson(Map<String, dynamic> json) =>
    RestaurantCardData(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool,
      restaurantId: json['restaurantId'] as String,
    );

Map<String, dynamic> _$RestaurantCardDataToJson(RestaurantCardData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'restaurantId': instance.restaurantId,
    };
