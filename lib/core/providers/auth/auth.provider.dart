import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../repository/auth/auth.repository_impl.dart";
import "../../services/auth/auth.service.dart";

final Provider<AuthenticationService> authenticationServiceProvider =
    Provider<AuthenticationService>((ProviderRef<AuthenticationService> ref) {
  return AuthenticationService(ref);
});

final Provider<AuthenticationRepository> authenticationRepositoryProvider =
    Provider<AuthenticationRepository>(
        (ProviderRef<AuthenticationRepository> ref) {
  final AuthenticationService authService =
      ref.read(authenticationServiceProvider);
  return AuthenticationRepository(authService);
});
