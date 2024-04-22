// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.request.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      names: json['names'] as String,
      lastNames: json['lastNames'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'names': instance.names,
      'lastNames': instance.lastNames,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
    };
