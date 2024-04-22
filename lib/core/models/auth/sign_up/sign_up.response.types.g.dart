// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) =>
    SignUpResponse(
      userId: json['userId'] as String,
      names: json['names'] as String,
      lastNames: json['lastNames'] as String,
      email: json['email'] as String,
      roles: json['roles'] as String,
      cancelReservation: json['cancelReservation'] as int,
      acceptReservation: json['acceptReservation'] as int,
    );

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'names': instance.names,
      'lastNames': instance.lastNames,
      'email': instance.email,
      'roles': instance.roles,
      'cancelReservation': instance.cancelReservation,
      'acceptReservation': instance.acceptReservation,
    };
