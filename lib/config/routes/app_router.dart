import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../core/managers/secure_storage_manager.dart";
import "../../core/shared_preferences/services/shared_preferences.service.dart";
import "../../modules/auth/log_in/log_in_screen.dart";
import "../../modules/auth/onboarding/access_options_screen.dart";
import "../../modules/auth/onboarding/onboarding_screen.dart";
import "../../modules/auth/sign_up/sign_up_screen.dart";
import "../../modules/campus/campus_screen.dart";
import "../../modules/categories/categories_screen.dart";
import "../../modules/home/home_screen.dart";
import "../../modules/product/product_detail/product_detail_navigation_data.types.dart";
import "../../modules/product/product_detail/product_detail_screen.dart";
import "../../modules/product/products_list/products_by_category_of_campus_screen.dart";
import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "../../modules/product/products_list/category_navigation_data.types.dart";
import "routes.dart";

final Provider<GoRouter> goRouterProvider =
    Provider<GoRouter>((ProviderRef<GoRouter> ref) {
  final SecureStorageManager storageManager = ref.watch(secureStorageProvider);
  final bool onboardingComplete =
      ref.watch(sharedPreferencesServiceProvider).getOnboardingComplete();

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: "/",
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        redirect: (BuildContext context, GoRouterState state) async {
          if (!onboardingComplete) {
            return AppRoutes.onboarding;
          } else if (!(await storageManager.isAuthenticated())) {
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
        path: "${AppRoutes.campus}/:restaurantId",
        builder: (BuildContext context, GoRouterState state) {
          final String restaurantId = state.pathParameters["restaurantId"]!;
          return CampusScreen(restaurantId: restaurantId);
        },
      ),
      GoRoute(
        path: "${AppRoutes.categories}/:campusId",
        builder: (BuildContext context, GoRouterState state) {
          final CampusCardData data = state.extra as CampusCardData;
          return CategoriesScreen(campusData: data);
        },
      ),
      GoRoute(
        path: "${AppRoutes.products}/:campusCategoryId",
        builder: (BuildContext context, GoRouterState state) {
          final CategoryNavigationData data =
              state.extra as CategoryNavigationData;
          return ProductsByCategoryScreen(campusCategoryData: data);
        },
      ),
      GoRoute(
        path: "${AppRoutes.products}/:campusCategoryId/:productId",
        builder: (BuildContext context, GoRouterState state) {
          final ProductDetailNavigationData data =
              state.extra as ProductDetailNavigationData;
          return ProductDetailScreen(productDetailNavigationData: data);
        },
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
});
