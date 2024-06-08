import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../ar_core/ar.types.dart";
import "../../ar_core/ar_module.dart";
import "../../core/managers/secure_storage_manager.dart";
import "../../core/shared_preferences/services/shared_preferences.service.dart";
import "../../modules/auth/log_in/log_in_screen.dart";
import "../../modules/auth/onboarding/access_options_screen.dart";
import "../../modules/auth/onboarding/onboarding_screen.dart";
import "../../modules/auth/sign_up/sign_up_screen.dart";
import "../../modules/campus/campus_screen.dart";
import "../../modules/cart/cart_screen.dart";
import "../../modules/categories/categories_screen.dart";
import "../../modules/combos/combos_detail_navigations_data.types.dart";
import "../../modules/combos/combos_detail_screen.dart";
import "../../modules/combos/combos_screen.dart";
import "../../modules/home/home_screen.dart";

import "../../modules/product/menus/menu_detail_navigation_data.types.dart";
import "../../modules/product/menus/menus_detail_screen.dart";
import "../../modules/product/menus/menus_screen.dart";
import "../../modules/product/product_detail/product_detail_navigation_data.types.dart";
import "../../modules/product/product_detail/product_detail_screen.dart";
import "../../modules/product/products_list/category_navigation_data.types.dart";
import "../../modules/product/products_list/products_by_category_of_campus_screen.dart";
import "../../modules/promotions/promotion_combo_detail_screen.dart";
import "../../modules/promotions/promotion_navigations_data.types.dart";
import "../../modules/promotions/promotion_product_detail_screen.dart";
import "../../modules/promotions/promotions_screen.dart";
import "../../shared/widgets/features/campus-card/campus_card.types.dart";
import "observers/campus_observer.dart";
import "routes.dart";

final Provider<GoRouter> goRouterProvider =
    Provider<GoRouter>((ProviderRef<GoRouter> ref) {
  final SecureStorageManager storageManager = ref.watch(secureStorageProvider);
  final bool onboardingComplete =
      ref.watch(sharedPreferencesServiceProvider).getOnboardingComplete();

  final CampusRouteObserver routeObserver =
      CampusRouteObserver(ref.container); // Usar ref.container aquí

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: "/",
    observers: <NavigatorObserver>[routeObserver],
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
        path: AppRoutes.logIn,
        builder: (BuildContext context, GoRouterState state) =>
            const LogInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpScreen(),
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
        path: AppRoutes.cart,
        builder: (BuildContext context, GoRouterState state) =>
            const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.ar,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          final String urlGLB = args["urlGLB"];
          final NutritionalInformationAR nutritionalInformation =
              args["nutritionalInformation"];
          return ARScreen(
              urlGLB: urlGLB, nutritionalInformation: nutritionalInformation);
        },
      ),
      GoRoute(
        path: "${AppRoutes.categories}${AppRoutes.combos}/:campusId",
        builder: (BuildContext context, GoRouterState state) {
          final CampusCardData data = state.extra as CampusCardData;
          return CombosScreen(campusCardData: data);
        },
      ),
      GoRoute(
        path: "${AppRoutes.categories}${AppRoutes.combos}/:campusId/:comboId",
        builder: (BuildContext context, GoRouterState state) {
          final ComboDetailNavigationData data =
              state.extra as ComboDetailNavigationData;
          return CombosDetailScreen(comboDetailNavigationData: data);
        },
      ),
      GoRoute(
        path: "${AppRoutes.categories}${AppRoutes.menu}/:campusId",
        builder: (BuildContext context, GoRouterState state) {
          final CampusCardData data = state.extra as CampusCardData;
          return MenuScreen(campusCardData: data);
        },
      ),
      GoRoute(
        path: "${AppRoutes.categories}${AppRoutes.menu}/:campusId/:productId",
        builder: (BuildContext context, GoRouterState state) {
          final MenuDetailNavigationData data =
              state.extra as MenuDetailNavigationData;
          return MenusDetailScreen(menuDetailNavigationData: data);
        },
      ),
      GoRoute(
        path: "${AppRoutes.categories}${AppRoutes.promotions}/:campusId",
        builder: (BuildContext context, GoRouterState state) {
          final CampusCardData data = state.extra as CampusCardData;
          return PromotionsScreen(campusCardData: data);
        },
      ),
      GoRoute(
        path:
            "${AppRoutes.categories}${AppRoutes.promotions}${AppRoutes.combos}/:promotionId",
        builder: (BuildContext context, GoRouterState state) {
          final PromotionDetailNavigationData data =
              state.extra as PromotionDetailNavigationData;
          return PromotionCombosDetailScreen(
              promotionDetailNavigationData: data);
        },
      ),
      GoRoute(
        path:
            "${AppRoutes.categories}${AppRoutes.promotions}${AppRoutes.products}/:promotionId",
        builder: (BuildContext context, GoRouterState state) {
          final PromotionDetailNavigationData data =
              state.extra as PromotionDetailNavigationData;
          return PromotionProductDetailScreen(
              promotionDetailNavigationData: data);
        },
      )
    ],
    errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: Center(child: Text("Something went wrong: ${state.error}")),
    ),
  );
});
