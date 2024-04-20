import "package:json_annotation/json_annotation.dart";

import "../../../shared/utils/constants/constants.dart";

part "sign_up.types.g.dart";

@JsonSerializable()
class SignUpData {
  final String names;
  final String lastNames;
  final String email;
  final String password;
  final Roles role;

  factory SignUpData.fromJson(Map<String, dynamic> json) =>
      _$SignUpDataFromJson(
          json..["role"] = _roleFromString(json["role"] as String));

  SignUpData({
    required this.email,
    required this.password,
    required this.names,
    required this.lastNames,
    required this.role,
  });

  static Roles _roleFromString(String roleStr) {
    return Roles.values.firstWhere(
        (Roles r) =>
            r.toString().split(".").last.toUpperCase() == roleStr.toUpperCase(),
        orElse: () => throw ArgumentError("Unknown role: $roleStr"));
  }
}
