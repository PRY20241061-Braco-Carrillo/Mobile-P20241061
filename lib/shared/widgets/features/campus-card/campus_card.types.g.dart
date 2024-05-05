// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campus_card.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampusCardData _$CampusCardDataFromJson(Map<String, dynamic> json) =>
    CampusCardData(
      campusId: json['campusId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      openHour: OpenHour.fromJson(json['openHour'] as Map<String, dynamic>),
      toTakeHome: json['toTakeHome'] as bool,
      toDelivery: json['toDelivery'] as bool,
      restaurantId: json['restaurantId'] as String,
      isAvailable: json['isAvailable'] as bool,
      logoUrl: json['logoUrl'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$CampusCardDataToJson(CampusCardData instance) =>
    <String, dynamic>{
      'campusId': instance.campusId,
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'openHour': instance.openHour,
      'toTakeHome': instance.toTakeHome,
      'toDelivery': instance.toDelivery,
      'restaurantId': instance.restaurantId,
      'isAvailable': instance.isAvailable,
      'logoUrl': instance.logoUrl,
      'imageUrl': instance.imageUrl,
    };
