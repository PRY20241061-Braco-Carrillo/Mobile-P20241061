import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/auth/login/login_request.types.dart";
import "../../../core/models/auth/login/login_response.types.dart";
import "../../../core/models/base_response.dart";

final Provider<MockLoginService> mockLogInServiceProvider =
    Provider<MockLoginService>((ProviderRef<MockLoginService> ref) {
  return MockLoginService();
});

class MockLoginService {
  Future<BaseResponse<LoginResponse>> logInUser(LoginRequest logInData) async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    const String responseJson = '''
    {
      "code": "SUCCESS",
        "data": {
        "userId": "6d68f94d-41d0-46e9-8130-983fa6ab1f14",
        "roles": "ROLE_WAITER",
        "cancelReservation": 0,
        "acceptReservation": 0,
        "token": "eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbW15bHV6QGhvdG1haWwuY29tIiwicm9sZXMiOlt7ImF1dGhvcml0eSI6IlJPTEVfV0FJVEVSIn1dLCJpYXQiOjE3MTMzMTY3NDIsImV4cCI6MTc5OTcxNjc0Mn0.4rJFTgi_PjBvUCP3a95IpOrodqAE1BgVS0A5VYaPMEK2o3D52quyx7-Gg4y3VwWJ"
    }
    }''';

    final Map<String, dynamic> responseData = jsonDecode(responseJson);
    return BaseResponse<LoginResponse>.fromJson(
        responseData, LoginResponse.fromJson);
  }
}
