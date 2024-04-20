import "routes.dart";
import "../../core/shared_preferences/services/shared_preferences.service.dart";
import "../../modules/auth/log_in/log_in_screen.dart";
import "../../modules/auth/onboarding/access_options_screen.dart";
import "../../modules/auth/onboarding/onboarding_screen.dart";
import "../../modules/auth/sign_up/sign_up_screen.dart";
import "../../modules/home/home_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

import "package:go_router/go_router.dart";

class AppRouter {
  static Future<bool> isAuthenticated() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "isAuthenticated") == "true";
  }

  static Future<GoRouter> createRouter() async {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: "/",
      routes: <GoRoute>[
        GoRoute(
          path: "/",
          redirect: (BuildContext context, GoRouterState state) async {
            final bool completedOnboarding =
                SharedPreferencesService.instance.getOnboardingComplete();
            final bool authed = await isAuthenticated();
            final bool guest = SharedPreferencesService.instance.getGuest();
            if (!completedOnboarding) {
              return AppRoutes.onboarding;
            } else if (!authed && !guest) {
              return AppRoutes.accessOptions;
            } else if (guest) {
              return AppRoutes.accessOptions;
            } else {
              return AppRoutes.home;
            }
          },
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (BuildContext context, GoRouterState state) =>
              const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.accessOptions,
          builder: (BuildContext context, GoRouterState state) =>
              const AccessOptionsScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (BuildContext context, GoRouterState state) =>
              const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.logIn,
          builder: (BuildContext context, GoRouterState state) =>
              const LogInScreen(),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          builder: (BuildContext context, GoRouterState state) =>
              const SignUpScreen(),
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text("Something went wrong: ${state.error}")),
      ),
    );
  }
}
