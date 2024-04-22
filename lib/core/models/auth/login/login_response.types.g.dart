// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      userId: json['userId'] as String,
      roles: json['roles'] as String,
      cancelReservation: json['cancelReservation'] as int,
      acceptReservation: json['acceptReservation'] as int,
      token: json['token'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'roles': instance.roles,
      'cancelReservation': instance.cancelReservation,
      'acceptReservation': instance.acceptReservation,
      'token': instance.token,
    };
