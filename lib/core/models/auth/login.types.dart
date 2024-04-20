import "package:json_annotation/json_annotation.dart";

part "login.types.g.dart";

@JsonSerializable()
class LoginData {
  final String email;
  final String password;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  LoginData({
    required this.email,
    required this.password,
  });
}
