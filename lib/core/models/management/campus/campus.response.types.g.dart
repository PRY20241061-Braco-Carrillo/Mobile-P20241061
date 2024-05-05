// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campus.response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampusResponse _$CampusResponseFromJson(Map<String, dynamic> json) =>
    CampusResponse(
      campusId: json['campusId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      openHour: OpenHour.fromJson(json['openHour'] as Map<String, dynamic>),
      toTakeHome: json['toTakeHome'] as bool,
      toDelivery: json['toDelivery'] as bool,
      restaurantId: json['restaurantId'] as String,
      isAvailable: json['isAvailable'] as bool,
      imageUrl: json['imageUrl'] as String,
      logoUrl: json['logoUrl'] as String,
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
      'restaurantId': instance.restaurantId,
      'isAvailable': instance.isAvailable,
      'imageUrl': instance.imageUrl,
      'logoUrl': instance.logoUrl,
    };

ListCampusResponse _$ListCampusResponseFromJson(Map<String, dynamic> json) =>
    ListCampusResponse(
      campus: (json['campus'] as List<dynamic>)
          .map((e) => CampusResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListCampusResponseToJson(ListCampusResponse instance) =>
    <String, dynamic>{
      'campus': instance.campus,
    };
