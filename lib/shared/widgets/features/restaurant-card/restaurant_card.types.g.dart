// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_card.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantCardData _$RestaurantCardDataFromJson(Map<String, dynamic> json) =>
    RestaurantCardData(
      title: json['title'] as String,
      logo: json['logo'] as String,
      bgImage: json['bgImage'] as String,
      path: json['path'] as String,
    );

Map<String, dynamic> _$RestaurantCardDataToJson(RestaurantCardData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'logo': instance.logo,
      'bgImage': instance.bgImage,
      'path': instance.path,
    };
