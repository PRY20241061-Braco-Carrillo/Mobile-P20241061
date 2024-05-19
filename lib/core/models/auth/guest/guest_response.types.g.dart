// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestResponse _$GuestResponseFromJson(Map<String, dynamic> json) =>
    GuestResponse(
      roles: json['roles'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$GuestResponseToJson(GuestResponse instance) =>
    <String, dynamic>{
      'roles': instance.roles,
      'token': instance.token,
    };
