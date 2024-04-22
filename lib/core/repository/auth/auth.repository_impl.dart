import "../../models/auth/login/login_request.types.dart";
import "../../models/auth/login/login_response.types.dart";
import "../../models/auth/sign_up/sign_up.request.types.dart";
import "../../models/auth/sign_up/sign_up.response.types.dart";
import "../../models/base_response.dart";
import "../../services/auth/auth.service.dart";
import "auth.repository.dart";

class AuthenticationRepository implements IAuthenticationRepository {
  final AuthenticationService _authenticationService;

  AuthenticationRepository(this._authenticationService);

  @override
  Future<BaseResponse<LoginResponse>> logIn(LoginRequest loginRequest) {
    return _authenticationService.logInUser(loginRequest);
  }

  @override
  Future<BaseResponse<SignUpResponse>> signUp(SignUpRequest signUpRequest) {
    return _authenticationService.signUpUser(signUpRequest);
  }
}
