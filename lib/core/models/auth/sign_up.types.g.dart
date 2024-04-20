// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpData _$SignUpDataFromJson(Map<String, dynamic> json) => SignUpData(
      email: json['email'] as String,
      password: json['password'] as String,
      names: json['names'] as String,
      lastNames: json['lastNames'] as String,
      role: $enumDecode(_$RolesEnumMap, json['role']),
    );

Map<String, dynamic> _$SignUpDataToJson(SignUpData instance) =>
    <String, dynamic>{
      'names': instance.names,
      'lastNames': instance.lastNames,
      'email': instance.email,
      'password': instance.password,
      'role': _$RolesEnumMap[instance.role]!,
    };

const _$RolesEnumMap = {
  Roles.admin: 'admin',
  Roles.user: 'user',
  Roles.waiter: 'waiter',
  Roles.chef: 'chef',
};
