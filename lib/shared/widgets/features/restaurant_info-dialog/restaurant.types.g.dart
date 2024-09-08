// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampusResponse _$CampusResponseFromJson(Map<String, dynamic> json) =>
    CampusResponse(
      campusId: json['campusId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      openHour: (json['openHour'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, OpenHour.fromJson(e as Map<String, dynamic>)),
      ),
      toTakeHome: json['toTakeHome'] as bool,
      toDelivery: json['toDelivery'] as bool,
      restaurant:
          Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
      regexTableCode: json['regexTableCode'] as String,
      urlImage: json['urlImage'] as String,
      isAvailable: json['isAvailable'] as bool,
    );

Map<String, dynamic> _$CampusResponseToJson(CampusResponse instance) =>
    <String, dynamic>{
      'campusId': instance.campusId,
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'openHour': instance.openHour,
      'toTakeHome': instance.toTakeHome,
      'toDelivery': instance.toDelivery,
      'restaurant': instance.restaurant,
      'regexTableCode': instance.regexTableCode,
      'urlImage': instance.urlImage,
      'isAvailable': instance.isAvailable,
    };

OpenHour _$OpenHourFromJson(Map<String, dynamic> json) => OpenHour(
      breakfast: MealTime.fromJson(json['breakfast'] as Map<String, dynamic>),
      lunch: MealTime.fromJson(json['lunch'] as Map<String, dynamic>),
      dinner: json['dinner'] == null
          ? null
          : MealTime.fromJson(json['dinner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpenHourToJson(OpenHour instance) => <String, dynamic>{
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
    };

MealTime _$MealTimeFromJson(Map<String, dynamic> json) => MealTime(
      opening: json['opening'] as String,
      closing: json['closing'] as String,
    );

Map<String, dynamic> _$MealTimeToJson(MealTime instance) => <String, dynamic>{
      'opening': instance.opening,
      'closing': instance.closing,
    };

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      isAvailable: json['isAvailable'] as bool,
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'restaurantId': instance.restaurantId,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'isAvailable': instance.isAvailable,
    };
