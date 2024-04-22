import "package:json_annotation/json_annotation.dart";

part "login_request.types.g.dart";

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  LoginRequest({
    required this.email,
    required this.password,
  });
}
